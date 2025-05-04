`define DATA_MEM_SIZE	128	// Bytes
module DM(
	// Outputs
	output reg [31:0] MemReadData,
	// Inputs
	input wire [31:0] MemAddr,
	input wire [31:0] MemWriteData,
	input wire MemWrite,
	input wire MemRead,
	input wire clk
);
	reg [7:0]DataMem[0:`DATA_MEM_SIZE - 1];
	always @(negedge clk) begin
		if(MemWrite) begin
			DataMem[MemAddr] <= MemWriteData[31:24];
			DataMem[MemAddr+1] <= MemWriteData[23:16];
			DataMem[MemAddr+2] <= MemWriteData[15:8];
			DataMem[MemAddr+3] <= MemWriteData[7:0];
		end
	end
	always @(posedge clk) begin
		if(MemRead) MemReadData = {DataMem[MemAddr], DataMem[MemAddr+1], DataMem[MemAddr+2], DataMem[MemAddr+3]};
	end
endmodule
