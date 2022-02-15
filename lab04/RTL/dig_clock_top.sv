`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 07:50:27 PM
// Design Name: 
// Module Name: dig_clock_top
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


module dig_clock_top(input logic clk, btn_d, btn_l, btn_r, military_t,
                     output logic [7:0] an_n, 
                     output logic [6:0] segs_n,
                     output logic dp_n
                     );
        
        //internal nodes            
        logic [6:0] n6, n5, n4, n3, n2, n1, n0;
        logic [6:0] blank;
        logic adv_h_debounced;
        logic adv_m_debounced;
        
        logic adv_h_single_pulsed;
        logic adv_m_single_pulsed;
        logic rst_single_pulsed;
        
        assign blank = 7'b1000000;
        
        debounce  DEBOUNCE1 (.clk, .pb(btn_l), .rst(btn_d), .pb_debounced(adv_h_debounced));
        debounce  DEBOUNCE2 (.clk, .pb(btn_r), .rst(btn_d), .pb_debounced(adv_m_debounced));
        
        single_pulser SINGLE_PULSE1 (.clk, .din(adv_h_debounced), .d_pulse(adv_h_single_pulsed));
        single_pulser SINGLE_PULSE2 (.clk, .din(adv_m_debounced), .d_pulse(adv_m_single_pulsed));
        single_pulser SINGLE_PULSE3 (.clk, .din(btn_d), .d_pulse(rst_single_pulsed));
        
        dig_clock DIG_CLK(.clk, .rst(rst_single_pulsed), .adv_hr(adv_h_single_pulsed), .adv_min(adv_m_single_pulsed), .military_t(military_t), .h1(n6), .h0(n5), .m1(n4), .m0(n3), .s1(n2), .s0(n1), .am_pm(n0));  
        //instantiate the sevenseg_ctl module
        sevenseg_ctl SEVENSEGCTRL (.clk, .rst(rst_single_pulsed), .d7(n6), .d6(n5), .d5(n4), .d4(n3), .d3(n2), .d2(n1), .d1(blank), .d0(n0), .segs_n(segs_n), .dp_n(dp_n), .an_n(an_n)); 
        
                    
                
                   
endmodule
