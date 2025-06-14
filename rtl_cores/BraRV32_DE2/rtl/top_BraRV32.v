module top_BraRV32 (
   input wire clk,          // CLOCK_50  [: towards input]
   input wire reset,      // KEY[0]
   output wire [9:0]leds,   // LED[7:0]  [: towards output]
	output wire [6:0]HEX0,
	output wire [6:0]HEX1,
	output wire [6:0]HEX2,
	output wire [6:0]HEX3,
	output wire [6:0]HEX4,
	output wire [6:0]HEX5,
	output wire [6:0]HEX6,
	output wire [6:0]HEX7
);
	/*reg reset = 1 ;
    initial begin
        reset = 1;
        #100 reset = 0;
        #100 reset = 1;
    end*/
	
    wire [31:0] mem_addr, mem_wdata, mem_rdata;
    wire [3:0]  mem_wmask;
    wire        mem_rstrb, mem_rbusy;
	wire        mem_wbusy = 0 ; // in this model im always ready to write since it always happens on very specific cycles

    wire [15:0] reg10_out; // For debugging x10 numbers between [0-999] for no excessive clock cycles
	wire [31:0] digits_flat; // all digits flatout in a single register (10 HEX displays ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ 10 digits (4-bits each {0...9})ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ 40bits
	wire [3:0] num_digits; // max 8 digits
	

	
    BraRV32 cpu (
        .clk(clk),
        .reset(reset),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wmask(mem_wmask),
        .mem_rdata(mem_rdata),
        .mem_rstrb(mem_rstrb),
        .mem_rbusy(mem_rbusy),
        .mem_wbusy(mem_wbusy),
        .RF10(reg10_out)
    );

   /*ram ram_inst (
		.address ( mem_addr ),
		.clock ( clk ),
		.data ( mem_wdata ),
		.wren ( mem_wmask ),
		.q ( mem_rdata )
	);*/
	 
    MemoryRV32_synthesis mem (
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wmask(mem_wmask),
        .mem_rdata(mem_rdata),
        .mem_rstrb(mem_rstrb),
        .mem_rbusy(mem_rbusy),
        .reset(reset)
    );
	
	PrintDigits pd (
    .number(reg10_out),
    .digits_flat(digits_flat),  // Flattened output cause we can't declared a tabeled port in verilog
    .num_digits(num_digits)
	);
	
	hex_7seg_decoder digit0(                             
	  .in(digits_flat[3:0]),             
	  .o_a(HEX0[0]),                
	  .o_b(HEX0[1]),
	  .o_c(HEX0[2]),
	  .o_d(HEX0[3]),
	  .o_e(HEX0[4]),
	  .o_f(HEX0[5]),
	  .o_g(HEX0[6]) 
	);
	
	hex_7seg_decoder digit1(                             
	  .in(digits_flat[7:4]),             
	  .o_a(HEX1[0]),                
	  .o_b(HEX1[1]),
	  .o_c(HEX1[2]),
	  .o_d(HEX1[3]),
	  .o_e(HEX1[4]),
	  .o_f(HEX1[5]),
	  .o_g(HEX1[6]) 
	);
	
	hex_7seg_decoder digit2(                             
	  .in(digits_flat[11:8]),             
	  .o_a(HEX2[0]),                
	  .o_b(HEX2[1]),
	  .o_c(HEX2[2]),
	  .o_d(HEX2[3]),
	  .o_e(HEX2[4]),
	  .o_f(HEX2[5]),
	  .o_g(HEX2[6]) 
	);
	
	hex_7seg_decoder digit3(                             
	  .in(digits_flat[15:12]),             
	  .o_a(HEX3[0]),                
	  .o_b(HEX3[1]),
	  .o_c(HEX3[2]),
	  .o_d(HEX3[3]),
	  .o_e(HEX3[4]),
	  .o_f(HEX3[5]),
	  .o_g(HEX3[6]) 
	);
	
	hex_7seg_decoder digit4(                             
	  .in(digits_flat[19:16]),             
	  .o_a(HEX4[0]),                
	  .o_b(HEX4[1]),
	  .o_c(HEX4[2]),
	  .o_d(HEX4[3]),
	  .o_e(HEX4[4]),
	  .o_f(HEX4[5]),
	  .o_g(HEX4[6]) 
	);
	
	hex_7seg_decoder digit5(                             
	  .in(digits_flat[23:20]),             
	  .o_a(HEX5[0]),                
	  .o_b(HEX5[1]),
	  .o_c(HEX5[2]),
	  .o_d(HEX5[3]),
	  .o_e(HEX5[4]),
	  .o_f(HEX5[5]),
	  .o_g(HEX5[6]) 
	);
	
	hex_7seg_decoder digit6(                             
	  .in(digits_flat[27:24]),             
	  .o_a(HEX6[0]),                
	  .o_b(HEX6[1]),
	  .o_c(HEX6[2]),
	  .o_d(HEX6[3]),
	  .o_e(HEX6[4]),
	  .o_f(HEX6[5]),
	  .o_g(HEX6[6]) 
	);
	
	hex_7seg_decoder digit7(                             
	  .in(digits_flat[31:28]),             
	  .o_a(HEX7[0]),                
	  .o_b(HEX7[1]),
	  .o_c(HEX7[2]),
	  .o_d(HEX7[3]),
	  .o_e(HEX7[4]),
	  .o_f(HEX7[5]),
	  .o_g(HEX7[6]) 
	);
		

    // Debug output
    assign leds = reg10_out[15:0];

endmodule
