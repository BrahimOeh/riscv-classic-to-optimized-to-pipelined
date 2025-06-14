module d_flip_flop (out, CLK, CLR, in);
    output reg [31:0] out;
    input             CLK, CLR;
    input      [31:0] in;

    always @(posedge CLK)
        begin
            if (CLR)
                out <= 32'b00;
            else
                out <= in;
        end

endmodule // d_flip_flop
