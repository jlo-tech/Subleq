`timescale 1 ns/1 ns

/*
 * ALU 
 *
 * N = bit width
 *
 * a b = operands
 * r = result of substraction
 * z = high when result is zero
 *
 */
module ALU #(parameter P_DATA = 8)(a, b, r, z);

input [P_DATA-1:0] a;
input [P_DATA-1:0] b;

output [P_DATA-1:0] r;
output z;

assign r = $signed(a) - $signed(b);
assign z = ($signed($signed(a) - $signed(b)) <= 0) ? 1 : 0;

endmodule

`ifdef TEST
/*
 *
 * ALU Testbench
 *
 */
module tb_ALU;

localparam n = 8;

reg [n-1:0] a;
reg [n-1:0] b;
wire [n-1:0] r;
wire z;

ALU #(n) dut (a, b, r, z);

initial begin

    $dumpfile("trace_alu.vcd");
    $dumpvars(0, dut);

    a = 0;
    b = 0;

    #1;

    a = 4;
    b = 2;

    #1;

    a = 56;
    b = 98;

    #1;

    a = 45;
    b = 45;
    #1;

    a = 56;
    b = 45;
    #1;

end

endmodule
`endif