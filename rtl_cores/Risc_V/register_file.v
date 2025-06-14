module register_file (ReadData1, ReadData2, RESET, CLK, ReadRegister1, ReadRegister2, WriteEnable, 
       WriteRegister, WriteData,register3);
    output  [31:0] ReadData1, ReadData2,register3;
    input          RESET, CLK;
    input  [4:0] ReadRegister1;
    input  [4:0] ReadRegister2;
    input          WriteEnable;
    input   [4:0] WriteRegister;
    input   [31:0] WriteData;

    // 32 registers * 32 bits each
    reg         [31:0] REGISTERS[31:0];
    integer            i;

    always @(posedge RESET, posedge CLK)
        begin
            if (RESET) begin
                for (i=0; i<=31; i=i+1) begin
                    REGISTERS[i] <= 32'd0;
                end
            end
            else begin
                if (WriteEnable)
                    REGISTERS[WriteRegister] <= WriteData;
            end
        end

    assign ReadData1 = REGISTERS[ReadRegister1];
    assign ReadData2 = REGISTERS[ReadRegister2];
	 
	 assign register3 =REGISTERS[3];
	 
	 

endmodule 
