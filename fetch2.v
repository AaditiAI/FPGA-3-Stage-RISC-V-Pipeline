/*
MODULE: fetch -- 1st stage of 3-Stage risc arch.
*/
`include "package2.v"

module fetch(
	stall, clock, reset, 				// top level
	idata,			// inputs
	instruction, pc_decode);		// outputs

// From top level -- active high signals
input		stall;
input		reset;
input		clock;

// From Instr Mem, top level
input 	[31:0]		idata;

// outputs going to DECODE stage
output	[`DATA_WIDTH-1:0]	pc_decode;
output  [5:0] instruction;

// PC = Program Counter
reg	[`DATA_WIDTH-1:0]	pc_fetch;	
reg	[`DATA_WIDTH-1:0]	pc_decode;	
reg	[5:0]		instruction;


//Generate PC and instruction opcode for 2nd (DECODE) stage
always@(posedge clock)
begin
	if (reset)
	begin
		pc_fetch 	<= 32'h00000000;
		pc_decode 	<= 32'h00000000;
		instruction <= 6'b000000;		
	end
	else if (!stall)
	begin
		pc_fetch 	<= pc_fetch + 4;	// update PC
		pc_decode 	<= pc_fetch;
 		instruction <= idata[31:26];
	end
end

endmodule
