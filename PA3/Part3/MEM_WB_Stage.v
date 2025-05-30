module MEM_WB_Stage(
    output reg [31:0] MEM_WB_MemReadData, MEM_WB_ALUResult,
    output reg [4:0] MEM_WB_WriteReg,
    output reg MEM_WB_RegWrite, MEM_WB_MemtoReg,
    input wire [31:0] MemReadData, EX_MEM_ALUResult,
    input wire [4:0] EX_MEM_WriteReg,
    input wire EX_MEM_RegWrite, EX_MEM_MemtoReg, clk
);
always @(posedge clk) begin
    // MEM_WB Stage
	MEM_WB_MemReadData <= MemReadData;
    MEM_WB_ALUResult <= EX_MEM_ALUResult;
    MEM_WB_WriteReg <= EX_MEM_WriteReg;
    MEM_WB_RegWrite <= EX_MEM_RegWrite;
    MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
end
endmodule
