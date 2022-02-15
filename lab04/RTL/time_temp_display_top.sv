`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 01:53:10 PM
// Design Name: 
// Module Name: time_temp_display_top
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


module time_temp_display_top(input logic clk, rst, btn_l, btn_r, tc_enb, c_f, sw15, sw14,
                     output logic [7:0] an_n, 
                     output logic [6:0] segs_n,
                     output logic dp_n,
                     inout TMP_SCL, // use inout only - no logic
                     inout TMP_SDA // use inout only - no logic
                     );
                     
logic [7:0] an_n_tmp, an_n_clk;
logic [6:0] segs_n_tmp, segs_n_clk;
logic       dp_n_tmp, dp_n_clk, enb, cy_2, cy_4, out_timing;
logic [2:0] q_2, q_4;   
logic [15:0] tmp_cmb, clk_cmb, out_cmb_static, out_cmb_timing, out_cmb_final;           
                     
dig_clock_top U_CLOCK_TOP (.clk, .btn_d(rst), .btn_l, .btn_r, .an_n(an_n_clk), .segs_n(segs_n_clk), .dp_n(dp_n_clk));

tdisplay_top U_TEMP_TOP (.clk, .rst, .c_f, .an_n(an_n_tmp), .segs_n(segs_n_tmp), .dp_n(dp_n_tmp), .TMP_SCL, .TMP_SDA);                     




period_enb  #(.PERIOD_MS(1000)) U_PENB_TOP (.clk, .rst, .clr(1'b0), .enb_out(enb));
counter_rc_mod  #(.MOD(4), .W(3)) U_TOP_COUNT_2 (.clk, .rst, .enb, .q(q_2), .cy(cy_2));
counter_rc_mod  #(.MOD(9), .W(3)) U_TOP_COUNT_4 (.clk, .rst, .enb, .q(q_4), .cy(cy_4));

assign clk_cmb = {an_n_clk, segs_n_clk, dp_n_clk};
assign tmp_cmb = {an_n_tmp, segs_n_tmp, dp_n_tmp};

assign out_timing = (sw14) ? q_4[2] : q_2[1];

assign out_cmb_static = (sw14) ? tmp_cmb : clk_cmb;

assign out_cmb_timing = (out_timing) ? tmp_cmb : clk_cmb;

assign out_cmb_final = (sw15) ? out_cmb_timing : out_cmb_static;

assign an_n = out_cmb_final[15:8];
assign segs_n = out_cmb_final[7:1];
assign dp_n = out_cmb_final[0];
 
 
   
endmodule
