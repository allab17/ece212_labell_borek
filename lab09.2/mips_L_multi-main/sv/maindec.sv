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


module maindec (input logic clk, reset, [5:0] opcode,
                   output logic iord, alusrca, irwrite, pcwrite, regdst, memtoreg, regwrite, memwrite, branch,
                   output logic [1:0] alusrcb, aluop, pcsrc);
    
    enum logic [3:0] {
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
        JEX = 4'd11,
        ERROR = 4'd12
    } state, next;
    
    always_ff @(posedge clk) begin
        if (reset) state <= FETCH;
        else state <= next;         
    end
    
    always_comb begin
    iord = 1'b0;
    alusrca = 1'b0;
    alusrcb = 1'b0;
    aluop = 1'b0;
    pcsrc = 1'b0;
    irwrite = 1'b0;
    pcwrite = 1'b0;
    regdst = 1'b0;
    memtoreg = 1'b0;
    regwrite = 1'b0;
    memwrite = 1'b0;
    branch = 1'b0;
    next = FETCH;
    case (state)
        FETCH:
        begin
            iord = 1'b0;
            alusrca = 1'b0;
            alusrcb = 2'b01;
            aluop = 2'b00;
            pcsrc = 2'b00;
            irwrite = 1'b1;
            pcwrite = 1'b1;
            next = DECODE;
        end
        
        DECODE:
        begin
            alusrca = 1'b0;
            alusrcb = 2'b11;
            aluop = 2'b00;
            if (opcode == 6'b101011 || opcode == 6'b100011) next = MEMADR;
            else if (opcode == 6'd0) next = RTYPEEX;
            else if (opcode == 6'b000100) next = BEQEX;
            else if (opcode == 6'b001000) next = ADDIEX;
            else if (opcode == 6'b000010) next = JEX;
        end
        
        MEMADR:
        begin
            alusrca = 1'b1;
            alusrcb = 2'b10;
            aluop = 2'b00;
            if (opcode == 6'b101011) next = MEMWR;
            else if (opcode == 6'b100011) next = MEMRD;
        end
        
        MEMRD:
        begin
            iord = 1'b1;
            next = MEMWB;
        end
        
        MEMWB:
        begin
            regdst = 1'b0;
            memtoreg = 1'b1;
            regwrite = 1'b1;
            next = FETCH;
        end
        
        MEMWR:
        begin
            iord = 1'b1;
            memwrite = 1'b1;
            next = FETCH;
        end
        
        RTYPEEX:
        begin
            alusrca = 1'b1;
            alusrcb = 2'b00;
            aluop = 2'b10;
            next = RTYPEWB;
        end
        
        RTYPEWB:
        begin
            regdst = 1'b1;
            memtoreg = 1'b0;
            regwrite = 1'b1;
            next = FETCH;
        end
        
        BEQEX:
        begin
            alusrca = 1'b1;
            alusrcb = 2'b00;
            aluop = 2'b01;
            pcsrc = 2'b01;
            branch = 1'b1;
            next = FETCH;
        end
        
        ADDIEX:
        begin
            alusrca = 1'b1;
            alusrcb = 2'b10;
            aluop = 2'b00;
            next = ADDIWB;
        end
        
        ADDIWB:
        begin
            regdst = 1'b0;
            memtoreg = 1'b0;
            regwrite = 1'b1;
            next = FETCH;
        end
        
        JEX:
        begin
           pcsrc = 2'b10;
           pcwrite = 1'b1; 
           next = FETCH;
        end
        
        default: next = ERROR;
        
        ERROR: next = ERROR;

        endcase
    end
    
    
endmodule
