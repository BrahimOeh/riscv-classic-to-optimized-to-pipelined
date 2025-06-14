module Control_unit(
    input clk, reset,run,zero,overflow,sign,cout,funct7,
    input [2:0] funct3,
    input [6:0] op, 
    
	 output  PCWrite,done,
    output  Mem_Write, IRWrite, RegWrite, AdrSrc,
    output  [1:0] ALUSrcA, ALUSrcB,  ResultSrc,
	 output  [3:0] ALUControl ,
	 output  [3:0] state ,
    output [2:0] ImmSrc , size
	 
	 
);



wire    [1:0] ALUOp ;
wire  PCUpdate,Branch,sel_size;

//Module de la FSM
Main_FSM Fsm (.done(done) ,.run(run) ,.clk(clk) , .reset(reset), .op(op) , .PCUpdate(PCUpdate) , .Branch(Branch) , .Mem_Write(Mem_Write) , .IRWrite(IRWrite) ,
              .RegWrite(RegWrite) , .AdrSrc(AdrSrc) , .sel_size(sel_size) ,.ALUSrcA(ALUSrcA) , .ALUSrcB(ALUSrcB) , .ResultSrc(ResultSrc) ,
				    .st(state), .ALUOp(ALUOp)) ;

//Module du choix d'operation				  
ALU_decoder alu_dec(.funct7_5(funct7) ,.ALUop(ALUOp) , .funct3(funct3) , .ALU_Control(ALUControl));	

//Module du choix de extend immediate
Inst_decoder Imm_choice(.op(op), .ImmSrc(ImmSrc));	



//Branch decoder
wire beq,bne,blt,bge,bltu,bgeu;

assign	beq  = Branch & (funct3 == 3'b000); 
assign	bne  = Branch & (funct3 == 3'b001); 
assign	blt  = Branch & (funct3 == 3'b100); 
assign	bge  = Branch & (funct3 == 3'b101); 
assign	bltu = Branch & (funct3 == 3'b110); 
assign	bgeu = Branch & (funct3 == 3'b111);  
			  
assign PCWrite = PCUpdate | (beq & zero) | (bne & ~zero) | (blt & (sign != overflow)) | (bge & (sign == overflow))
						| (bltu & ~cout) | (bgeu & cout);
		  
//Size of data (lb,sb,lh,sh,lw,sw,lbu,lhu)

Size_decoder size_data(.sel_size(sel_size) , .op(op) , .funct3(funct3) , .size(size) );

				 
endmodule






