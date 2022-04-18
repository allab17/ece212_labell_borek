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
                   output logic iord, alusrca, [1:0] alusrcb, [1:0] aluop, [1:0] pcsource, irwrite, pcwrite, regdst, memtoreg, regwrite, memwrite, branch 
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
    iord = 0;
    alusrca = 0;
    alusrcb = 0;
    aluop = 0;
    pcsource = 0;
    irwrite = 0;
    pcwrite = 0;
        case (state)
        FETCH:
        begin
            iord = 0;
            alusrca = 0;
            alusrcb = 01;
            aluop = 00;
            pcsource = 00;
            irwrite = 1;
            pcwrite = 1;
            next = DECODE;
        end
        
        DECODE:
        begin
            alusrca = 0;
            alusrcb = 2'b11;
            aluop = 2'b00;
            if (op == 6'b101011 || op == 6'b100011) next = MEMADR;
            if (op == 6'd0) next = RTYPEEX;
            if (op == 6'b000100) next = BEQEX;
            if (op == 6'b001000) next = ADDIEX;
            if (op == 6'b000010) next = JEX;
        end
        
        MEMADR:
        begin
            alusrca = 1;
            alusrcb = 2'b10;
            aluop = 2'b00;
            if (op == 6'b101011) next = MEMWR;
            if (op == 6'b100011) next = MEMRD;
        end
        
        MEMRD:
        begin
            iord = 1;
            next = MEMWB;
        end
        
        MEMWB:
        begin
            regdst = 0;
            memtoreg = 1;
            regwrite = 1;
            next = FETCH;
        end
        
        MEMWR:
        begin
            iord = 1;
            memwrite = 1;
            next = FETCH;
        end
        
        RTYPEEX:
        begin
            alusrca = 1;
            alusrcb = 2'b00;
            aluop = 2'b10;
            next = RTYPEWB;
        end
        
        RTYPEWB:
        begin
            regdst = 1;
            memtoreg = 0;
            regwrite = 1;
            next = FETCH;
        end
        
        BEQEX:
        begin
            alusrca = 1;
            alusrcb = 2'b00;
            aluop = 2'b01;
            pcsource = 2'b01;
            branch = 1;
            next = FETCH;
        end
        
        ADDIEX:
        begin
            alusrca = 1;
            alusrcb = 2'b10;
            aluop = 2'b00;
            next = ADDIWB;
        end
        
        ADDIWB:
        begin
            regdst = 0;
            memtoreg = 0;
            regwrite = 1;
            next = FETCH;
        end
        
        JEX:
        begin
           pcsource = 2'b10;
           pcwrite = 1; 
           next = FETCH;
        end
        
        default:
        begin
            iord = 0;
            alusrca = 0;
            alusrcb = 0;
            aluop = 0;
            pcsource = 0;
            irwrite = 0;
            pcwrite = 0;
        end

        endcase
    end
    
    
endmodule
