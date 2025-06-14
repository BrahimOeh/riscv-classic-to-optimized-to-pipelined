module MemoryRV32 #(
    parameter MEM_WORDS = 1024
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

    reg [31:0] memory [0:MEM_WORDS-1];

    assign mem_rbusy = 0; // always ready for read in this model
    /*check the end of this verilog file for a FSM to simulate latency and cycle-delays for reads/writes*/
	
    // Read
    always @(posedge clk) begin
        if (mem_rstrb) begin
            mem_rdata <= memory[mem_addr[31:2]];
        end
    end
    integer i;
    // Write
	/*to add write latency we keep the same logic cause the |mem_wmask is sufficient to handle the write 
	  process and add extra internal logic to detect the current state of the writing process and edge 
	  detect for when it's exactly done *peep the end of this verilog file*  */
    always @(posedge clk) begin
        if (|mem_wmask) begin
             for (i = 0; i < 4; i = i + 1)
                if (mem_wmask[i])
                    memory[mem_addr[31:2]][8*i +: 8] <= mem_wdata[8*i +: 8];
        end
    end
	
    integer fd;
    integer j; // This will hold the address (like 100, 300)
    reg [31*8:0] label; // Up to 31-char label name
	
	
	function integer strcmp;
		input [8*(32-1):0] str1; // 32-character string
		input [8*(32-1):0] str2;
		integer i;
		begin
				strcmp = 0; // assume equal
				for (i = 0; i < 32; i = i + 1) begin
					if (str1[8*i +: 8] != str2[8*i +: 8]) begin
						strcmp = 1; // not equal
					end
				end
		end
	endfunction
	
    
    
function integer strcmp_trimmed;
  input [8*32-1:0] str1;
  input [8*32-1:0] str2;
  integer i, start1, start2;
  reg [7:0] c1, c2;
  reg done; // flag to stop loops early
  begin
    strcmp_trimmed = 0;
    start1 = 0;
    start2 = 0;
    done = 0;

    // Find first non-space in str1
    for (i = 0; i < 32 && !done; i = i + 1) begin
      if (str1[8*i +: 8] != " ") begin
        start1 = i;
        done = 1; // stop loop next iteration
      end
    end

    done = 0;
    // Find first non-space in str2
    for (i = 0; i < 32 && !done; i = i + 1) begin
      if (str2[8*i +: 8] != " ") begin
        start2 = i;
        done = 1; // stop loop next iteration
      end
    end

    done = 0;
    // Compare character by character
    for (i = 0; i < 32 - ((start1 > start2) ? start1 : start2) && !done; i = i + 1) begin
      c1 = str1[8*(i + start1) +: 8];
      c2 = str2[8*(i + start2) +: 8];

      if ((c1 == 0 || c1 == " ") && (c2 == 0 || c2 == " ")) begin
        done = 1; // end comparison loop
      end
      else if (c1 != c2) begin
        strcmp_trimmed = 1; // not equal
        done = 1; // end comparison loop
      end
    end
  end
endfunction


    

    


    initial begin
      fd = $fopen("../../labels.txt", "r");
      if (fd) begin
        i = 0;
        while (!$feof(fd)) begin
          if ($fscanf(fd, "%s %d\n", label, j) == 2) begin
            $display("Line %0d: Label = %s, Address = %0d", i, label, j);
			
			if (strcmp_trimmed(label, "main") == 0) begin
				$display("ana f main");
				$readmemb("../rtl/main.tv", memory,j);
			end
			
			if (strcmp_trimmed(label, "fib") == 0) begin
				$display("ana f fib");
				$readmemb("../rtl/fib.tv", memory,j);
			end
			
            i = i + 1;
          end else begin
            $display("Format error at line %0d", i);
          end
        end
        $fclose(fd);
      end else begin
        $display("Failed to open file");
      end
    end



    // Load memory from file
    initial begin
        //$readmemb("../rtl/main.tv", memory,);
		//$readmemb("../rtl/fib.tv", memory,40);
		/*memory[0] = 32'h00000293; // li t0,0
		memory[1] = 32'h00100313; // li t1,1
		memory[2] = 32'h0062A023; // sw t1,0(t0)
		//memory[3] = 32'h0000006F; // j to self (infinite loop)
		memory[3] = 32'h000010EF; //jal rd(=r1),0x0000 0001
		memory[4] = 32'h00055380; // jal to somwhere (infinite loop) rd<-PC + 4
		// Fill unused memory with NOPs (0x00000013)
		for (i = 4; i < 1024; i = i + 1) begin
			memory[i] = 32'h00000013;
		end*/
    end
	
	
	/*
	 // Simple read FSM
    reg [1:0] rstate;
    localparam IDLE = 2'd0,
               READ = 2'd1,
               DONE = 2'd2;

    assign mem_rbusy = (rstate != IDLE);

    always @(posedge clk or negedge reset) begin
        if (reset) begin
            rstate <= IDLE;
            mem_rdata <= 32'd0;
        end else begin
            case (rstate)
                IDLE: begin
                    if (mem_rstrb) begin
                        rstate <= READ;
                    end
                end
                READ: begin
                    // 1-cycle delay, then we fetch data
                    mem_rdata <= memory[mem_addr[31:2]];
                    rstate <= DONE;
                end
                DONE: begin
                    // Done reading
                    rstate <= IDLE;
                end
            endcase
        end
    end
	*/
	
	/*
    reg wbusy, wbusy_d;
    wire write_done;						  //       ↓ : wbusy_d == 1     (old value of wbusy)
											 //        ↓    → wbusy == 0    (new value of wbusy)
    assign mem_wbusy = wbusy;			    //         ↓   ↑ 
    assign write_done = wbusy_d && ~wbusy; // wbusy : ¯¯¯↓___ goes high one cycle after wbusy=1 => write_done ←→ falling_edge

    // Track current and previous write busy state
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wbusy <= 0;
            wbusy_d <= 0;
        end else begin
            wbusy <= (|mem_wmask);      // 1 during write
            wbusy_d <= wbusy;           // non-blocking statement permits delay to detect falling edge
        end
    end
	*/
	
endmodule
