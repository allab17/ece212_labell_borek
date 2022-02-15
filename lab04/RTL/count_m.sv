`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2022 07:49:49 PM
// Design Name: 
// Module Name: count_m
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


module count_m(input logic clk, rst, enb, adv_min, 
       output logic cy,
       output logic [6:0] m1, m0
        );
    
    logic [5:0] q; //count
    logic [3:0] hundreds, tens, ones; //tens and ones digits
    logic enb_c;
        
    assign enb_c = enb | adv_min; //if the device is enabled or the user is advancing the minutes, enable the counter

    counter_rc_mod #(.MOD(60), .W(6)) COUNTER(.clk(clk), .rst(rst), .enb(enb_c), .q(q), .cy(cy)); //this binary counter assigns carry and rst after it counts the specified sequence
    dbl_dabble BINARY_TO_BCD(.b({2'd0, q}), .hundreds(hundreds), .tens(tens), .ones(ones)); //the binary number counted using counter_rc_mod is converted to BCD and output as digits h1 and h2 to denote the hours
    
    assign m1 = {3'd0, tens}; //update the minutes with the BCD value
    assign m0 = {3'b010, ones};
    
endmodule
