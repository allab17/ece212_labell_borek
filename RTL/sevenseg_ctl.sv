`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 02:45:51 PM
// Design Name: 
// Module Name: sevenseg_ctl
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


module sevenseg_ctl(
        input logic clk, rst,
        input logic [6:0] d7, d6, d5, d4, d3, d2, d1, d0,
        output logic [6:0] segs_n,
        output logic dp_n,
        output logic [7:0] an_n
    );
    
    logic enb;
    logic clear = 1'b0;
    
    logic [2:0] digit;
    logic [6:0] muxd;
    
    
    period_enb U_PEBB (.clk, .rst, .clr(clear), .enb_out(enb));
    
    counter #(.W(3)) COUNT (.clk, .rst, .enb, .q(digit));
    
    dec_3_8_n DEC (.a(digit), .y_n(an_n));
    
    mux8 #(.W(7)) MUX (.d0(d0), .d1(d1), .d2(d2), .d3(d3), .d4(d4), .d5(d5), .d6(d6), .d7(d7), .sel(digit), .y(muxd));
    
    sevenseg_ext_n SEVENSEG (.d(muxd), .segs_n(segs_n), .dp_n(dp_n));
    
    
endmodule
