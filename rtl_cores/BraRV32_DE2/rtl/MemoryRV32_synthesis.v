module MemoryRV32_synthesis #(
    parameter MEM_WORDS = 512
)(
    input wire        clk,
    input wire [31:0] mem_addr,
    input wire [31:0] mem_wdata,
    input wire  [3:0] mem_wmask,
    output reg [31:0] mem_rdata,
    input wire        mem_rstrb,
    output wire       mem_rbusy,
    input wire        reset
);
	
    // Using memory initialization directive with an init file for FPGA synthesis (! Quartus 13.0sp1 !)
    /*(*ram_init_file = "memory_init.mif" *)*/reg [31:0] memory [0:MEM_WORDS-1];
	initial begin
        $readmemb("../rtl/full_synthesis_program.tv", memory);
    end
	// ! ../memory_init.mif paths only works with simulation functions like $readmemh !
    assign mem_rbusy = 0; // always ready
	

	/*ram ram_inst (
		.clock(clk),
		.data(mem_wdata),
		.rdaddress(mem_addr),
		.rden(mem_rstrb),
		.wraddress(mem_addr),
		.wren(wren),
		.q(mem_out)
	);*/
   always @(posedge clk) begin
	if (mem_rstrb) begin
           mem_rdata <= memory[mem_addr[31:2]];
       end
   end



    // Write on rising clock edge if write mask active
    integer i;
    always @(posedge clk) begin
        if (|mem_wmask) begin
            for (i = 0; i < 4; i = i + 1) begin
                if (mem_wmask[i]) begin
                    memory[mem_addr[31:2]][8*i +: 8] <= mem_wdata[8*i +: 8];
                end
            end
        end
    end
endmodule
