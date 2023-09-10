`timescale 1 ns/1 ns

/* Turn of tests by uncommenting the following line */
// `define TEST

module SUBLEQ(clk, inp, oup);

localparam A = 8;
localparam D = 8;
localparam I_MEM = 16; 
localparam D_MEM = 256;

input clk;
input [D-1:0] inp;
output [D-1:0] oup;

CORE #(A, D, D_MEM, I_MEM) core (clk, inp, oup);

endmodule

`ifdef TEST
module tb_CPU;

localparam A = 8;
localparam D = 8;
localparam I_MEM = 16; 
localparam D_MEM = 256;

reg clk = 0;

reg [D-1:0] inp = 1;
wire [D-1:0] oup;

CORE #(A, D, D_MEM, I_MEM) core (clk, inp, oup);

initial begin
    
    $dumpfile("trace_cpu.vcd");
    $dumpvars(0, core);

    for(integer i = 0; i < I_MEM * 4; i = i + 1) begin
        clk = 0;
        #1;
        clk = 1;
        #1;
    end
end

endmodule
`endif
