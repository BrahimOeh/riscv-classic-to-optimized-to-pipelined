module instruction_memory
    #(parameter MEMORY_SIZE = 128)
    (
        output reg [31:0] ReadData,
        input             RESET, CLK,
        input      [31:0] Address
    );

    reg [7:0] MEMORY[MEMORY_SIZE-1:0];
    integer i;

    // Initialisation lors du RESET
    always @(posedge RESET) begin
        if (RESET) begin
            // Programme : même que celui du deuxième module
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
    end

    // Lecture combinatoire (lecture 32 bits alignée)
    always @(*) begin
        ReadData = {
            MEMORY[Address],
            MEMORY[Address + 1],
            MEMORY[Address + 2],
            MEMORY[Address + 3]
        };
    end

endmodule

