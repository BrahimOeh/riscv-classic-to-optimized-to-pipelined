module datapath (OP, funct3, funct7, Zero,cout,overflow,sign, RESET, CLK, ALUSrcA, ALUSrcB, ImmSrc, ResultSrc,
                ALUControl,AdrSrc, PCWrite, MemWrite, RegWrite, IRWrite,size,
					 
					 register3,PCout);
    /* ---- PORTS ---- */
    output    [31:0] register3 ,PCout;
	 
	
	 
    output   [6:0] OP;
    output  [14:12] funct3;
    output          funct7;
    output              Zero,cout,overflow,sign;
    input               RESET, CLK;
    input         [1:0] ALUSrcA, ALUSrcB, ImmSrc, ResultSrc;
    input         [3:0] ALUControl;
    input               AdrSrc;
    input               PCWrite, MemWrite, RegWrite, IRWrite;
	 input         [2:0] size;

    /* ---- DATA SIGNALS ---- */

    wire          [31:0] PC, OldPC;
    wire          [31:0] Address, Instr;
    wire          [31:0] SrcA, SrcB, A;
    wire          [31:0] RD1, RD2, WriteData;
    wire         [31:0] ALUResult, Result, ALUOut;
    wire          [31:0] ImmExt;
    wire         [31:0] ReadData, Data;

    /* ---- PARAMETERS ---- */

    parameter           MEMORY_SIZE = 128;

    /* ---- MODULES ---- */

    d_flip_flop_with_enable PCFlipFlop (.out(PC), .CLK(CLK), .EN(PCWrite), .in(Result),.RESET(RESET));

    two_to_one_mux addressMux (.out(Address), .selectBit(AdrSrc), .in1(PC), .in2(Result));

    instruction_and_data_memory #(.MEMORY_SIZE(MEMORY_SIZE)) memory
        (
            .ReadData(ReadData),
            .RESET(RESET),
            .CLK(CLK),
            .WriteEnable(MemWrite),
            .Address(Address),
            .WriteData(WriteData),
				.size(size)
        );

    d_flip_flop_with_enable oldPCFlipFlop (.out(OldPC), .CLK(CLK), .EN(IRWrite), .in(PC),.RESET(RESET));
    d_flip_flop_with_enable instrFlipFlop (.out(Instr), .CLK(CLK), .EN(IRWrite), .in(ReadData),.RESET(RESET));
    d_flip_flop             dataFlipFlop  (.out(Data),  .CLK(CLK),               .in(ReadData),.RESET(RESET));

    register_file registers (
        .ReadData1(RD1),
        .ReadData2(RD2),
        .RESET(RESET),
        .CLK(CLK),
        .ReadRegister1(Instr[19:15]),
        .ReadRegister2(Instr[24:20]),
        .WriteEnable(RegWrite),
        .WriteRegister(Instr[11:7]),
        .WriteData(Result),
		  .register3(register3)
    );

    d_flip_flop AFlipFlop         (.out(A),         .CLK(CLK), .in(RD1),.RESET(RESET));
    d_flip_flop writeDataFlipFlop (.out(WriteData), .CLK(CLK), .in(RD2) ,.RESET(RESET));

    immediate_extend extend (.ImmExt(ImmExt), .Instr(Instr[31:7]), .ImmSrc(ImmSrc));

    three_to_one_mux srcAMux   (.out(SrcA),   .selectBits(ALUSrcA),   .in1(PC),        .in2(OldPC),  .in3(A) ,.in4(32'dz));
    three_to_one_mux srcBMux   (.out(SrcB),   .selectBits(ALUSrcB),   .in1(WriteData), .in2(ImmExt), .in3(32'd4) ,.in4(32'dz));
    three_to_one_mux resultMux (.out(Result), .selectBits(ResultSrc), .in1(ALUOut),    .in2(Data),   .in3(ALUResult) ,.in4(ImmExt));

    alu ALU (.SrcA(SrcA), .SrcB(SrcB) , .aluc(ALUControl), .Alu_out(ALUResult), .zero(Zero), .cout(cout), 
	 .overflow(overflow), .sign(sign));
	 
	 
	 
	 
	

    d_flip_flop ALUFlipFlop (.out(ALUOut), .CLK(CLK), .in(ALUResult),.RESET(RESET));

    /* ---- ASSIGNMENTS ---- */

    assign OP     = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[30];
    assign PCout = OldPC;
endmodule // datapath