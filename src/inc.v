`timescale 1 ns/1 ns

/* 
 * INC - Incrementor
 */
module INC #(parameter P_DATA = 8) (d, q);

input [P_DATA-1:0] d;
output [P_DATA-1:0] q;

assign q = d + 1;

endmodule

`ifdef TEST
module tb_INC;

localparam P_D = 4;

reg [P_D-1:0] d;
wire [P_D-1:0] q;

INC #(P_D) dut (d, q);

integer i;

initial begin

    $dumpfile("trace_inc.vcd");
    $dumpvars(0, dut);

    for(i = 0; i < 20; i++) begin
        d = i;
        #1;
    end
end

endmodule
`endif