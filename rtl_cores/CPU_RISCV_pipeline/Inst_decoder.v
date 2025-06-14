module Inst_decoder(
	 input [6:0] op,
	 
   
    output reg [2:0] ImmSrc 
);

always @(*) begin
	case (op)
		//type I
		7'b0000011,
		7'b0010011,
		7'b0010001,
		7'b0110011,
		7'b1100111 : ImmSrc <= 3'b000;
		//type S
		7'b0100011 : ImmSrc <= 3'b001;
		//type B
		7'b1100011 : ImmSrc <= 3'b010;
		//type J
		7'b1101111 : ImmSrc <= 3'b011;
		//type U
		7'b0010111,
		7'b0110111 : ImmSrc <= 3'b100;
		default    : ImmSrc <= 3'bzzz;
		
	endcase 
end
endmodule
