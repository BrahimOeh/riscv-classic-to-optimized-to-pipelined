module alu (
    input   [31:0] SrcA,
    input   [31:0] SrcB,
    input   [3:0]  aluc,
    output reg [31:0] Alu_out,
    output  reg       zero,
    output reg        cout,
    output  reg      overflow,
    output reg       sign
);

    always @(*) begin
        
         Alu_out      = 32'b0;
         cout         = 1'b0;
         overflow     = 1'b0;

        case (aluc)
            4'b0000: begin // ADD
                {cout, Alu_out} = {1'b0, SrcA} + {1'b0, SrcB};
            end
            4'b0001: begin // SUB
                {cout, Alu_out} = {1'b0, SrcA} + {1'b0, ~SrcB} + 1;
            end
            4'b0010: begin // SLL
                Alu_out = SrcA << SrcB[4:0];
            end
            4'b0011: begin // SLT (signed)
                Alu_out = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
            end
            4'b0100: begin // XOR
                Alu_out = SrcA ^ SrcB;
            end
            4'b0101: begin // SLTU (unsigned)
                Alu_out = ($unsigned(SrcA) < $unsigned(SrcB)) ? 32'd1 : 32'd0;
            end
            4'b0110: begin // SRL
                Alu_out = SrcA >> SrcB[4:0];
            end
            4'b0111: begin // SRA (signed)
                Alu_out = $signed(SrcA) >>> $unsigned(SrcB[4:0]);
            end
            4'b1000: begin // OR
                Alu_out = SrcA | SrcB;
            end
            4'b1001: begin // AND
                Alu_out = SrcA & SrcB;
            end
            4'b1010: begin // MPY 
                Alu_out = SrcA * SrcB;
            end
            4'b1011: begin // MPYH 
                Alu_out = (SrcA * SrcB) >> 32;
            end
            4'b1100: begin // DIV (signed)
                Alu_out = (SrcB != 0) ? $signed(SrcA) / $signed(SrcB) : 32'd0;
            end
            4'b1101: begin // MODULO (unsigned)
                Alu_out = (SrcB != 0) ? $unsigned(SrcA) % $unsigned(SrcB) : 32'd0;
            end
            default: begin
                Alu_out = 32'd0;
            end
        endcase

        //flags
        zero     = (Alu_out == 0);
        sign     = Alu_out[31];
        overflow = (~(SrcA[31] ^ SrcB[31]) & (SrcA[31] ^ Alu_out[31]) & (aluc == 4'b0000 || aluc == 4'b0001));
    end

endmodule