`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 06:29:23 AM
// Design Name: 
// Module Name: TIS
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


module TIS (
    input  wire [7:0] p1,
    input  wire [7:0] p2,
    input  wire [7:0] p3,

    output wire [7:0] high,
    output wire [7:0] median,
    output wire [7:0] low
);

    wire [7:0] stage1_max;
    wire [7:0] stage1_min;
    wire [7:0] stage2_max;


    // Step 1: Compare p1 and p2
    CSU csu1 (
        .in1  (p1),
        .in2  (p2),
        .high (stage1_max),
        .low  (stage1_min)
    );


    // Step 2: Compare maximum of first pair with p3
    // Finds the absolute highest value
    CSU csu2 (
        .in1  (stage1_max),
        .in2  (p3),
        .high (high),
        .low  (stage2_max)
    );


    // Step 3: Compare remaining two values
    // Determines median and lowest values
    CSU csu3 (
        .in1  (stage1_min),
        .in2  (stage2_max),
        .high (median),
        .low  (low)
    );


endmodule