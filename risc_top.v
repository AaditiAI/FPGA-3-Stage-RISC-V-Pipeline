/*

MODULE: Top level module. This will instantiate the individual modules of RISC architecture and interconnect them together.

*/

`include "package.v"

module risc_top (
	clock, reset, stall,  // inputs
	data_in,              // inputs
	data_out
	);    // outputs

input		clock;
input		reset;
input		stall;
input	[31:0]	data_in;  // data coming in, includes opcode / source & destination register and other instruction details.

output	[31:0]	data_out; // data going out. 

wire	[31:0]	address;  // memory address for data
wire	[31:0]	address_internal;
wire		branch_taken;
wire	[`DATA_WIDTH-1:0]	pc_branch;
wire	[`DATA_WIDTH-1:0]	pc_decode;
wire	[`DATA_WIDTH-1:0]	pc_exe;

wire	[5:0]	instruction;
wire	[4:0]	regA_addr;
wire	[4:0]	regB_addr;
wire	[4:0]	regD_addr;

wire	[`DATA_WIDTH-1:0]	immediate;

wire	[1:0]	alu_inputA_sel;
wire	[1:0]	alu_inputB_sel;
wire	[1:0]	alu_inputC_sel;
wire	[3:0]	alu_fns_sel;
wire	[2:0]	comparator_fns_sel;
wire		we_alu_branch;
wire		we_load;
wire		we_store;
wire	[2:0]	regfile_input_sel;
wire	[1:0]	dmem_input_sel;
wire		delay_bit;


wire	[`DATA_WIDTH-1:0]	result;

wire	[`DATA_WIDTH-1:0]	regA;
wire	[`DATA_WIDTH-1:0]	regB;
wire	[`DATA_WIDTH-1:0]	regD;


wire		stall_exe;
wire		stall_decode;
wire		stall_fetch;
wire		instr_complete;
wire		flush;
wire		branch_instr;
wire	[1:0]	byte_sel;

wire we_memory;
//ygt reg branch_taken_fetch = 1'b0;
reg	[`DATA_WIDTH-1:0]	pc_branch_fetch = `DATA_WIDTH'h00000000;



//Instantiate various sub-blocks / pipeline stages

//FETCH
//ygt fetch	FETCH ( .stall(stall_fetch), .clock(clock), 
fetch	FETCH ( .stall(stall), .clock(clock), 
	.reset(reset), 
//ygt 	.branch_taken(branch_taken), .pc_branch(pc_branch), 
	.idata(data_in), .pc_decode(pc_decode), .instruction(instruction));


//DECODE	
//ygt decode	DECODE (.clock(clock), .stall(stall_decode), 
decode	DECODE (
	.clock(clock), .stall(stall), 
	.reset(reset), .pc_decode(pc_decode), 
	.instruction(instruction), 
	.regA_addr(regA_addr), .regB_addr(regB_addr), .regD_addr(regD_addr), 
	.pc_exe(pc_exe),	.alu_fns_sel(alu_fns_sel), 
	.idata(data_in)
	);
	
//EXECUTE
execute	EXECUTE (.clock(clock), .reset(reset), 
	.stall(stall), 
	.pc_exe(pc_exe), 
	.alu_fns_sel(alu_fns_sel), 
 	.regA(regA), .regB(regB), .regD(regD), .alu_result(result), 
//ygt 	.regA(regA_addr), .regB(regB_addr), .regD(regD_addr), .alu_result(result), 
	.address(address),
	.instr_complete(instr_complete) 
	);

//Pipeline Control
pipeline_ctrl	PIPELINE (.clock(clock), .reset(reset), .stall(stall),
	.stall_fetch(stall_fetch), 
	.stall_decode(stall_decode), .stall_exe(stall_exe));	
	
//GPR Memory
GPR_MEMORY 	MEM_REG (.reset(reset), .clock(clock), .regA_addr(regA_addr), .regB_addr(regB_addr), 
                         .regD_addr(regD_addr), .result(result), .regA(regA), .regB(regB), .regD(regD),
						 .instr_complete(instr_complete), .we_memory (we_memory), .data_out(data_out));
						
						
endmodule
