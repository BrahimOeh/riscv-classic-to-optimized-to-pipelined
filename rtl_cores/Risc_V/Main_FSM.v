// FSM

module Main_FSM(
    input clk, reset,run,
    input [6:0] op,
    
    output reg PCUpdate,Branch, Mem_Write, IRWrite, RegWrite, AdrSrc,sel_size,done,
    output reg  [1:0] ALUSrcA, ALUSrcB, ResultSrc,
	 output  reg [3:0] st,
    output  reg [1:0] ALUOp
	 
	 
);


// FSM States
parameter     
    Fetch     = 4'b0000,
    Decode    = 4'b0001,
    MemAdr    = 4'b0010,
    MemRead   = 4'b0011,
    MemWB     = 4'b0100,
    MemWrite  = 4'b0101,
    ExecuteR  = 4'b0110,
    ALUWB_s   = 4'b0111,
    BEQ_s     = 4'b1000,
    JAL_s     = 4'b1001,
    ExecuteI  = 4'b1010,
	 LUI_s     = 4'b1011,
	 Auipc     = 4'b1100,
	 ExecuteRC = 4'b1101,
	 idle      = 4'b1111,
	 ExecuteIC = 4'b1110;

reg [3:0] state;



always @(posedge clk or posedge reset) begin
    if (reset)
        state <= idle ; 
    else begin
        case (state)
		      idle : if (run) state <= Fetch;
            Fetch: state <= Decode;

            Decode:
                if (op == 7'b0110011)
                    state <= ExecuteR;
                else if (op == 7'b0010011)
                    state <= ExecuteI;
                else if (op == 7'b0000011 || op == 7'b0100011 || op == 7'b1100111)
                    state <= MemAdr;
                else if (op == 7'b1101111)
                    state <= JAL_s;
					 else if (op == 7'b0110111)
                    state <= LUI_s;
					 else if (op == 7'b0010111)
                    state <= Auipc;
					 else if (op == 7'b0110001)
                    state <= ExecuteRC;
					 else if (op == 7'b0010001)
                    state <= ExecuteIC;
					 else if (op == 7'b1100011)
                    state <= BEQ_s;
                else
                    state <= idle;

            ExecuteR,
				Auipc,
            ExecuteI,
            JAL_s: state <= ALUWB_s;

            MemAdr:
                if      (op == 7'b0000011)
                    state <= MemRead;
                else if (op == 7'b0100011)
                    state <= MemWrite;
					 else if (op == 7'b1100111)
                    state <= JAL_s;

            MemRead: state <= MemWB;

            ALUWB_s,
				LUI_s,
            MemWB,
            MemWrite: state <= Fetch;

            default: state <= Fetch;
        endcase
    end
	 st <= state;
end

// Control signal generation
always @(state) begin
    // Par défaut, tout à 0
	 
    PCUpdate     <= 1'b0;
	 Branch       <= 1'b0;
    Mem_Write    <= 1'b0;
    IRWrite      <= 1'b0;
    RegWrite     <= 1'b0;
    AdrSrc       <= 1'b0;
	 sel_size	  <= 1'b0;
    ALUSrcA      <= 2'b00;
    ALUSrcB      <= 2'b00;
    ResultSrc    <= 2'b00;
    ALUOp        <= 2'b00;
	 done		     <= 1'b0;	

    case (state)
	     idle		: 
								done       <= 1'b1; 
						
        Fetch		: begin
								sel_size	  <= 1'b1;
								IRWrite    <= 1'b1;
								ALUSrcB    <= 2'b10;
								ResultSrc  <= 2'b10;
								PCUpdate   <= 1'b1;
							end

        Decode		: begin
								ALUSrcA    <= 2'b01;
								ALUSrcB    <= 2'b01;
						  end
		  
		  ExecuteR	: begin
								ALUSrcA    <= 2'b10;
								ALUOp      <= 2'b10; 
						  end
		  
		  ExecuteI	: begin
								ALUSrcA    <= 2'b10;
								ALUSrcB    <= 2'b01;
								ALUOp      <= 2'b10; 
						  end
		  
		  ALUWB_s	: begin
								RegWrite     <= 1'b1; 
						  end
		  
		  MemAdr		: begin
								ALUSrcA    <= 2'b10;
								ALUSrcB    <= 2'b01;
						  end
						  
		  MemRead	: begin
								AdrSrc       <= 1'b1; 
						      sel_size	    <= 1'b1;		
						  end
						  
		  MemWB   	: begin
								ResultSrc    <= 2'b01;
								RegWrite     <= 1'b1;   
						  end
						  
		  MemWrite 	: begin
								AdrSrc       <= 1'b1;
								sel_size	    <= 1'b1;
								Mem_Write    <= 1'b1;   
						  end

		  JAL_s   	: begin
								ALUSrcA      <= 2'b01;
								ALUSrcB      <= 2'b10;
								PCUpdate     <= 1'b1;
						  end
		  
		  BEQ_s   	: begin
								ALUSrcA      <= 2'b10;
								ALUOp        <= 2'b01;
								Branch       <= 1'b1;
						  end
						  
		  LUI_s   	: begin
							   ResultSrc    <= 2'b11;
								RegWrite     <= 1'b1;
						  end
		  Auipc   	: begin
							   ALUSrcA      <= 2'b01;
								ALUSrcB      <= 2'b01;
						  end
						  
        ExecuteRC	: begin
								ALUSrcA    <= 2'b10;
								ALUOp      <= 2'b11; 
						  end
		  ExecuteIC	: begin
								ALUSrcA    <= 2'b10;
								ALUSrcB    <= 2'b01;
								ALUOp      <= 2'b11; 
						  end
			

    endcase
end


endmodule