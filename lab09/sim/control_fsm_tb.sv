`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2022 05:16:43 PM
// Design Name: 
// Module Name: control_fsm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_fsm_tb();

logic clk, rst;
logic [5:0] op;
 logic IorD, ALUSrcA, IRWrite, PCWrite, RegDst, MemToReg, RegWrite, MemWrite, Branch;
 logic [1:0] ALUSrcB, ALUOp, PCSource;
 
 control_fsm DUV(.clk, .rst, .op, .IorD, .ALUSrcA, .IRWrite, .PCWrite, .RegDst, .MemToReg, .RegWrite, .MemWrite, .Branch, .ALUSrcB, .ALUOp, .PCSource);
 
parameter CLK_PD = 10;
       
       always begin
            clk = 1'b0; #(CLK_PD/2);
            clk = 1'b1; #(CLK_PD/2);
       end
    
    
 initial begin
    rst = 1; @(posedge clk)#1; 
    rst = 0;
    op = 6'b100011; #(CLK_PD*5);
    op = 6'b000000; #(CLK_PD*4);
    op = 6'b000100; #(CLK_PD*3);
    op = 6'b001000; #(CLK_PD*4);
    op = 6'b000010; #(CLK_PD*3);
 $stop;
 end


 


endmodule
