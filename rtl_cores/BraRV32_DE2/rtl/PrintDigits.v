module PrintDigits #(parameter MAX_DIGITS = 8)(
    input      [15:0] number,
    output reg [4*MAX_DIGITS-1:0] digits_flat,  // Flattened output cause we can't declared a tabeled port in verilog
    output reg [3:0] num_digits
);

    integer i;
    reg [15:0] N;
    reg [3:0] temp_digits [MAX_DIGITS-1:0];

    always @(*) begin
        N = number;
        num_digits = 0;

        // Extract digits from LSB to MSB
        for (i = 0; i < MAX_DIGITS; i = i + 1) begin
            if (N > 0) begin
                temp_digits[i] = N % 10;
                N = N / 10;
                num_digits = num_digits + 1;
            end else begin
                temp_digits[i] = 0;
            end
        end
		
		for (i = 0; i < MAX_DIGITS; i = i + 1) begin
            digits_flat[4*i +: 4] = temp_digits[i];
		end

        // Reverse and flatten
        //digits_flat = 0;
        //for (i = 0; i < MAX_DIGITS; i = i + 1) begin
        //    digits_flat[4*(MAX_DIGITS - 1 - i) +: 4] = temp_digits[i];
        //end
    end
endmodule
