module I_PipelineCPU(
    output reg [31:0] Output_Addr,
    input wire [31:0] Input_Addr,
    input wire clk
);

//==== IF/ID Stage ====
wire RegWrite, MemWrite, ALUSrc, MemtoReg, RegDst;
wire [31:0] Instr;
reg [31:0] IF_ID_Instr;
wire [31:0] RsData, RtData;
wire [1:0] ALUOp;
//==== ID/EX Stage ====
reg [31:0] ID_EX_RsData, ID_EX_RtData, ID_EX_SignExtImm;
reg [4:0] ID_EX_Rt, ID_EX_Rd;
reg ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_MemtoReg, ID_EX_RegDst;
reg [1:0] ID_EX_ALUOp;
wire [5:0] Funct;
wire [31:0] ALUin2 = (ID_EX_ALUSrc) ? ID_EX_SignExtImm : ID_EX_RtData;
wire [31:0] ALUResult;
//==== EX/MEM Stage ====
reg [31:0] EX_MEM_ALUResult, EX_MEM_RtData;
reg [4:0] EX_MEM_WriteReg;
reg EX_MEM_RegWrite, EX_MEM_MemWrite, EX_MEM_MemtoReg;
wire [31:0] MemReadData;
//==== MEM/WB Stage ====
reg [4:0] MEM_WB_WriteReg;
reg MEM_WB_RegWrite;
reg [31:0] MEM_WB_MemReadData, MEM_WB_ALUResult;
reg MEM_WB_MemtoReg;
wire [31:0] WB_Data = (MEM_WB_MemtoReg) ? MEM_WB_MemReadData : MEM_WB_ALUResult;

//==== Instruction Memory ====
IM Instr_Memory(
    .Instr(Instr),
    .InstrAddr(Input_Addr)
);

//==== Control Unit ====
Control control(
    .OpCode(IF_ID_Instr[31:26]),
    .Reg_w(RegWrite),
    .Mem_w(MemWrite),
    .ALU_op(ALUOp),
    .ALU_src(ALUSrc),
    .Mem_to_reg(MemtoReg),
    .Reg_dst(RegDst)
);

//==== Register File ====
RF Register_File(
    .RsData(RsData),
    .RtData(RtData),
    .RsAddr(IF_ID_Instr[25:21]),
    .RtAddr(IF_ID_Instr[20:16]),
    .RdAddr(MEM_WB_WriteReg),
    .RdData(WB_Data),
    .RegWrite(MEM_WB_RegWrite),
    .clk(clk)
);

//==== ALU Control ====
ALU_Control alu_control(
    .ALU_op(ID_EX_ALUOp),
    .Funct(Funct),
    .Funct_ctrl(ID_EX_SignExtImm[5:0])
);

//==== ALU ====
ALU alu(
    .in1(ID_EX_RsData),
    .in2(ALUin2),
    .Funct(Funct),
	.Shamt(ID_EX_SignExtImm[10:6]),
    .ALU_result(ALUResult)
);

//==== Data Memory ====
DM Data_Memory(
    .MemReadData(MemReadData),
    .MemAddr(EX_MEM_ALUResult),
    .MemWriteData(EX_MEM_RtData),
    .MemWrite(EX_MEM_MemWrite),
    .clk(clk)
);

always @(posedge clk) begin
	//==== IF/ID Pipeline Register ====
	IF_ID_Instr <= Instr;
	//==== ID/EX Pipeline Register ====
    ID_EX_RsData <= RsData;
    ID_EX_RtData <= RtData;
    ID_EX_SignExtImm <= {{16{IF_ID_Instr[15]}}, IF_ID_Instr[15:0]};
    ID_EX_Rt <= IF_ID_Instr[20:16];
    ID_EX_Rd <= IF_ID_Instr[15:11];
    ID_EX_RegWrite <= RegWrite;
    ID_EX_MemWrite <= MemWrite;
    ID_EX_ALUSrc <= ALUSrc;
    ID_EX_MemtoReg <= MemtoReg;
    ID_EX_RegDst <= RegDst;
    ID_EX_ALUOp <= ALUOp;
	//==== EX/MEM Pipeline Register ====
	EX_MEM_ALUResult <= ALUResult;
    EX_MEM_RtData <= ID_EX_RtData;
    EX_MEM_WriteReg <= (ID_EX_RegDst) ? ID_EX_Rd : ID_EX_Rt;
    EX_MEM_RegWrite <= ID_EX_RegWrite;
    EX_MEM_MemWrite <= ID_EX_MemWrite;
    EX_MEM_MemtoReg <= ID_EX_MemtoReg;
	//==== MEM/WB Pipeline Register ====
	MEM_WB_MemReadData <= MemReadData;
    MEM_WB_ALUResult <= EX_MEM_ALUResult;
    MEM_WB_WriteReg <= EX_MEM_WriteReg;
    MEM_WB_RegWrite <= EX_MEM_RegWrite;
    MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
end

assign Output_Addr = Input_Addr + 4;

endmodule
