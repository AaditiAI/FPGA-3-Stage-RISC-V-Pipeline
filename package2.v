/*
MODULE: package
DESCRIPTION: This is a package file, commonly used by all other design files.
*/

/***********************************
 * User-modified Processor Options *
 ***********************************/
`define DATA_WIDTH 32

// Instruction Fields
`define opcode		instruction[31:26]

`define regD_sel	instruction[20:16]
`define regB_sel	instruction[15:11]
`define regA_sel	instruction[10:6]  

