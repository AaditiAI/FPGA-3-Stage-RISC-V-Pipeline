/*

MODULE: risc_decode

DESCRIPTION: The decode module receives the instruction from the fetch module
and produces all control signals needed by the execute stage and the register
file.

*/
`include "package.v"

module decode(
	// top level inputs
	clock, stall, reset,				
	pc_decode, instruction,	
	regA_addr, regB_addr, regD_addr, 
	// outputs
	alu_fns_sel, 
	pc_exe, idata);

// From top level -- all active high unless otherwise noted
input		stall;
input		reset;
input		clock;

// From FETCH module
input	[`DATA_WIDTH-1:0]	pc_decode;
input	[5:0]		instruction;


// From Instr Mem, from top level
input 	[31:0]		idata;

// to GPR MEM
output	[4:0]		regA_addr;
output	[4:0]		regB_addr;
output	[4:0]		regD_addr;

// To Execute stage
output	[3:0]		alu_fns_sel;
output	[`DATA_WIDTH-1:0]	pc_exe;		// pc for use by EXECUTE



// Register All Outputs
reg	[`DATA_WIDTH-1:0]	pc_exe;			// Prog Counter of instr being executed

reg	[3:0]		alu_fns_sel;		// selects ALU function


reg	[4:0]		regA_addr;		// 5-bit addresses into Reg File
reg	[4:0]		regB_addr;
reg	[4:0]		regD_addr;

// Internal registers

reg  [31:0] instruction_name;


//always@(posedge clock,instruction,reset,idata)
always@(posedge clock)
begin
//ygt 	if (reset | (flush & !stall))
	if (reset)
	begin
		pc_exe <= 0;
		instruction_name <= 39'H0000000000;
		
		regA_addr 		<= 5'b00000;
		regB_addr 		<= 5'b00000;
		regD_addr 		<= 5'b00000;

		alu_fns_sel 		<= 4'b0000;
	end
	else if (!stall)
	begin
		
		// reg type instructions, define rs1 rs2 and rd.
 		regA_addr		<= idata[10:6];
		regB_addr		<= idata[15:11];
		regD_addr		<= idata[20:16];
         
		
		// BIG Case statement here
		// see package.v for definitions
		case (instruction)
			`NOOP: 
				begin       
				instruction_name <= "NOOP";
				end
			`ADD:
				begin
				 alu_fns_sel	<= 4'b0001;
				 instruction_name <= " ADD";
				end
			`LOGIC_OR:
				begin
				alu_fns_sel	<= 4'b0011;
				instruction_name <= "  OR";
				end
			`LOGIC_AND:
				begin
				 alu_fns_sel	<= 4'b0100;
				 instruction_name <= " AND";
				end
			`LOGIC_XOR:	
				begin
				alu_fns_sel	<= 4'b0101;
				instruction_name <= " XOR";
				end
			`MULTIPLY:  
				begin
				alu_fns_sel <= 4'b0110;
				instruction_name <= "MULT";
				end

		endcase
		
 	    pc_exe	<= pc_decode;
		
	end  // else if (!stall)

end // end of always@
	
endmodule 