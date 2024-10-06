/*

MODULE: pipeline_ctrl

DESCRIPTION: Pipeline controller to stall various modules. 

*/

module pipeline_ctrl(
	// top level inputs
	clock, reset, stall,			
	// outputs
	stall_fetch, stall_decode, stall_exe);	

// From top level	
input		clock;
input		stall;
input		reset;


output		stall_fetch;
output		stall_decode;
output		stall_exe;

reg stall_fetch, stall_decode, stall_exe; 

// Generate Stall to control various stages of the pipeline.
always @(posedge clock)
begin
   if (reset)
   begin
	   stall_fetch <= 1'b0;
	   stall_decode <= 1'b0;
	   stall_exe <= 1'b0;
   end
   else
   begin
	   stall_fetch <= stall;
	   stall_decode <= stall;
	   stall_exe <= stall;
   end
end

endmodule

