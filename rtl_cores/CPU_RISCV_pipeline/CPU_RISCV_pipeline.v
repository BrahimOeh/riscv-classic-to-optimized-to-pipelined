module  CPU_RISCV_pipeline (//INPUTS
							reset,clk,cycle_number,
							
							//OUTPUTS
							done,register3,pc
	
);
     input            reset , clk;
     output           done;
	  output wire   [31:0] register3,pc;
	  output  reg [8:0] cycle_number ;
    
	//wires
wire [6:0] op;
wire       funct7,jump,beq,bne,blt,bltu,bge,bgeu,Mem_Write,RegWrite,ALUSrc,Stallf,Stalld,Flushd,
        Flushe,RegWritem,RegWritew,PCSrcE,Forwardr1D, Forwardr2D;
wire [2:0] funct3,ImmSrc ,size ,ResultSrc,ResultSrcE;
wire [1:0] ForwardA,ForwardB;
wire [3:0] ALUControl;
wire [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM ,RdW;

 always @(posedge reset, posedge clk)
        begin
            if (reset) begin
                cycle_number<=9'd0;
            end
            else begin
               cycle_number= cycle_number+1;
            end
end


Control_unit_pipeline control(
    .clk(clk), .reset(reset),.funct7(funct7),.funct3(funct3),.op(op), 
    
	 .JumpD(jump),.done(done),.beqD(beq),.bneD(bne),.bltD(blt),.bgeD(bge),.bltuD(bltu),.bgeuD(bgeu),
    .Mem_WriteD(Mem_Write),.RegWriteD(RegWrite),.ALUSrcD(ALUSrc),
    .ResultSrcD(ResultSrc),
	 .ALUControlD(ALUControl) ,
    .ImmSrcD (ImmSrc), .sizeD(size)
	 
	 
);
datapath data_path(
    .OP(op),
    .funct3(funct3),
    .funct7(funct7),

    .Rs1DOut(Rs1D),
    .Rs2DOut(Rs2D),
    .Rs1EOut(Rs1E),
    .Rs2EOut(Rs2E),
    .RdEOut(RdE),
    .PCSrcEOut(PCSrcE),
    .ResultSrcEOut(ResultSrcE),
    .RdMOut(RdM),
    .RdWOut(RdW),
    .RegWriteMOut(RegWritem),
    .RegWriteWOut(RegWritew),

    .CLK(clk),
    .RESET(reset),
    .ImmSrcD(ImmSrc),
    .sizeD(size),
    .ALUSrcD(ALUSrc),
    .beqD(beq),
    .bneD(bne),
    .bltD(blt),
    .bgeD(bge),
    .bltuD(bltu),
    .bgeuD(bgeu),
    .JumpD(jump),
    .ALUControlD(ALUControl),
    .MemWriteD(Mem_Write),
    .ResultSrcD(ResultSrc),
    .RegWriteD(RegWrite),

    .StallF(Stallf),
    .StallD(Stalld),
    .FlushD(Flushd),
    .FlushE(Flushe),
    .ForwardAE(ForwardA),
    .ForwardBE(ForwardB),
	 .ForwardAD(Forwardr1D), 
	 .ForwardBD(Forwardr2D),
	 
	 
    .register3(register3),
	 .pc(pc)
);


Hazard_unit hazard_unit(//INPUTS
							.Rs1D(Rs1D),.Rs2D(Rs2D),
							.Rs1E(Rs1E),.Rs2E(Rs2E),.RdE(RdE), .PCSrcE(PCSrcE),.ResultSrcE0(ResultSrcE[0]),
							.RdM(RdM),.RegWriteM(RegWritem),
							.RdW(RdW),.RegWriteW(RegWritew),
							//OUTPUTS
							.StallF(Stallf),.StallD(Stalld),.FlushD(Flushd),.FlushE(Flushe),
							.ForwardAE(ForwardA),.ForwardBE(ForwardB),
							 .Forwardr1D(Forwardr1D), .Forwardr2D(Forwardr2D)


);


	 

	 

endmodule 