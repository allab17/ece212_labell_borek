`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 02:38:22 PM
// Design Name: 
// Module Name: tdisplay
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


module tdisplay(input logic signed [12:0] tc,
                input logic c_f,
                output logic [3:0] thousands, hundreds, tens, ones,
                output logic sign);
                
logic signed [17:0] tx10;                
logic [16:0] tx10_mag;
logic [12:0] tx10_mag_r;         
          

tconvert U_CONVERT (.tc, .c_f, .tx10);

conv_sgnmag U_SIGN_MAG (.tx10, .tx10_sign(sign), .tx10_mag);

round U_ROUND (.tx10_mag, .tx10_mag_r);

dbl_dabble_ext U_DABBLE (.b(tx10_mag_r), .thousands, .hundreds, .tens, .ones);

    
endmodule
