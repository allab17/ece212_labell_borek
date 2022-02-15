module dbl_dabble_ext(input logic [12:0] b,
                  output logic [3:0] thousands, hundreds, tens, ones);

logic [12:0] bs;

always_comb
    begin
        $display("dbl_dabble input: %d", b);
        bs = b;
        {thousands, hundreds, tens, ones} = 16'h0;
        for (int i=1; i<=13; i++)
            begin
                if ((i > 3) && (ones >= 4'd5)) begin
                    ones = ones + 3;
                    $display("add3o %1d %4b %4b %4b %4b %8b", i, thousands, hundreds, tens, ones, bs);
                end
                if ((i > 6) && (tens >= 4'd5)) begin
                    tens = tens + 3;
                    $display("add3o %1d %4b %4b %4b %4b %8b", i, thousands, hundreds, tens, ones, bs);
                end
                if ((i > 9) && (hundreds >= 4'd5)) begin
                    hundreds = hundreds + 3;
                    $display("add3o %1d %4b %4b %4b %4b %8b", i, thousands, hundreds, tens, ones, bs);
                end
                if ((i > 12) && (thousands >= 4'd5)) begin
                    thousands = thousands + 3;
                    $display("add3o %1d %4b %4b %4b %4b %8b", i, thousands, hundreds, tens, ones, bs);
                end
                {thousands, hundreds, tens, ones, bs} = {thousands, hundreds, tens, ones, bs} << 1;
            end
            $display("result    %d    %d   %d   %d", thousands, hundreds, tens, ones);
    end

endmodule: dbl_dabble_ext