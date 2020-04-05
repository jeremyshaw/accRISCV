`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2020 12:05:34 AM
// Design Name: 
// Module Name: clkDiv
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

module clkDiv(
    input clock_in,
    output reg clock_out
    );
    
    reg [26:0] count;
    
    initial count = 32'b0;	// why was this setup as 32bits?
    always @ (posedge clock_in) begin
        if (count[22] == 1'b1) begin
            count = 0;
				clock_out = ~clock_out;
        end
        else begin
            count = count + 1;
        end
    end

endmodule