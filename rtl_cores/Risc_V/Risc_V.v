module Risc_V(
	 input reset,clock,run,
	 output  done,
	 output  [3:0] state ,
	 output  reg [8:0] cycle_number ,
    output  [31:0] register3 ,PC
);

	 wire   [6:0] op;
    wire   [2:0] funct3;
    wire         zero,cout,overflow,sign;
	 
    wire         [1:0] ALUSrcA, ALUSrcB, ImmSrc, ResultSrc;
    wire         [3:0] ALUControl;
	 wire         [2:0] size;
    wire               AdrSrc;
    wire               PCWrite, MemWrite, RegWrite, IRWrite,funct7;
 

 // calcul du nombre de cycles
  always @(posedge reset, posedge clock)
        begin
            if (reset) begin
                cycle_number<=9'd0;
            end
            else begin
               cycle_number= cycle_number+1;
            end
end
 
Control_unit  ctrl(
    .clk(clock), .reset(reset), .run(run),.done(done),
	
	 .zero(zero), .overflow(overflow), .sign(sign), .cout(cout),
    .funct3(funct3),
    .op(op), .funct7(funct7),
    
	 .PCWrite(PCWrite), .Mem_Write(MemWrite), .IRWrite(IRWrite), .RegWrite(RegWrite), .AdrSrc(AdrSrc),
    .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),. ResultSrc(ResultSrc), .ALUControl(ALUControl),
	 .state(state), .ImmSrc(ImmSrc),
	   .size (size)
);

datapath data_path( .OP(op), .funct3(funct3), .funct7(funct7), .Zero(zero), .cout(cout), .overflow(overflow), .sign(sign),
                     .RESET(reset), .CLK(clock), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ImmSrc(ImmSrc), 
							.ResultSrc(ResultSrc), .ALUControl(ALUControl), .AdrSrc(AdrSrc), .PCWrite(PCWrite), 
							.MemWrite(MemWrite), .RegWrite(RegWrite), .IRWrite(IRWrite),
							.size(size),.register3(register3),.PCout(PC) 
);
 


endmodule