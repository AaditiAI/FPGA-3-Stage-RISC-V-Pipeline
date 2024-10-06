/*

MODULE: GPR Memory Module

DESCRIPTION: This module implements the 32 GPRs (General purpose registers).

*/
`include "package.v"

module GPR_MEMORY (
	// top level inputs
	reset, clock,							
	regA_addr, regB_addr, regD_addr, 
	result, we_memory, instr_complete,  
	// outputs
	regA, regB, regD, data_out);					

// From top level
input 		reset;
input 		clock;

// From DECODE
input	[4:0]	regA_addr;
input	[4:0]	regB_addr;
input	[4:0]	regD_addr;
input  we_memory; // control writing to memory

// From EXECUTE
input	[`DATA_WIDTH-1:0]	result;  

// from Execute / ALU
input			instr_complete;	// status of execution, active high

//Outputs
output	[`DATA_WIDTH-1:0]	regA;
output	[`DATA_WIDTH-1:0]	regB;
output	[`DATA_WIDTH-1:0]	regD;
output	reg [31:0]		data_out;


// local signals

reg [`DATA_WIDTH-1:0]	regA;
reg [`DATA_WIDTH-1:0]	regB;
reg [`DATA_WIDTH-1:0]	regD;
parameter	GPR_count = 32;	// 32 registers
reg	[`DATA_WIDTH-1:0]		GPR_MEM [0:GPR_count - 1];  // declaring a memory to implement GPR0-31
integer i;

reg [`DATA_WIDTH-1:0]	last_result;  
reg [4:0]	last_regD_addr, last_regD_addr2, last_regD_addr3 = 5'b00000;

initial  // initialize GPR memory
begin		
		for(i=0; i < GPR_count; i=i+1)
                GPR_MEM[i] <= i; //`DATA_WIDTH'hFFFFFFFF;
end

// read from and write to the General purpose register memory
always@(posedge clock)
begin
	if (reset)  // reset all register values
	begin
	  regA <= `DATA_WIDTH'h00000000;
	  regB <= `DATA_WIDTH'h00000000;
	  regD <= `DATA_WIDTH'h00000000;
	  last_result <= `DATA_WIDTH'h00000000;
	  last_regD_addr  <= 5'b00000;
	  last_regD_addr2 <= 5'b00000;
	  last_regD_addr3 <= 5'b00000;
	  
	  data_out <= `DATA_WIDTH'h00000000;
	end
	else
	begin
	// writing to GPR memory, if instruction execution is complete. this signal comes from execution stage.
		if (instr_complete)
		begin
		  data_out <= result;
		  GPR_MEM[last_regD_addr3] <= last_result;
		end	
		else
		begin
		end   

	last_result <= result;
	last_regD_addr <= regD_addr;
	last_regD_addr2 <= last_regD_addr;
	last_regD_addr3 <= last_regD_addr2;

	
	// reading from GPR memory, based on instruction specified.
	regA <= GPR_MEM[regA_addr];
	regB <= GPR_MEM[regB_addr];
	regD <= GPR_MEM[regD_addr];
	end
end
	
endmodule
