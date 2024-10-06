/*

MODULE: execute

DESCRIPTION: The execute module instantiates the alu and comparator.  This module produces a status
signal, instr_complete, when the currently executing instruction is finished.

*/

`include "package.v"
module execute (
	clock, reset, stall,					// top level inputs
	pc_exe, 
	alu_fns_sel, 
	regA, 
	regB, regD, 
	// outputs
	alu_result, 
    address, instr_complete
	);
	
// From top level -- all active high unless otherwise noted
input		stall;
input		reset;
input		clock;

// From DECODE module
input	[`DATA_WIDTH-1:0]	pc_exe;			// pc for use by EXECUTE


input	[3:0]		alu_fns_sel;

// From REGFILE
input	[`DATA_WIDTH-1:0]	regA;
input	[`DATA_WIDTH-1:0]	regB;
input	[`DATA_WIDTH-1:0]	regD;


output	[`DATA_WIDTH-1:0]	alu_result;
output	[31:0]		address;
output			instr_complete;	// status of execution, active high. control whether to save to reg in GPR memory

reg	[31:0]		address;

//added 
reg	[`DATA_WIDTH-1:0]	alu_result;
reg			c_out, instr_complete;


wire			compare_out;


always@(posedge clock)
begin
//	data_out <= regD;
	address <= pc_exe;
end

always@(posedge clock)
begin
	if(~stall && ~reset)
	begin
		case(alu_fns_sel)
		`ADD:	
		// 6'b000001:
			begin
			   {c_out, alu_result} <= regA + regB + 1'b0; //c_in;
			   instr_complete <= 1'b1;
			end
		`LOGIC_OR:
			begin
				alu_result <= regA | regB; 
				c_out <= 0;
				instr_complete <= 1'b1;
			end
		`LOGIC_AND:
			begin
				alu_result <= regA & regB; 
				c_out <= 0;
				instr_complete <= 1'b1;
			end	
		`LOGIC_XOR:
			begin
				alu_result <= regA ^ regB; 
				c_out <= 0;
				instr_complete <= 1'b1;
			end	
		`MULTIPLY:		
			begin
				alu_result <= regA * regB; 
				instr_complete <= 1'b1;
			end
		endcase
    end // end if(~stall)
	else if (reset)
	begin
	  c_out <= 1'b0;
	  alu_result <= `DATA_WIDTH'h00000000;
	  instr_complete <= 1'b0;
	end
end // end always@



endmodule
