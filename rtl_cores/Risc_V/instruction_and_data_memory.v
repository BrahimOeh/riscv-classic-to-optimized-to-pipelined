module instruction_and_data_memory
    #(parameter MEMORY_SIZE = 256)
    (
        output reg [31:0] ReadData,
        input             RESET, CLK, WriteEnable,
        input      [31:0] Address, WriteData,
        input      [2:0]  size
    );

    reg [7:0] MEMORY[MEMORY_SIZE-1:0];
    integer i;
    reg [15:0] data_temp;

    // Size encoding
    localparam BYTE        = 3'b001;
    localparam HALFWORD    = 3'b010;
    localparam WORD        = 3'b000;
    localparam BYTE_U      = 3'b011;
    localparam HALFWORD_U  = 3'b100;

    
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
		  
		  //Start code
//fibbo code
	  //Start code
    MEMORY[0]  <= 8'b00000000; // Instruction : addi x1, x0, 0
    MEMORY[1]  <= 8'b00000000; // Instruction : addi x1, x0, 0
    MEMORY[2]  <= 8'b00000000; // Instruction : addi x1, x0, 0
    MEMORY[3]  <= 8'b10010011; // Instruction : addi x1, x0, 0
	 
	 
    MEMORY[4]  <= 8'b00000000; // Instruction : addi x2, x0, 1
    MEMORY[5]  <= 8'b00010000; // Instruction : addi x2, x0, 1
    MEMORY[6]  <= 8'b00000001; // Instruction : addi x2, x0, 1
    MEMORY[7]  <= 8'b00010011; // Instruction : addi x2, x0, 1
	 
    MEMORY[8]  <= 8'b00000011; // Instruction : addi x5, x0, 55
    MEMORY[9]  <= 8'b01110000; // Instruction : addi x5, x0, 55
    MEMORY[10] <= 8'b00000010; // Instruction : addi x5, x0, 55
    MEMORY[11] <= 8'b10010011; // Instruction : addi x5, x0, 55
	 
    MEMORY[12] <= 8'b00000000; // Instruction : add x3, x1, x2
    MEMORY[13] <= 8'b00100000; // Instruction : add x3, x1, x2
    MEMORY[14] <= 8'b10000001; // Instruction : add x3, x1, x2
    MEMORY[15] <= 8'b10110011; // Instruction : add x3, x1, x2
	 
    MEMORY[16] <= 8'b00000000; // Instruction : addi x1, x2, 0
    MEMORY[17] <= 8'b00000001; // Instruction : addi x1, x2, 0
    MEMORY[18] <= 8'b00000000; // Instruction : addi x1, x2, 0
    MEMORY[19] <= 8'b10010011; // Instruction : addi x1, x2, 0
	 
    MEMORY[20] <= 8'b00000000; // Instruction : addi x2, x3, 0
    MEMORY[21] <= 8'b00000001; // Instruction : addi x2, x3, 0
    MEMORY[22] <= 8'b10000001; // Instruction : addi x2, x3, 0
    MEMORY[23] <= 8'b00010011; // Instruction : addi x2, x3, 0
	 
    MEMORY[24] <= 8'b11111110; // Instruction : bne x3, x5, loop
    MEMORY[25] <= 8'b01010001; // Instruction : bne x3, x5, loop
    MEMORY[26] <= 8'b10011010; // Instruction : bne x3, x5, loop
    MEMORY[27] <= 8'b11100011; // Instruction : bne x3, x5, loop
	 
				for (i = 28; i < MEMORY_SIZE; i = i + 1) 
							MEMORY[i] <= 8'b00000000;
				end
				
			
	//end code
        else if (WriteEnable) begin
            case (size)
                BYTE: begin
                    MEMORY[Address] <= WriteData[7:0];
                end
                HALFWORD: begin
                    MEMORY[Address]     <= WriteData[15:8];
                    MEMORY[Address + 1] <= WriteData[7:0];
                end
                WORD: begin
                    MEMORY[Address]     <= WriteData[31:24];
                    MEMORY[Address + 1] <= WriteData[23:16];
                    MEMORY[Address + 2] <= WriteData[15:8];
                    MEMORY[Address + 3] <= WriteData[7:0];
                end
            endcase
        end
    end

    // Read logic
    always @(*) begin
        case (size)
            BYTE: begin
                data_temp = MEMORY[Address];
                ReadData  = {{24{data_temp[7]}}, data_temp[7:0]}; // Sign-extend byte
            end
            HALFWORD: begin
                data_temp = {MEMORY[Address], MEMORY[Address + 1]};
                ReadData  = {{16{data_temp[15]}}, data_temp};     // Sign-extend halfword
            end
            WORD: begin
                ReadData = {MEMORY[Address], MEMORY[Address + 1],
                            MEMORY[Address + 2], MEMORY[Address + 3]};
            end
            BYTE_U: begin
                data_temp = MEMORY[Address];
                ReadData  = {24'b0, data_temp[7:0]};               // Zero-extend byte
            end
            HALFWORD_U: begin
                data_temp = {MEMORY[Address], MEMORY[Address + 1]};
                ReadData  = {16'b0, data_temp};                    // Zero-extend halfword
            end
            default: begin
                ReadData = 32'b0;
            end
        endcase
    end

endmodule
