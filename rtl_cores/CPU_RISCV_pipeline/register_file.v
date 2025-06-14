module register_file (
    output  [31:0] ReadData1, ReadData2,
    input             RESET, CLK,
    input      [4:0]  ReadRegister1, ReadRegister2, // 5 bits pour 32 registres
    input             WriteEnable,
    input      [4:0]  WriteRegister,
    input      [31:0] WriteData,
	 output     [31:0] register3
);

    reg [31:0] REGISTERS[31:0];
    integer i;

    // Tout dans un seul bloc pour éviter les conflits
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            for (i = 0; i < 32; i = i + 1)
                REGISTERS[i] <= 32'd0;
        end else begin
            if (WriteEnable && WriteRegister != 5'd0)
                REGISTERS[WriteRegister] <= WriteData;
        end
    end

  assign      ReadData1 = REGISTERS[ReadRegister1];
  assign      ReadData2 = REGISTERS[ReadRegister2];
  assign      register3= REGISTERS[3];

endmodule

