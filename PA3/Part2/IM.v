`define INSTR_MEM_SIZE	128	// Bytes
module IM(
	// Outputs
	output reg [31:0] Instr,
	// Inputs
	input wire [31:0] InstrAddr
);
	reg [7:0]InstrMem[0:`INSTR_MEM_SIZE - 1];
	always @(*) begin
		Instr = {
			InstrMem[InstrAddr],
			InstrMem[InstrAddr+1],
			InstrMem[InstrAddr+2],
			InstrMem[InstrAddr+3]
		};
	end
endmodule