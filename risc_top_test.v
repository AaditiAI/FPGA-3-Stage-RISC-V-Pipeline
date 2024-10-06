`timescale 1ns / 1ps

module risc_top_test;

	// Inputs
	reg clock;
	reg reset;
	reg stall;
	reg [31:0] data_in;
	

	// Outputs
	wire [31:0] data_out;

	// to help generate 100MHZ clock signal
	parameter cycle = 10;

	// Instantiate the top level Design Under Test
	risc_top RISC_TOP_DUT (
		.clock(clock), 
		.reset(reset), 
		.stall(stall), 
		.data_in(data_in), 
		.data_out(data_out) 
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		stall = 0;
		data_in = 0;
		#cycle;
        
		// Apply Stimulus for design. this is a synchronous design. all inputs applied at positive edge of clock
        
		// applying reset to risc top level
		@(posedge clock) reset = 1; 
		@(posedge clock) reset = 0;	stall = 1'b1;
		
		@(posedge clock) stall = 1'b0;
		
		// applying risc instructions. supplying source operandS (2 of them) and destination register address. 
		// Please note DLX RISC is a load-store architecture operating on data within 32 GPR registers. 
		// in our case the 32 GPR registers are implemented as a single block memory (GPR MEM)
		
		
		@(posedge clock) data_in = 32'h04031040; // Logic_ADD dest=r3 source2=r2 source1=r1   
		
		@(posedge clock) data_in = 32'h0C062900; // Logic_OR dest=r6 source2=r5 source1=r4  -- 0100 OR 0101 = 0101
		
		@(posedge clock) data_in = 32'h10094380; // Logic_AND dest=r9 source2=r8 source1=r14  ->  01000 AND 01110 = 01000
		
		@(posedge clock) data_in = 32'h140C5A80; // Logic_XOR dest=r12 source2=r11 source1=r10   -> 01011 XOR 01010 = 00001
				
		@(posedge clock) data_in = 32'h00000000; // NOOP Instruction
		
		#cycle;
		
	end

	// generating 100 MHz clock signal
    always #(cycle/2) clock = ~clock;  // 0 1 0 1 0 1 0 1 0 1
	
	
endmodule
