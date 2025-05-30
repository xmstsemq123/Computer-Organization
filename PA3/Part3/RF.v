`define REG_MEM_SIZE	32	// Words
module RF(
	// Outputs
	output reg [31:0] RsData,
	output reg [31:0] RtData,
	// Inputs
	input wire [4:0] RsAddr,
	input wire [4:0] RtAddr,
	input wire [4:0] RdAddr,
	input wire [31:0] RdData,
	input wire RegWrite,
	input wire clk
);
	reg [31:0]R[0:`REG_MEM_SIZE - 1];
	always@(negedge clk) begin
		if(RegWrite && RdAddr != 5'h0) begin
			R[RdAddr] <= RdData;
		end
	end
	always @(RsAddr, RtAddr, RdAddr) begin
		RsData = R[RsAddr];
		RtData = R[RtAddr];
	end
endmodule
