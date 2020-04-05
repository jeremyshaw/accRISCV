module top(input CLOCK_50,
output [7:0] LED,
input [1:0] KEY,
input [3:0] SW
);

wire clock;
wire reset;
wire [31:0] inst;
wire [31:0] acc;
wire [31:0] x;
wire sr;


clkDiv clkDiv_1(CLOCK_50, clock);
accRISCV CPU_1(clock, reset, inst, acc, x, sr);



endmodule
