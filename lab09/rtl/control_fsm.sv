`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 01:55:16 PM
// Design Name: 
// Module Name: control_fsm
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


module control_fsm(input logic clk, rst, [5:0] op,
                   output logic IorD, ALUSrcA, [1:0] ALUSrcB, [1:0] ALUOp, [1:0] PCSource, IRWrite, PCWrite, RegDst, MemToReg, RegWrite, MemWrite, Branch 
            );
    
    typedef enum logic [3:0] {
        FETCH = 4'd0,
        DECODE = 4'd1,
        MEMADR = 4'd2,
        MEMRD = 4'd3,
        MEMWB = 4'd4,
        MEMWR = 4'd5,
        RTYPEEX = 4'd6,
        RTYPEWB = 4'd7,
        BEQEX = 4'd8,
        ADDIEX = 4'd9,
        ADDIWB = 4'd10,
        JEX = 4'd11
    } State;
    
    State state, next;
    
    always_ff @(posedge clk) begin
    if (rst) state <= FETCH;
    else state <= next;     
        
    end
    
    always_comb begin
    IorD = 0;
    ALUSrcA = 0;
    ALUSrcB = 0;
    ALUOp = 0;
    PCSource = 0;
    IRWrite = 0;
    PCWrite = 0;
        case (state)
        FETCH:
        begin
            IorD = 0;
            ALUSrcA = 0;
            ALUSrcB = 01;
            ALUOp = 00;
            PCSource = 00;
            IRWrite = 1;
            PCWrite = 1;
            next = DECODE;
        end
        
        DECODE:
        begin
            ALUSrcA = 0;
            ALUSrcB = 2'b11;
            ALUOp = 2'b00;
            if (op == 6'b101011 || op == 6'b100011) next = MEMADR;
            if (op == 6'd0) next = RTYPEEX;
            if (op == 6'b000100) next = BEQEX;
            if (op == 6'b001000) next = ADDIEX;
            if (op == 6'b000010) next = JEX;
        end
        
        MEMADR:
        begin
            ALUSrcA = 1;
            ALUSrcB = 2'b10;
            ALUOp = 2'b00;
            if (op == 6'b101011) next = MEMWR;
            if (op == 6'b100011) next = MEMRD;
        end
        
        MEMRD:
        begin
            IorD = 1;
            next = MEMWB;
        end
        
        MEMWB:
        begin
            RegDst = 0;
            MemToReg = 1;
            RegWrite = 1;
            next = FETCH;
        end
        
        MEMWR:
        begin
            IorD = 1;
            MemWrite = 1;
            next = FETCH;
        end
        
        RTYPEEX:
        begin
            ALUSrcA = 1;
            ALUSrcB = 2'b00;
            ALUOp = 2'b10;
            next = RTYPEWB;
        end
        
        RTYPEWB:
        begin
            RegDst = 1;
            MemToReg = 0;
            RegWrite = 1;
            next = FETCH;
        end
        
        BEQEX:
        begin
            ALUSrcA = 1;
            ALUSrcB = 2'b00;
            ALUOp = 2'b01;
            PCSource = 2'b01;
            Branch = 1;
            next = FETCH;
        end
        
        ADDIEX:
        begin
            ALUSrcA = 1;
            ALUSrcB = 2'b10;
            ALUOp = 2'b00;
            next = ADDIWB;
        end
        
        ADDIWB:
        begin
            RegDst = 0;
            MemToReg = 0;
            RegWrite = 1;
            next = FETCH;
        end
        
        JEX:
        begin
           PCSource = 2'b10;
           PCWrite = 1; 
           next = FETCH;
        end
        
        default:
        begin
            IorD = 0;
            ALUSrcA = 0;
            ALUSrcB = 0;
            ALUOp = 0;
            PCSource = 0;
            IRWrite = 0;
            PCWrite = 0;
        end

        endcase
    end
    
    
endmodule
