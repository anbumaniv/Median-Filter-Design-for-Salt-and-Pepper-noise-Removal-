module sap (
    input              clk,
    input              i_pixel_valid,
    input      [71:0]  i_pixel_window,
    input      [7:0]   i_threshold_T,
    output reg [7:0]   o_filtered_pixel,
    output reg         o_filtered_valid
);

wire [7:0] p [0:8];

assign p[0] = i_pixel_window[7:0];
assign p[1] = i_pixel_window[15:8];
assign p[2] = i_pixel_window[23:16];
assign p[3] = i_pixel_window[31:24];
assign p[4] = i_pixel_window[39:32];
assign p[5] = i_pixel_window[47:40];
assign p[6] = i_pixel_window[55:48];
assign p[7] = i_pixel_window[63:56];
assign p[8] = i_pixel_window[71:64];

wire [7:0] median_pixel;

spatial_median_sorter MEDIAN_CORE (
    .o_median(median_pixel),
    .i_p0(p[0]), .i_p1(p[1]), .i_p2(p[2]),
    .i_p3(p[3]), .i_p4(p[4]), .i_p5(p[5]),
    .i_p6(p[6]), .i_p7(p[7]), .i_p8(p[8])
);

wire valid [0:8];

genvar i;
generate
    for(i=0;i<9;i=i+1) begin : valid_gen
        assign valid[i] = (p[i] > 0 && p[i] < 255);
    end
endgenerate

wire [3:0] V =
    valid[0]+valid[1]+valid[2]+
    valid[3]+valid[4]+valid[5]+
    valid[6]+valid[7]+valid[8];

wire [3:0] cnt0 =
    (p[0]==0)+(p[1]==0)+(p[2]==0)+
    (p[3]==0)+(p[4]==0)+(p[5]==0)+
    (p[6]==0)+(p[7]==0)+(p[8]==0);

wire [3:0] cnt255 =
    (p[0]==255)+(p[1]==255)+(p[2]==255)+
    (p[3]==255)+(p[4]==255)+(p[5]==255)+
    (p[6]==255)+(p[7]==255)+(p[8]==255);

reg [7:0] single_valid;
integer k;

always @(*) begin
    single_valid = 8'd0;
    for(k=0;k<9;k=k+1)
        if(valid[k])
            single_valid = p[k];
end

reg [15:0] sum;
reg [4:0] wsum;

always @(*) begin
    sum  = 16'd0;
    wsum = 5'd0;

    if(valid[0]) begin sum = sum + p[0];      wsum = wsum + 1; end
    if(valid[1]) begin sum = sum + (p[1]<<1); wsum = wsum + 2; end
    if(valid[2]) begin sum = sum + p[2];      wsum = wsum + 1; end
    if(valid[3]) begin sum = sum + (p[3]<<1); wsum = wsum + 2; end
    if(valid[4]) begin sum = sum + (p[4]<<2); wsum = wsum + 4; end
    if(valid[5]) begin sum = sum + (p[5]<<1); wsum = wsum + 2; end
    if(valid[6]) begin sum = sum + p[6];      wsum = wsum + 1; end
    if(valid[7]) begin sum = sum + (p[7]<<1); wsum = wsum + 2; end
    if(valid[8]) begin sum = sum + p[8];      wsum = wsum + 1; end
end

reg [7:0] weighted_avg;

always @(*) begin
    case(wsum)
        2  : weighted_avg = sum >> 1;
        4  : weighted_avg = sum >> 2;
        6  : weighted_avg = sum / 6;
        8  : weighted_avg = sum >> 3;
        10 : weighted_avg = sum / 10;
        default : weighted_avg = median_pixel;
    endcase
end

wire [7:0] abs_dev;

assign abs_dev = (p[4] > median_pixel) ?
                 (p[4] - median_pixel) :
                 (median_pixel - p[4]);

wire is_clean_pixel;

assign is_clean_pixel =
        (p[4] > 8'd0) &&
        (p[4] < 8'd255) &&
        (abs_dev <= i_threshold_T);

always @(posedge clk) begin
    if(i_pixel_valid) begin

        if(is_clean_pixel)
            o_filtered_pixel <= p[4];

        else if(V==0) begin
            if(cnt0 > cnt255)
                o_filtered_pixel <= 8'd0;
            else if(cnt255 > cnt0)
                o_filtered_pixel <= 8'd255;
            else
                o_filtered_pixel <= median_pixel;
        end

        else if(V >= 5)
            o_filtered_pixel <= median_pixel;

        else if(V >= 2)
            o_filtered_pixel <= weighted_avg;

        else
            o_filtered_pixel <= single_valid;

        o_filtered_valid <= 1'b1;
    end
    else begin
        o_filtered_valid <= 1'b0;
    end
end

endmodule