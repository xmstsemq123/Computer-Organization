module RF(
	//Inputs
	input [4:0] Rs_addr,
	input [4:0] Rt_addr,
	//Outputs
	output [31:0] Src_1,
	output [31:0] Src_2

);
	reg [31:0]R[0:31];
	assign Src_1 = R[Rs_addr];
	assign Src_2 = R[Rt_addr];
endmodule
