`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arian Nasr
// 
// Create Date: 12/16/2024 03:15:57 AM
// Design Name: 
// Module Name: GrayscaleVideoProcessor
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


module GrayscaleVideoProcessor(
    input wire [23:0] vid_data,
    input wire pHSync,
    input wire pVSync,
    input wire pVDE,
    input wire clk_pix,
    output wire [23:0] OUT_vid_data,
    output wire OUT_pHSync,
    output wire OUT_pVSync,
    output wire OUT_pVDE,
    output wire OUT_clk_pix
    );

    // Internal signals for grayscale conversion
    wire [7:0] redSignal;
    wire [7:0] greenSignal;
    wire [7:0] blueSignal;
    wire [15:0] grayPixel_wide; // Intermediate result to avoid overflow
    wire [7:0] grayPixel;

    // Assign input color channels
    assign redSignal = vid_data[23:16];
    assign greenSignal = vid_data[15:8];
    assign blueSignal = vid_data[7:0];

    // Grayscale conversion using weighted average
    // Using larger intermediate result to prevent overflow.
    assign grayPixel_wide = (12'h4c * redSignal) + (12'h97 * greenSignal) + (12'h1c * blueSignal);
    //Dividing by 256 (8 bits right shift) to normalize the sum
    assign grayPixel = grayPixel_wide[15:8];


    // Output grayscale to all color channels
    assign OUT_vid_data[23:16] = grayPixel; // Red channel
    assign OUT_vid_data[15:8] = grayPixel; // Green channel
    assign OUT_vid_data[7:0] = grayPixel;  // Blue channel

    // Synchronization signals simply pass through
    assign OUT_pHSync = pHSync;
    assign OUT_pVSync = pVSync;
    assign OUT_pVDE = pVDE;
    assign OUT_clk_pix = clk_pix;

endmodule
