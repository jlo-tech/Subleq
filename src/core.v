`timescale 1 ns/1 ns

/* 
 * Core
 *
 * inp: Input port
 * oup: Output port
 */
module CORE #(parameter P_ADDR = 8, P_DATA = 8, P_RAM_MEM = 256, P_ROM_MEM = 256)(clk, inp, oup);

input clk;

input [P_DATA-1:0] inp;
output [P_DATA-1:0] oup;

/* ALU */
wire alu_zero;
wire [P_DATA-1:0] alu_a_in, alu_b_in;
wire [P_DATA-1:0] alu_result;

/* PC */
wire pc_write_enable;
wire [P_ADDR-1:0] pc_in;
wire [P_ADDR-1:0] pc_out;

REGISTER #(P_ADDR) pc (clk, pc_write_enable, pc_in, pc_out);

/* Instruction memory */
wire [3 + P_ADDR + P_ADDR + P_ADDR - 1:0] instruction;
ROM #(P_ADDR, 3 + (P_ADDR * 3), P_ROM_MEM) imem (pc_out, instruction);

/* PC INC */
wire [P_ADDR-1:0] pc_incremented;
INC #(P_DATA) pc_incrementer (pc_out, pc_incremented);

/* Instruction decoder */
wire imm, exw, exr;
wire [P_ADDR-1:0] a_addr, b_addr, jump_target;
INDEC #(P_ADDR) instruction_decoder (instruction, imm, exw, exr, a_addr, b_addr, jump_target);

/* PC MUX */
MUX #(P_DATA) pc_mux (alu_zero, pc_incremented, jump_target, pc_in);

/* RAM ADDR MUX */
wire selop;
wire [P_ADDR-1:0] ram_addr;
MUX #(P_DATA) ram_addr_mux (selop, a_addr, b_addr, ram_addr);

/* Data memory */
wire ram_write_enable;
wire [P_DATA-1:0] ram_data_out;
RAM #(P_ADDR, P_DATA, P_RAM_MEM) dmem (clk, ram_write_enable, ram_addr, alu_result, ram_data_out);

/* A Register */
wire a_reg_write_enable;
wire [P_DATA-1:0] a_reg_value;
REGISTER #(P_DATA) a_reg (clk, a_reg_write_enable, ram_data_out, a_reg_value);

/* B Register */
wire b_reg_write_enable;
wire [P_DATA-1:0] b_reg_value;
REGISTER #(P_DATA) b_reg (clk, b_reg_write_enable, ram_data_out, b_reg_value);

/* ALU input selectors */
MUX #(P_DATA) a_mux (exr, a_reg_value, inp, alu_a_in);
MUX #(P_DATA) b_mux ((exr || exw || imm), b_reg_value, b_addr, alu_b_in);

/* ALU */
ALU #(P_DATA) alu (alu_a_in, alu_b_in, alu_result, alu_zero);

/* Output port MUX and REGISTER */
wire [P_DATA-1:0] port_value;
MUX #(P_DATA) port_mux (exw, 8'b0, alu_result, port_value);
REGISTER #(P_DATA) port_register (clk, (ram_write_enable && exw), port_value, oup);

CONTROLLER controller(clk, selop, a_reg_write_enable, b_reg_write_enable, ram_write_enable, pc_write_enable);

endmodule
