//--------------------------------------------------------------------
// datapath.sv - Multicycle MIPS datapath
// David_Harris@hmc.edu 23 October 2005
// David_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// Refactored into separate files & updated using additional SystemVerilog
// features by John Nestor May 2018
// Key modifications to this module:
//  1. Use enums from new package to make opcode & function codes
//     display symbolic names  during simulation
//  2. Explicitly break out and use instruction subfields (opcode, rs, rt, etc.
//
//--------------------------------------------------------------------

// The datapath unit is a structural verilog module.  That is,
// it is composed of instances of its sub-modules.  For example,
// the instruction register is instantiated as a 32-bit flopenr.
// The other submodules are likewise instantiated.

module datapath(
    input  logic        clk, reset,
    input logic         pcen, irwrite, regwrite,
    input logic         alusrca, iord, memtoreg, regdst,
    input logic [1:0]   alusrcb, pcsrc,
    input logic [2:0]   alucontrol,
    output mips_decls_p::opcode_t opcode,
    output mips_decls_p::funct_t funct,
    output logic        zero,
    output logic [31:0] adr, writedata,
    input logic [31:0]  readdata
    );


   import mips_decls_p::*;

   // instruction fields
   logic [31:0]                     instr;
   logic [4:0]                      rs, rt, rd;  // register fields
   logic [15:0]                     immed;       // i-type immediate field
   logic [25:0]                     jmpimmed;    // j-type pseudo-address
   
   logic [31:0] pc, pcnext, aluresult, aluout, data, writetoreg, regtoa, regtob, aout, signimm, signimmshift2, srca, srcb, jshift;
   logic [4:0] dst;

  // extract instruction fields from instruction
   assign opcode = opcode_t'(instr[31:26]);
   assign funct = funct_t'(instr[5:0]);
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign immed = instr[15:0];
   assign jmpimmed = instr[25:0];
   
  


   // Your datapath hardware goes below.  Instantiate each of the submodules
   // that you need.  Feel free to copy ALU, muxes and other modules from
   // Lab 9.  This directory also includes parameterizable multipliexers
   // mux3.sv (paramaterized 3:1) and mux4.sv (paramterized 4:1)
   // Make sure to instantiate with the correct bitwidth!

   // Remember to give your instantiated modules applicable instance names
   // such as U_PCREG (PC register), U_WDMUX (Write Data Mux), etc.
   // so it's easier to find them during simulation and debugging.
   
   // next PC logic
    flopenr #(32) U_PC_REG(.clk(clk), .reset(reset), .d(pcnext), .en(pcen), .q(pc));

    mux2 #(32) U_MUX_IORD(.d0(pc), .d1(aluout), .s(iord), .y(adr));

    flopenr #(32) U_IR_REG(.clk(clk), .reset(reset), .d(readdata), .en(irwrite), .q(instr));
    
    flopr #(32) U_MDR_REG(.clk(clk), .reset(reset), .d(readdata), .q(data));
    
    mux2 #(32) U_MUX_MEMTOREG(.d0(aluout), .d1(data), .s(memtoreg), .y(writetoreg));

    mux2 #(5) U_MUX_REGDST (.d0(rt), .d1(rd), .s(regdst), .y(dst));
   
    regfile U_REGFILE (.clk, .we3(regwrite), .ra1(rs), .ra2(rt), .wa3(dst), .wd3(writetoreg), .rd1(regtoa), .rd2(regtob));
   
    flopr #(32) U_A_REG(.clk(clk), .reset(reset), .d(regtoa), .q(aout));
   
    flopr #(32) U_B_REG(.clk(clk), .reset(reset), .d(regtob), .q(writedata));

    signext U_SIGNEXT(.a(immed), .y(signimm));
    
    assign signimmshift2 = signimm << 2;
    
    mux2 #(32) U_MUX_ALUSRCA(.d0(pc), .d1(aout), .s(alusrca), .y(srca));
    
    mux4 #(32) U_MUX_ALUSRCB(.d0(writedata), .d1(32'd4), .d2(signimm), .d3(signimmshift2), .s(alusrcb), .y(srcb));

    alu U_ALU (.a(srca), .b(srcb), .f(alucontrol), .y(aluresult), .zero);
    
    flopenr #(32) U_ALU_REG(.clk(clk), .reset(reset), .d(aluresult), .en(1'b1), .q(aluout));
    
    assign jshift = { pc[31:26], (jmpimmed << 2) }; 
    
    mux3 #(32) U_MUX_PCSRC(.d0(aluresult), .d1(aluout), .d2(jshift), .s(pcsrc), .y(pcnext));


endmodule
