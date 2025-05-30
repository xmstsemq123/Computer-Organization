module ID_EX_Stage(
    output reg [31:0] ID_EX_RsData, ID_EX_RtData, ID_EX_SignExtImm, 
    output reg [4:0] ID_EX_Rs, ID_EX_Rt, ID_EX_Rd,
    output reg [1:0] ID_EX_ALUOp,
    output reg ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_MemRead, ID_EX_ALUSrc, ID_EX_MemtoReg, ID_EX_RegDst, 
    input wire [31:0] RsData, RtData, IF_ID_Instr, 
    input wire [1:0] ALUOp,
    input wire RegWrite, MemWrite, MemRead, ALUSrc, MemtoReg, RegDst, Stall, clk
);
always @(posedge clk) begin
    // ID_EX Stage
    ID_EX_RsData <= Stall ? 0 : RsData;
    ID_EX_RtData <= Stall ? 0 : RtData;
    ID_EX_SignExtImm <= Stall ? 0 : {{16{IF_ID_Instr[15]}}, IF_ID_Instr[15:0]};
    ID_EX_Rs <= Stall ? 0 : IF_ID_Instr[25:21];
    ID_EX_Rt <= Stall ? 0 : IF_ID_Instr[20:16];
    ID_EX_Rd <= Stall ? 0 : IF_ID_Instr[15:11];
    ID_EX_RegWrite <= Stall ? 0 : RegWrite;
    ID_EX_MemWrite <= Stall ? 0 : MemWrite;
    ID_EX_MemRead <= Stall ? 0 : MemRead;
    ID_EX_ALUSrc <= Stall ? 0 : ALUSrc;
    ID_EX_MemtoReg <= Stall ? 0 : MemtoReg;
    ID_EX_RegDst <= Stall ? 0 : RegDst;
    ID_EX_ALUOp <= Stall ? 0 : ALUOp;
end
endmodule
