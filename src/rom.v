`timescale 1 ns/1 ns

module ROM #(parameter P_ADDR = 8, P_DATA = 8, P_MEM = 256)(addr, data);

input [P_ADDR-1:0] addr;
output [P_DATA-1:0] data;

reg [P_DATA-1:0] storage [P_MEM-1:0];

initial begin
    storage[0] = 27'b100000000001000001000000001; // SUBLEQ.IMM  0 -126  1 # PUT -126 in MEM[0]
    storage[1] = 27'b001000001000000000000000010; // SUBLEQ.EXR  4    0  2 # READ from INP and save in MEM[4]
    storage[2] = 27'b010000001000000000000000011; // SUBLEQ.EXW  4    0  3 # WRITE to OUP from MEM[4]
    storage[3] = 27'b000000000000000000000000011; // SUBLEQ      0    0  3 # Loop and put 0 in MEM[0]
    storage[4] = 27'b000000000000000000000000000; 
    storage[5] = 27'b000000000000000000000000000; 
    storage[6] = 27'b000000000000000000000000000; 
    storage[7] = 27'b000000000000000000000000000;
    storage[8] = 27'b000000000000000000000000000; 
    storage[9] = 27'b000000000000000000000000000; 
    storage[10] = 27'b000000000000000000000000000; 
    storage[11] = 27'b000000000000000000000000000;
    storage[12] = 27'b000000000000000000000000000;
    storage[13] = 27'b000000000000000000000000000;
    storage[14] = 27'b000000000000000000000000000;
    storage[15] = 27'b000000000000000000000000000;
end

assign data = storage[addr];

endmodule

`ifdef TEST
module tb_ROM;

localparam P_A = 4;
localparam P_D = 4;
localparam P_M = 4;

reg [P_A-1:0] a;
wire [P_D-1:0] d;

ROM #(P_A, P_D, P_M) dut (a, d);

initial begin

    $dumpfile("trace_rom.vcd");
    $dumpvars(0, dut);

    a = 0;
    #1;

    a = 0;
    #1;

    a = 1;
    #1;

    a = 2;
    #1;

    a = 3;
    #1;

end

endmodule
`endif