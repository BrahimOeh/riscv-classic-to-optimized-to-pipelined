module d_flip_flop (out, CLK, in,RESET);
    output reg [31:0] out;
    input             CLK;
    input      [31:0] in;
	 input             RESET;

    always @(posedge CLK or posedge RESET)
        begin
		  if (RESET)out=32'd0;
		  else
            out <= in;
        end

endmodule // d_flip_flop
