`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2022 07:46:38 PM
// Design Name: 
// Module Name: dig_clock
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


module dig_clock(input logic clk, rst, adv_hr, adv_min, military_t,
                output logic [6:0] h1, h0, m1, m0, s1, s0, am_pm
    );
    
    logic enb;
    logic clr = 1'd0;
    
    logic n1, n2, n3;
    
    period_enb #(.PERIOD_MS(1000)) U_PEBB (.clk, .rst, .clr(clr), .enb_out(enb));
    
    count_s U_COUNT_S(.clk, .rst, .enb, .cy(n1), .s1, .s0);
    count_m U_COUNT_M(.clk, .rst, .enb(n1), .adv_min, .cy(n2), .m1, .m0);
    count_h U_COUNT_H(.clk, .rst, .enb(n2), .adv_hr, .military_t, .am_pm(n3), .h1, .h0);
    
    always_ff @(posedge clk) begin
        if (military_t) am_pm <= 7'b1000000;
        else if (n3) am_pm <= 7'd10;
        else am_pm <= 7'd11;
    end
    
endmodule
