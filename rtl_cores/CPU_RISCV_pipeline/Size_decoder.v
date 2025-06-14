module Size_decoder(
	 input sel_size,
    input [6:0] op,
    input [2:0] funct3,
	 
   
    output reg [2:0] size 
);


always @(*) begin
	if (sel_size) 
			case (op) 
					 7'b0000011,
					 7'b0100011: begin 
										case (funct3) 
											3'b000  : size  <= 3'b001;  // LB SB
											3'b001  : size  <= 3'b010;  //LH SH
											3'b010  : size  <= 3'b000;  //LW SW
											3'b011  : size  <= 3'b011;  //LBU
											3'b100  : size  <= 3'b100;  //LHU
											default : size  <= 3'b000;
										endcase
									 end
					 default : size  <= 3'b000;
			endcase
			else size  <= 3'b000;
end


endmodule