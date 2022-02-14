`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 01:24:57 PM
// Design Name: 
// Module Name: tconvert
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


module tconvert(input logic signed [12:0] tc,
                input logic c_f,
                output logic signed [17:0] tx10);
                
      logic [16:0] cel_wire;
      logic [17:0] fah_wire, w0;
      
      assign cel_wire = (tc << 3) + (tc << 1);  //multiply the celcius temperature by 10
     
      assign fah_wire = (tc << 4) + (tc << 1);  //multiply the fahrenheit temperature by 18 and add 320
      
      assign w0 = fah_wire + {14'd320, 4'b0000};  //convert to Fahrenheit
      assign tx10 = (c_f) ? w0 : cel_wire; //if c_f is high, output the fahrenheit conversion, else celcius
             
      
endmodule
