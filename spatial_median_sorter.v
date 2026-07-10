`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 06:34:15 AM
// Design Name: 
// Module Name: spatial_median_sorter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spatial_median_sorter (
    input  wire [7:0] P1,   // Unused input
    input  wire [7:0] P2,
    input  wire [7:0] P3,   // Unused input
    input  wire [7:0] P4,
    input  wire [7:0] P5,   // Center Pixel
    input  wire [7:0] P6,
    input  wire [7:0] P7,   // Unused input
    input  wire [7:0] P8,
    input  wire [7:0] P9,   // Unused input

    output wire [7:0] Approx_Median
);


    // Intermediate signals
    wire [7:0] dummy_col_h;
    wire [7:0] dummy_col_l;

    wire [7:0] dummy_row_h;
    wire [7:0] dummy_row_l;

    wire [7:0] dummy_final_h;
    wire [7:0] dummy_final_l;

    wire [7:0] M_R;   // Row median
    wire [7:0] M_C;   // Column median


    // Column median calculation
    // Uses vertical pixels: P2, P5, P8
    TIS median_column_sorter (
        .p1    (P2),
        .p2    (P5),
        .p3    (P8),
        .high  (dummy_col_h),
        .median(M_R),
        .low   (dummy_col_l)
    );


    // Row median calculation
    // Uses horizontal pixels: P4, P5, P6
    TIS median_row_sorter (
        .p1    (P4),
        .p2    (P5),
        .p3    (P6),
        .high  (dummy_row_h),
        .median(M_C),
        .low   (dummy_row_l)
    );


    // Final approximate median computation
    // Uses row median, center pixel, and column median
    TIS final_median_sorter (
        .p1    (M_R),
        .p2    (P5),
        .p3    (M_C),
        .high  (dummy_final_h),
        .median(Approx_Median),
        .low   (dummy_final_l)
    );


endmodule
