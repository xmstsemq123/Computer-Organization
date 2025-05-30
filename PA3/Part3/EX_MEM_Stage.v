module EX_MEM_Stage(
    output reg [31:0] EX_MEM_ALUResult, EX_MEM_RtData,
    output reg [4:0] EX_MEM_WriteReg,
    output reg EX_MEM_RegWrite, EX_MEM_MemWrite, EX_MEM_MemtoReg, EX_MEM_MemRead,
    input wire [31:0] ALUResult, RtData_Forwarded, 
    input wire [4:0] ID_EX_Rd, ID_EX_Rt,
    input wire ID_EX_RegDst, ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_MemtoReg, ID_EX_MemRead, clk
);
always @(posedge clk) begin
    // EX_MEM Stage
	EX_MEM_ALUResult <= ALUResult;
    EX_MEM_RtData <= RtData_Forwarded;
    EX_MEM_WriteReg <= ID_EX_RegDst ? ID_EX_Rd : ID_EX_Rt;
    EX_MEM_RegWrite <= ID_EX_RegWrite;
    EX_MEM_MemWrite <= ID_EX_MemWrite;
    EX_MEM_MemtoReg <= ID_EX_MemtoReg;
    EX_MEM_MemRead <= ID_EX_MemRead;
end
endmodule
