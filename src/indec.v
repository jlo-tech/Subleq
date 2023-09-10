`timescale 1 ns/1 ns

/*
 * INDEC - Instruction Decoder
 *
 * ADDR = address width
 * 
 * inst = the instruction from memory
 
 * imm = flag if set take b as a immediate
 * exr = flag if set we read from external port take b as a immediate and substract it from the read input and jump to jt if result zero
 * exw = flag if set we write to external port take b as a immediate and substract it from value of a then jump to jt if result zero
 */
module INDEC #(parameter P_ADDR = 8)(inst, imm, exw, exr, a, b, jt);

input [3 + (P_ADDR * 3) - 1:0] inst;

output imm, exw, exr;
output [P_ADDR-1:0] a, b, jt;

assign imm = inst[P_ADDR*3+2];
assign exw = inst[P_ADDR*3+1];
assign exr = inst[P_ADDR*3];
assign a = inst[(P_ADDR*3)-1:P_ADDR*2];
assign b = inst[(P_ADDR*2)-1:P_ADDR];
assign jt = inst[P_ADDR-1:0];

endmodule

`ifdef TEST
module tb_INDEC;

localparam P_A = 4;

/* Inputs */
reg [3 + (P_A * 3)] inst;

/* Outputs */
wire imm, exw, exr;
wire [P_A-1:0] a, b, jt;

INDEC #(P_A) dut (.inst(inst), .imm(imm), .exw(exw), .exr(exr), .a(a), .b(b), .jt(jt));

initial begin

    $dumpfile("trace_indec.vcd");
    $dumpvars(0, dut);
    
    inst = 0;
    #1;

    inst = {1'b1, 1'b0, 1'b1, 4'b0101, 4'b1001, 4'b1101};
    #1;

    inst = {1'b0, 1'b1, 1'b0, 4'b0101, 4'b1001, 4'b1101};
    #1;

    inst = {1'b0, 1'b1, 1'b0, 4'b0111, 4'b1011, 4'b0001};
    #1;
    
end

endmodule
`endif
