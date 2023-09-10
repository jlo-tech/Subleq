`timescale 1 ns/1 ns

module MUX #(parameter P_DATA = 8) (sel, a, b, q);

input sel;
input [P_DATA-1:0] a, b;
output [P_DATA-1:0] q;

assign q = (sel == 1) ? b : a;

endmodule 

`ifdef TEST
module tb_MUX;

localparam P_D = 4;

reg sel;
reg [P_D-1:0] a, b;
wire [P_D-1:0] q;

MUX #(P_D) dut (.sel(sel), .a(a), .b(b), .q(q));

initial begin

    $dumpfile("trace_mux.vcd");
    $dumpvars(0, dut);

    sel = 0;
    a = 2;
    b = 5;
    #1;

    sel = 1;
    #1;

end

endmodule
`endif 