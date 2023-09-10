`timescale 1 ns/1 ns

/*
 * RAM
 *
 * ADDR = address width
 * DATA = data width
 * DEPTH = number of memory cells
 * 
 * clk = clock
 * rw = read / write
 * addr = address
 * din = data input
 * dout = data output
 */

module RAM #(parameter P_ADDR = 8, P_DATA = 8, P_MEM = 256)(clk, rw, addr, din, dout);

input clk, rw;
input [P_ADDR-1:0] addr;
input [P_DATA-1:0] din;

output reg [P_DATA-1:0] dout = 0;

reg [P_DATA-1:0] storage [P_MEM-1:0];

genvar i;
generate
    for(i = 0; i < P_MEM; i = i + 1) begin
        initial storage[i] = 0;
    end
endgenerate

always @(posedge clk) begin
    if (rw) begin
        storage[addr] <= din;
    end else begin
        dout <= storage[addr];
    end
end

endmodule

`ifdef TEST
module tb_RAM;

localparam P_A = 4;
localparam P_D = 4;
localparam P_M = 16;

reg clk;
reg rw;
reg [P_A-1:0] addr;
reg [P_D-1:0] din;
wire [P_D-1:0] dout;

RAM #(P_A, P_D, P_M) dut (.clk(clk), .rw(rw), .addr(addr), .din(din), .dout(dout));

integer i;

initial begin
    
    $dumpfile("trace_ram.vcd");
    $dumpvars(0, dut);

    clk = 0;
    rw = 0;
    addr = 0;
    din = 0;
 
    #1;

    /* Writing */
    for (i = 0; i < P_M; i = i + 1) begin
        clk = 0;
        rw = 1;
        addr = i;
        din = i;

        #1;

        clk = 1;

        #1;
    end

    /* Reading */
    for (i = 0; i < P_M; i = i + 1) begin
        clk = 0;
        rw = 0;
        addr = i;
        din = 0;

        #1;

        clk = 1;

        #1;
    end

end

endmodule
`endif