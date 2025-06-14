module ALU_decoder(
	 input funct7_5,
    input [1:0] ALUop,
    input [2:0] funct3,
	 
   
    output reg [3:0] ALU_Control 
);


always @(*) begin
	case (ALUop) 
		2'b00 : ALU_Control <= 4'b0000; //somme
		2'b01 : ALU_Control <= 4'b0001; //difference
		2'b10 : begin 
					   case (funct3)
							3'b000  : ALU_Control  <= {{3 {1'b0}}, funct7_5 };          //SOMME(0000) OU DIFFERENCE(0001)
							3'b001  : ALU_Control  <= 4'b0010; 								 //SLL
							3'b010  : ALU_Control  <= 4'b0011;							    //SLT
							3'b011  : ALU_Control  <= 4'b0101;  							 //SLTU
							3'b100  : ALU_Control  <= 4'b0100;							    //XOR
							3'b101  : ALU_Control  <= {1'b0 , {2 {1'b1}}, funct7_5};  //SRL(0110) OR SRA(0111)
							3'b110  : ALU_Control  <= 4'b1000;								 //OR
							3'b111  : ALU_Control  <= 4'b1001;								 //AND
							default : ALU_Control  <= 4'bzzzz;
						endcase
				  end
		2'b11 : begin 
					   case (funct3)
							3'b000  : ALU_Control  <= 4'b1010;								 //MPY 
							3'b001  : ALU_Control  <= 4'b1011;								 //MPYH
							3'b010  : ALU_Control  <= 4'b1100;							    //DIV
							3'b011  : ALU_Control  <= 4'b1101; 								 //MODULO
							default : ALU_Control  <= 4'bzzzz;
						endcase
				  end
		
	
	endcase

end


endmodule