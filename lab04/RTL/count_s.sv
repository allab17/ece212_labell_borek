`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2022 07:50:09 PM
// Design Name: 
// Module Name: count_s
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


module count_s(
       input logic clk, rst, enb,
       output logic cy,
       output logic [6:0] s1, s0
        );

    
    logic [5:0] q; //count
    logic [3:0] hundreds, tens, ones; //tens and ones digits

    counter_rc_mod #(.MOD(60), .W(6)) COUNTER(.clk(clk), .rst(rst), .enb(enb), .q(q), .cy(cy)); //this binary counter assigns carry and rst after it counts the specified sequence
    dbl_dabble BINARY_TO_BCD(.b({2'd0, q}), .hundreds(hundreds), .tens(tens), .ones(ones)); //the binary number counted using counter_rc_mod is converted to BCD and output as digits h1 and h2 to denote the hours
   
    assign s1 = {3'd0, tens};
    assign s0 = {3'd0, ones};
    
endmodule
