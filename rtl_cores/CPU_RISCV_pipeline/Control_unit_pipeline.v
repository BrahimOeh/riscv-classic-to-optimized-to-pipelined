module Control_unit_pipeline(
    input clk, reset,funct7,
    input [2:0] funct3,
    input [6:0] op, 
    
	 output  JumpD,done,beqD,bneD,bltD,bgeD,bltuD,bgeuD,
    output  Mem_WriteD,RegWriteD,ALUSrcD,
    output  reg [2:0]  ResultSrcD,
	 output  [3:0] ALUControlD ,
    output [2:0] ImmSrcD , sizeD
	 
	 
);



reg [1:0] ALUOp ;
wire  Branch,sel_size;

//

always @(*) begin
	case (op)
		//AUIPC
		7'b0010111 : ResultSrcD <= 3'b100;
		//LUI
		7'b0110111 : ResultSrcD <= 3'b011;
		//Jalr Jall
		7'b1100111,
		7'b1101111:  ResultSrcD <= 3'b010;
		//Lw
		7'b0000011 : ResultSrcD <= 3'b001;
		//Else 
		default    : ResultSrcD <= 3'b000;
		
	endcase 
end

always @(*) begin
	case (op)
		//R and I
		7'b0110011 ,
		7'b0010011 :  ALUOp <= 3'b10;
		//CR and CI
		7'b0110001 ,
		7'b0010001 :  ALUOp <= 3'b11;
		//Branch
		7'b1100011 :  ALUOp <= 3'b01 ;
		//Else 
		default    :  ALUOp <= 3'b00;
		
	endcase 
end





assign   Mem_WriteD	= (op == 7'b0100011 )? 1:0; //sw	
assign   RegWriteD	= (~(( op == 7'b0100011 ) | (op == 7'b1100011)  )) ? 1:0; //except sw and branch
assign   sel_size    = ( ( op == 7'b0100011 ) | (op == 7'b0000011) )? 1:0; // SW AND LW
assign   ALUSrcD     = ((op == 7'b0100011) | (op == 7'b0010011) | (op == 7'b0000011) | (op == 7'b1100111) | (op == 7'b0010001))? 1:0; 
assign   Branch      = (op == 7'b1100011 )? 1:0; 


//Module du choix d'operation				  
ALU_decoder alu_dec(.funct7_5(funct7) ,.ALUop(ALUOp) , .funct3(funct3) , .ALU_Control(ALUControlD));	

//Module du choix de extend immediate
Inst_decoder Imm_choice(.op(op), .ImmSrc(ImmSrcD));	



//Branch and jump decoder

assign	beqD  = Branch & (funct3 == 3'b000); 
assign	bneD  = Branch & (funct3 == 3'b001); 
assign	bltD  = Branch & (funct3 == 3'b100); 
assign	bgeD  = Branch & (funct3 == 3'b101); 
assign	bltuD = Branch & (funct3 == 3'b110); 
assign	bgeuD = Branch & (funct3 == 3'b111);  
assign   JumpD	= (op[6] & op[2])? 1:0;		  

assign   done	= (op == 7'b0000000)? 1:0;		  
//sizeD of data (lb,sb,lh,sh,lw,sw,lbu,lhu)

Size_decoder size_data(.sel_size(sel_size) , .op(op) , .funct3(funct3) , .size(sizeD) );

				 
endmodule






