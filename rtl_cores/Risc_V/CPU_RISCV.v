module CPU_RISCV(
	 input reset,clock,
    
    output [31:0] ALU_OUT 
);

Risc_V ENSA(
	 .reset(reset), .clock(clock),
   
    .ALU_result(ALU_OUT) 
);


endmodule