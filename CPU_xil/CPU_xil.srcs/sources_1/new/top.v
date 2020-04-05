`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2020 12:05:34 AM
// Design Name: 
// Module Name: top
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



module top(
    input sysclk,
    output [3:0] led,
    input [3:0] sw
);

    wire clock;
    wire reset;
    wire [31:0] inst;
    wire [31:0] acc;
    wire [31:0] x;
    wire sr;
    
    
    clkDiv clkDiv_1(sysclk, clock);
    accRISCV CPU_1(clock, reset, inst, acc, x, sr);
    assign led[0] = clock;
endmodule
