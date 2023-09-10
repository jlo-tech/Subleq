module REGISTER #(parameter P_DATA = 8) (clk, we, din, dout);

input clk, we;
input [P_DATA-1:0] din;
output [P_DATA-1:0] dout;

reg [P_DATA-1:0] val = 0;

always @(posedge clk) begin
    if (we == 1) begin
        val <= din;
    end
end

assign dout = val;

endmodule

`ifdef TEST
module tb_REGISTER;

localparam P_A = 8;

reg clk, we;
reg [P_A-1:0] din;
wire [P_A-1:0] dout;

REGISTER #(P_A) dut (clk, we, din, dout);

initial begin

    $dumpfile("trace_REGISTER.vcd");
    $dumpvars(0, dut);

    clk = 0;
    we = 0;
    din = 0;
    #1;

    clk = 1;
    we = 1;
    din = 5;
    #1;

    clk = 0;
    we = 0;
    din = 0;
    #1;

    clk = 1;
    we = 0;
    din = 0;
    #1;

end

endmodule
`endif