module d_flip_flop_with_enable (out, CLK, EN, in,RESET);
    output reg [31:0] out;
    input             CLK, EN;
    input      [31:0] in;
	 input             RESET;

    always @(posedge CLK or posedge RESET)
        begin
		      if (RESET)out <= 32'd0;
            else if (EN)
                out <= in;
        end

endmodule // d_flip_flop_with_enable
