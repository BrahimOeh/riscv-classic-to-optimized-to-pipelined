module Top;

    reg [31:0] N = 610;
    wire [39:0] digits;
    wire [3:0] num_digits;
    integer i;
    PrintDigits pd (
        .number(N),
        .digits_flat(digits),
        .num_digits(num_digits)
    );

    initial begin
        #10;
        $display("Number = %d", N);
        //$display("Digits:");
        $display("Digits (each 4-bit chunk):");
		for (i = 9; i >= 0; i = i - 1) begin
			$display("Digit[%0d] = %0d", i, digits[i*4 +: 4]);
		end
        $display("");
    end
endmodule
