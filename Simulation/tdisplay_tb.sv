`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2022 08:21:01 PM
// Design Name: 
// Module Name: tdisplay_tb
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


module tdisplay_tb();
    
    //inputs
       logic clk, c_f;
       logic [12:0] tc;

       
       //outputs
       logic [3:0] thousands, hundreds, tens, ones;
       logic sign;
        
        
       //instantiate DUV
       tdisplay DUV (.tc, .c_f, .thousands, .hundreds, .tens, .ones, .sign);
       
       //generate clock 
       parameter CLK_PD = 10;
       
       always begin
            clk = 1'b0; #(CLK_PD/2);
            clk = 1'b1; #(CLK_PD/2);
       end
       
       //sequence the input stimulus
       //
       initial begin
            c_f = 0; @(posedge clk)#1;
         $stop;
       end
endmodule
