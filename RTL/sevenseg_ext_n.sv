`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 01:16:00 PM
// Design Name: 
// Module Name: sevenseg_ext_n
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


module sevenseg_ext_n(
            input logic [6:0] d,
            output logic [6:0] segs_n,
            output logic dp_n
    );
    
    logic [6:0] segs;
    logic dp;
    
    always_comb
    begin
        if (d[5] && !d[6]) dp = 1'b1;
        else dp = 1'b0;
        if (d[6]) begin
          segs = 7'd0; //assert segs low if blank is asserted
        end
        else if (d[4]) begin //if dash is asserted and blank is not asserted, dash is displayed
            segs = 7'b1000000;
        end
        else
        begin
            case (d[3:0])
                4'd0: segs = 7'b0111111;
                4'd1: segs = 7'b0000110;
                4'd2: segs = 7'b1011011;
                4'd3: segs = 7'b1001111; 
                4'd4: segs = 7'b1100110;  
                4'd5: segs = 7'b1101101; 
                4'd6: segs = 7'b1111101; 
                4'd7: segs = 7'b0000111; 
                4'd8: segs = 7'b1111111;
                4'd9: segs = 7'b1100111; 
                4'd10: segs = 7'b0111001;  //letter C
                4'd11: segs = 7'b1110001; //letter F
                4'd12: segs = 7'b0111001; 
                default: segs = 7'b0000000;                   
            endcase 
        end
        segs_n = ~segs;
        dp_n = ~dp;
    end
endmodule
