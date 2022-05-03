`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2022 01:41:27 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(input logic memtoreg_e, regwrite_e, regwrite_m, regwrite_w, branch_d, writereg_e, writereg_m, writereg_w, 
                    input logic [4:0] rs_e, rs_d, rt_e, rt_d,
                    output logic [1:0] forward_ae, forward_be,  
                    output logic stall_f, stall_d, flush_e, forward_ad, forward_bd
    );
    
    logic lwstall;
    logic branchstall;
    
    //if the same source and destination register are matched, hence data is needed in execute stage for ALU computation
    //then forward from the corresponding stage
    always_comb begin
        if ((rs_e != '0) && (rs_e == writereg_m) && regwrite_m) begin
            forward_ae = 2'b10;
        end
        else if ((rs_e != '0) && (rs_e == writereg_w) && regwrite_w) begin
            forward_ae = 2'b01;
        end
        else forward_ae = 2'b00;
        
        if ((rt_e != '0) && (rt_e == writereg_m) && regwrite_m) begin
            forward_be = 2'b10;
        end
        else if ((rt_e != '0) && (rt_e == writereg_w) && regwrite_w) begin
            forward_be = 2'b01;
        end
        else forward_be = 2'b00;
        
        //case one, data needed in decode stage, hazard detected source and destination matched in data memory stage of pipeline, forward from data memory stage
        if ((rs_d != '0) && (rs_d == writereg_m) && regwrite_m && branch_d) begin
            forward_ad = 1'b1;
        end
        else forward_ad = 1'b0;
        
        if ((rt_d != '0) && (rt_d == writereg_m) && regwrite_m && branch_d) begin
            forward_bd = 1'b1;
        end
        else forward_bd = 1'b0;
        
        //hazard, data dependency in execute stage for alu computation
        //create lwstall and branchstall
        
        if ((rs_d != '0) && (rs_d == writereg_e) && regwrite_e && branch_d) begin
            branchstall = 1'b1;
        end
        else if ((rs_d != '0) && (rs_d == writereg_e) && regwrite_e && branch_d) begin
            branchstall = 1'b1;
        end
        else branchstall = 1'b0;
        
        //lw 
        if ((rs_d != '0) && (rs_d == writereg_m) && memtoreg_e && branch_d) begin
            lwstall = 1'b1;
        end
        else lwstall = 1'b0;
        
        if ((rt_d != '0) && (rt_d == writereg_m) && memtoreg_e && branch_d) begin
            lwstall = 1'b1;
        end
        else lwstall = 1'b0;
        
        
        if (branchstall || lwstall) begin
            //if either are high, we stall and flush the pipeline
            stall_f = 1'b1;
            stall_d = 1'b1;
            flush_e = 1'b1;
        end
        else begin
            stall_f = 1'b0;
            stall_d = 1'b0;
            flush_e = 1'b0;
        end
        
        
        
        
        
    end
    
    
    
endmodule
