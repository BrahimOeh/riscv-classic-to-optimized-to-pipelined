module datapath (
    OP, funct3, funct7,
    Rs1DOut, Rs2DOut, Rs1EOut, Rs2EOut, RdEOut, PCSrcEOut, ResultSrcEOut, RdMOut, RdWOut, RegWriteMOut, RegWriteWOut,
    CLK, RESET,
    ImmSrcD, sizeD,ALUSrcD,beqD,bneD,bltD,bgeD,bltuD,bgeuD, JumpD, ALUControlD, MemWriteD, ResultSrcD, RegWriteD,
    StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE,
	 ForwardAD, ForwardBD,
	 //test signals
	 
	 register3,pc
);

    /* ---- OUTPUT PORTS ---- */

    // to CONTROL UNIT
    output wire   [31:0] register3,pc;
    output wire   [6:0] OP;
    output wire [14:12] funct3;
    output wire         funct7;

    // to HAZARD UNIT

    output wire [19:15] Rs1DOut, Rs1EOut;
    output wire [24:20] Rs2DOut, Rs2EOut;
    output wire  [11:7] RdEOut, RdMOut, RdWOut;
    output wire         PCSrcEOut;
    output wire   [2:0] ResultSrcEOut;
    output wire         RegWriteMOut, RegWriteWOut;

    /* ---- INPUT PORTS ---- */

    input               CLK, RESET;

    // from CONTROL UNIT

    input         [1:0] ImmSrcD;
    input               ALUSrcD,beqD,bneD,bltD,bgeD,bltuD,bgeuD,JumpD;
    input         [2:0] ALUControlD,sizeD;
    input               MemWriteD;
    input         [2:0] ResultSrcD;
    input               RegWriteD;

    // from HAZARD UNIT

    input               StallF, StallD ,ForwardAD, ForwardBD;
    input               FlushD, FlushE;
    input        [1:0] ForwardAE, ForwardBE;

    /* ---- DATA SIGNALS ---- */
    reg          [31:0] PCFPrime, PCTargetE, PCTargetM, PCTargetW;
    reg          [31:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
    reg          [31:0] PCF, PCD, PCE;
    reg          [31:0] InstrF, InstrD;
    reg          [31:0] RD1D, RD2D,RD1Dp, RD2Dp;
    reg          [31:0] RD1E, RD2E;
	 wire         [11:7] RdD,Rs1D,Rs2D;
    reg          [11:7] RdE, RdM, RdW;
    reg          [19:15] Rs1E;
    reg          [24:20] Rs2E;
    reg          [31:0] ResultW;
    reg          [31:0] ALUResultE ,sizeE,sizeM,ALUResultM, ALUResultW;
    reg          [31:0] ImmExtD, ImmExtE, ImmExtM, ImmExtW;
    reg          [31:0] SrcAE, SrcBE;
    reg          [31:0] WriteDataE, WriteDataM;
    reg          [31:0] ReadDataM, ReadDataW;
    wire						PCSrcE;
    reg                 ZeroE , OverflowE,SignE,CoutE, RegWriteE, MemWriteE, 
	                  ALUSrcE,beqE,bneE,bltE,bgeE,bltuE,bgeuE, JumpE;
    reg                 RegWriteM, MemWriteM;
    reg                 RegWriteW;
    reg          [2:0] ResultSrcE, ResultSrcM, ResultSrcW;
    reg          [2:0] ALUControlE;

    /* ---- PARAMETERS ---- */
    parameter INSTR_MEMORY_SIZE = 128;
    parameter DATA_MEMORY_SIZE  = 128;

    /* ---- MODULES ---- */

    /* ---- START FETCH STAGE ---- */

    two_to_one_mux PCFPrimeMux (.out(PCFPrime), .selectBit(PCSrcE), .in1(PCPlus4F), .in2(PCTargetE));

    d_flip_flop_with_enable PCFFlipFlop (.out(PCF), .CLK(CLK), .EN(~StallF), .in(PCFPrime));

    instruction_memory #(.MEMORY_SIZE(INSTR_MEMORY_SIZE)) instructionMemory
        (
            .ReadData(InstrF),
            .RESET(RESET),
            .CLK(CLK),
            .Address(PCF)
        );

    adder add4ToPCF (.out(PCPlus4F), .in1(PCF), .in2(32'd4));
	 assign pc =PCF;

    /* ---- END FETCH STAGE ---- */

    d_flip_flop_with_enable instrDFlipFlop   (.out(InstrD),   .CLK(CLK), .CLR(FlushD), .EN(~StallD), .in(InstrF));
    d_flip_flop_with_enable PCDFlipFlop      (.out(PCD),      .CLK(CLK), .CLR(FlushD), .EN(~StallD), .in(PCF));
    d_flip_flop_with_enable PCPlus4DFlipFlop (.out(PCPlus4D), .CLK(CLK), .CLR(FlushD), .EN(~StallD), .in(PCPlus4F));
 
 
    /* ---- START DECODE STAGE ---- */

    register_file registers (
        .ReadData1(RD1Dp),
        .ReadData2(RD2Dp),
        .RESET(RESET),
        .CLK(CLK),
        .ReadRegister1(InstrD[19:15]),
        .ReadRegister2(InstrD[24:20]),
        .WriteEnable(RegWriteW),
        .WriteRegister(RdW),
        .WriteData(ResultW),
		  .register3(register3)
    );

    immediate_extend extend (.ImmExt(ImmExtD), .Instr(InstrD[31:7]), .ImmSrc(ImmSrcD));
	 two_to_one_mux FOR1 (.out(RD1D), .selectBit(ForwardAD), .in1(RD1Dp), .in2(ResultW));
	 two_to_one_mux FOR2 (.out(RD2D), .selectBit(ForwardBD), .in1(RD2Dp), .in2(ResultW));


    /* ---- MAY GENERATE AN ERROR! ---- */
    assign RdD     = InstrD[11:7];
    assign Rs1D    = InstrD[19:15];
    assign Rs1DOut = InstrD[19:15];
    assign Rs2D    = InstrD[24:20];
    assign Rs2DOut = InstrD[24:20];

    /* ---- END DECODE STAGE ---- */

    d_flip_flop regWriteEFlipFlop   (.out(RegWriteE),   .CLK(CLK), .CLR(FlushE), .in(RegWriteD));
    d_flip_flop resultSrcEFlipFlop  (.out(ResultSrcE),  .CLK(CLK), .CLR(FlushE), .in(ResultSrcD));
    d_flip_flop memWriteEFlipFlop   (.out(MemWriteE),   .CLK(CLK), .CLR(FlushE), .in(MemWriteD));
    d_flip_flop jumpEFlipFlop       (.out(JumpE),       .CLK(CLK), .CLR(FlushE), .in(JumpD));
    d_flip_flop beqEFlipFlop     (.out(beqE),        .CLK(CLK), .CLR(FlushE), .in(beqD));
	 d_flip_flop bneEFlipFlop     (.out(bneE),        .CLK(CLK), .CLR(FlushE), .in(bneD));
	 d_flip_flop bltEFlipFlop     (.out(bltE),        .CLK(CLK), .CLR(FlushE), .in(bltD));
	 d_flip_flop bgeEFlipFlop     (.out(bgeE),        .CLK(CLK), .CLR(FlushE), .in(bgeD));
	 d_flip_flop bltuEFlipFlop     (.out(bltuE),       .CLK(CLK), .CLR(FlushE), .in(bltuD));
	 d_flip_flop bgeuranchEFlipFlop     (.out(bgeuE),       .CLK(CLK), .CLR(FlushE), .in(bgeuD));
	 d_flip_flop sizeEFlipFlop       (.out(sizeE), .CLK(CLK), .CLR(FlushE), .in(sizeD));
    d_flip_flop ALUControlEFlipFlop (.out(ALUControlE), .CLK(CLK), .CLR(FlushE), .in(ALUControlD));
    d_flip_flop ALUSrcEFlipFlop     (.out(ALUSrcE),     .CLK(CLK), .CLR(FlushE), .in(ALUSrcD));

    d_flip_flop RD1EFlipFlop     (.out(RD1E),     .CLK(CLK), .CLR(FlushE), .in(RD1D));
    d_flip_flop RD2EFlipFlop     (.out(RD2E),     .CLK(CLK), .CLR(FlushE), .in(RD2D));
    d_flip_flop PCEFlipFlop      (.out(PCE),      .CLK(CLK), .CLR(FlushE), .in(PCD));
    d_flip_flop RdEFlipFlop      (.out(RdE),      .CLK(CLK), .CLR(FlushE), .in(RdD));
    d_flip_flop Rs1EFlipFlop     (.out(Rs1E),     .CLK(CLK), .CLR(FlushE), .in(Rs1D));
    d_flip_flop Rs2EFlipFlop     (.out(Rs2E),     .CLK(CLK), .CLR(FlushE), .in(Rs2D));
    d_flip_flop ImmExtEFlipFlop  (.out(ImmExtE),  .CLK(CLK), .CLR(FlushE), .in(ImmExtD));
    d_flip_flop PCPlus4EFlipFlop (.out(PCPlus4E), .CLK(CLK), .CLR(FlushE), .in(PCPlus4D));

    /* ---- START EXECUTE STAGE ---- */
    assign PCSrcE  = JumpE | (beqE & ZeroE) | (bneE &  ~ZeroE) | (bltE & (SignE != OverflowE)) | (bgeE & (SignE == OverflowE))
						| (bltuE & ~CoutE) | (bgeuE & CoutE);
    assign bn=bneE;
    assign Rs1EOut       = Rs1E;
    assign Rs2EOut       = Rs2E;
    assign RdEOut        = RdE;
    assign PCSrcEOut     = PCSrcE;
    assign ResultSrcEOut = ResultSrcE;

    three_to_one_mux SrcAEMux (.out(SrcAE), .selectBits(ForwardAE), .in1(RD1E), .in2(ResultW), .in3(ALUResultM));

    three_to_one_mux writeDataEMux (.out(WriteDataE), .selectBits(ForwardBE), .in1(RD2E), .in2(ResultW), .in3(ALUResultM));

    two_to_one_mux SrcBEMux (.out(SrcBE), .selectBit(ALUSrcE), .in1(WriteDataE), .in2(ImmExtE));

    adder PCTargetEAdder (.out(PCTargetE), .in1(PCE), .in2(ImmExtE));

    alu ALU (.SrcA(SrcAE),  .SrcB(SrcBE),   .aluc(ALUControlE),.Alu_out(ALUResultE), .zero(ZeroE),
				  .cout(CoutE) , .overflow(OverflowE) , .sign(SignE));
	 
    /* ---- END EXECUTE STAGE ---- */

    d_flip_flop regWriteMFlipFlop  (.out(RegWriteM),  .CLK(CLK), .CLR(1'b0), .in(RegWriteE));
    d_flip_flop resultSrcMFlipFlop (.out(ResultSrcM), .CLK(CLK), .CLR(1'b0), .in(ResultSrcE));
    d_flip_flop memWriteMFlipFlop  (.out(MemWriteM),  .CLK(CLK), .CLR(1'b0), .in(MemWriteE));

	 d_flip_flop sizeMFlipFlop (.out(sizeM), .CLK(CLK), .CLR(1'b0), .in(sizeE));
    d_flip_flop ALUResultMFlipFlop (.out(ALUResultM), .CLK(CLK), .CLR(1'b0), .in(ALUResultE));
    d_flip_flop writeDataMFlipFlop (.out(WriteDataM), .CLK(CLK), .CLR(1'b0), .in(WriteDataE));
    d_flip_flop RdMFlipFlop        (.out(RdM),        .CLK(CLK), .CLR(1'b0), .in(RdE));
    d_flip_flop PCPlus4MFlipFlop   (.out(PCPlus4M),   .CLK(CLK), .CLR(1'b0), .in(PCPlus4E));
    d_flip_flop PCTargetMFlipFlop  (.out(PCTargetM),  .CLK(CLK), .CLR(1'b0), .in(PCTargetE));
    d_flip_flop ImmExtMFlipFlop    (.out(ImmExtM),    .CLK(CLK), .CLR(1'b0), .in(ImmExtE));

    /* ---- START MEMORY STAGE ---- */
    assign RdMOut       = RdM;
    assign RegWriteMOut = RegWriteM;

    data_memory #(.MEMORY_SIZE(DATA_MEMORY_SIZE)) dataMemory
        (   .size(sizeM),
            .ReadData(ReadDataM),
            .RESET(RESET),
            .CLK(CLK),
            .WriteEnable(MemWriteM),
            .Address(ALUResultM),
            .WriteData(WriteDataM)
        );

    /* ---- END MEMORY STAGE ---- */

    d_flip_flop regWriteWFlipFlop  (.out(RegWriteW),  .CLK(CLK), .CLR(1'b0), .in(RegWriteM));
    d_flip_flop resultSrcWFlipFlop (.out(ResultSrcW), .CLK(CLK), .CLR(1'b0), .in(ResultSrcM));

    d_flip_flop ALUResultWFlipFlop (.out(ALUResultW), .CLK(CLK), .CLR(1'b0), .in(ALUResultM));
    d_flip_flop readDataWFlipFlop  (.out(ReadDataW),  .CLK(CLK), .CLR(1'b0), .in(ReadDataM));
    d_flip_flop RdWFlipFlop        (.out(RdW),        .CLK(CLK), .CLR(1'b0), .in(RdM));
    d_flip_flop PCPlus4WFlipFlop   (.out(PCPlus4W),   .CLK(CLK), .CLR(1'b0), .in(PCPlus4M));
    d_flip_flop PCTargetWFlipFlop  (.out(PCTargetW),  .CLK(CLK), .CLR(1'b0), .in(PCTargetM));
    d_flip_flop ImmExtWFlipFlop    (.out(ImmExtW),    .CLK(CLK), .CLR(1'b0), .in(ImmExtM));

    /* ---- START WRITE BACK STAGE ---- */

    assign RdWOut       = RdW;
    assign RegWriteWOut = RegWriteW; 

    five_to_one_mux ResultWMux (
        .out(ResultW),
        .selectBits(ResultSrcW),
        .in1(ALUResultW),
        .in2(ReadDataW),
        .in3(PCPlus4W),
        .in4(ImmExtW),
        .in5(PCTargetW)
    );
    assign resultwt=ResultW;
    /* ---- END WRITE BACK STAGE ---- */

    /* ---- ASSIGNMENTS ---- */
    assign z=ZeroE;
    assign OP     = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[30];

endmodule // datapath
