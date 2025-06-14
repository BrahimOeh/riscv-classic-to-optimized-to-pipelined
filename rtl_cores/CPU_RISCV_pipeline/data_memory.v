module data_memory
    #(parameter MEMORY_SIZE = 64)
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
		  
for (i = 0; i < MEMORY_SIZE; i = i + 1)
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
