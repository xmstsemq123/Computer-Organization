module FinalCPU(
    output reg [31:0] Output_Addr,
    output wire PC_Write,
    input wire [31:0] Input_Addr,
    input wire clk
);

reg [31:0] PC;
assign PC = Input_Addr;
reg [31:0] IF_ID_Instr;
reg IF_ID_write = 1;
wire [31:0] Instr;

IM Instr_Memory(
    .Instr(Instr),
    .InstrAddr(PC)
);

// ==== Control Signals ==== 
wire RegWrite, MemWrite, ALUSrc, MemtoReg, RegDst, MemRead;
wire [1:0] ALUOp;
Control control(
    .OpCode(IF_ID_Instr[31:26]),
    .Reg_w(RegWrite),
    .Mem_w(MemWrite),
    .ALU_op(ALUOp),
    .ALU_src(ALUSrc),
    .Mem_to_reg(MemtoReg),
    .Reg_dst(RegDst),
    .MemRead(MemRead)
);

// ==== Register File ==== 
wire [31:0] RsData, RtData;
wire [4:0] MEM_WB_WriteReg;
wire MEM_WB_RegWrite, MEM_WB_MemtoReg;
wire [31:0] MEM_WB_MemReadData, MEM_WB_ALUResult;
wire [31:0] WB_Data = MEM_WB_MemtoReg ? MEM_WB_MemReadData : MEM_WB_ALUResult;
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

// ==== ID/EX Wire ==== 
wire [31:0] ID_EX_RsData, ID_EX_RtData, ID_EX_SignExtImm;
wire [4:0] ID_EX_Rs, ID_EX_Rt, ID_EX_Rd;
wire ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_MemtoReg, ID_EX_RegDst, ID_EX_MemRead;
wire [1:0] ID_EX_ALUOp;
reg Stall = 0;

// ==== ALU Control ==== 
wire [5:0] Funct;
ALU_Control alu_control(
    .ALU_op(ID_EX_ALUOp),
    .Funct(Funct),
    .Funct_ctrl(ID_EX_SignExtImm[5:0])
);

// ==== Forwarding Control ==== 
reg [1:0] ForwardA = 2'b00, ForwardB = 2'b00;
wire [31:0] EX_MEM_ALUResult, EX_MEM_RtData;
wire [4:0] EX_MEM_WriteReg;
wire EX_MEM_RegWrite, EX_MEM_MemWrite, EX_MEM_MemtoReg, EX_MEM_MemRead;
reg [31:0] ALUin1, ALUin2_Src, ALUin2, RtData_Forwarded;

// ==== ALU ==== 
wire [31:0] ALUResult;
ALU alu(
    .in1(ALUin1),
    .in2(ALUin2),
    .Funct(Funct),
    .Shamt(ID_EX_SignExtImm[10:6]),
    .ALU_result(ALUResult)
);

// ==== Data Memory ==== 
wire [31:0] MemReadData;
DM Data_Memory(
    .MemReadData(MemReadData),
    .MemAddr(EX_MEM_ALUResult),
    .MemWriteData(EX_MEM_RtData),
    .MemWrite(EX_MEM_MemWrite),
    .MemRead(EX_MEM_MemRead),
    .clk(clk)
);

// ==== Hazard Detection Unit ==== 
assign PC_Write = ~Stall;

ID_EX_Stage ID_EX_Register(
    // output
    .ID_EX_RsData(ID_EX_RsData),
    .ID_EX_RtData(ID_EX_RtData),
    .ID_EX_SignExtImm(ID_EX_SignExtImm),
    .ID_EX_Rs(ID_EX_Rs),
    .ID_EX_Rt(ID_EX_Rt),
    .ID_EX_Rd(ID_EX_Rd),
    .ID_EX_RegWrite(ID_EX_RegWrite),
    .ID_EX_MemWrite(ID_EX_MemWrite),
    .ID_EX_MemRead(ID_EX_MemRead),
    .ID_EX_ALUSrc(ID_EX_ALUSrc),
    .ID_EX_MemtoReg(ID_EX_MemtoReg),
    .ID_EX_RegDst(ID_EX_RegDst),
    .ID_EX_ALUOp(ID_EX_ALUOp),
    // input
    .RsData(RsData),
    .RtData(RtData),
    .IF_ID_Instr(IF_ID_Instr),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegDst(RegDst),
    .ALUOp(ALUOp),
    .Stall(Stall),
    .clk(clk)
);

EX_MEM_Stage EX_MEM_register(
    //output
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .EX_MEM_RtData(EX_MEM_RtData),
    .EX_MEM_WriteReg(EX_MEM_WriteReg),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_MemWrite(EX_MEM_MemWrite),
    .EX_MEM_MemtoReg(EX_MEM_MemtoReg),
    .EX_MEM_MemRead(EX_MEM_MemRead),
    //input
    .ALUResult(ALUResult),
    .RtData_Forwarded(RtData_Forwarded),
    .ID_EX_RegDst(ID_EX_RegDst),
    .ID_EX_Rd(ID_EX_Rd),  
    .ID_EX_Rt(ID_EX_Rt),
    .ID_EX_RegWrite(ID_EX_RegWrite),
    .ID_EX_MemWrite(ID_EX_MemWrite),
    .ID_EX_MemtoReg(ID_EX_MemtoReg),
    .ID_EX_MemRead(ID_EX_MemRead),
    .clk(clk)
);

MEM_WB_Stage MEM_WB_Register(
    .MEM_WB_MemReadData(MEM_WB_MemReadData), 
    .MEM_WB_ALUResult(MEM_WB_ALUResult),
    .MEM_WB_WriteReg(MEM_WB_WriteReg),
    .MEM_WB_RegWrite(MEM_WB_RegWrite), 
    .MEM_WB_MemtoReg(MEM_WB_MemtoReg),
    .MemReadData(MemReadData), 
    .EX_MEM_ALUResult(EX_MEM_ALUResult),
    .EX_MEM_WriteReg(EX_MEM_WriteReg),
    .EX_MEM_RegWrite(EX_MEM_RegWrite), 
    .EX_MEM_MemtoReg(EX_MEM_MemtoReg), 
    .clk(clk)
);

always @(posedge clk) begin
	// IF_ID_Write
	if (IF_ID_write)
        IF_ID_Instr <= Instr;
	// PC_Write
	 if (PC_Write)
        Output_Addr <= PC + 4;
end
always @(*) begin
    ForwardA = 2'b00;
    ForwardB = 2'b00;
    if (EX_MEM_RegWrite && EX_MEM_WriteReg != 0) begin
        if (EX_MEM_WriteReg == ID_EX_Rs) ForwardA = 2'b10;
        if (EX_MEM_WriteReg == ID_EX_Rt) ForwardB = 2'b10;
    end
    if (MEM_WB_RegWrite && MEM_WB_WriteReg != 0) begin
        if (!(EX_MEM_RegWrite && EX_MEM_WriteReg == ID_EX_Rs) && MEM_WB_WriteReg == ID_EX_Rs)
            ForwardA = 2'b01;
        if (!(EX_MEM_RegWrite && EX_MEM_WriteReg == ID_EX_Rt) && MEM_WB_WriteReg == ID_EX_Rt)
            ForwardB = 2'b01;
    end
	if((ID_EX_MemRead && ((ID_EX_Rt == IF_ID_Instr[25:21]) || (ID_EX_Rt == IF_ID_Instr[20:16]))) !== 1)
		Stall = 0;
	else Stall = 1;
    ALUin1 = (ForwardA == 2'b10) ? EX_MEM_ALUResult :
                    (ForwardA == 2'b01) ? WB_Data : ID_EX_RsData;
    ALUin2_Src = (ForwardB == 2'b10) ? EX_MEM_ALUResult :
                            (ForwardB == 2'b01) ? WB_Data : ID_EX_RtData;
    ALUin2 = (ID_EX_ALUSrc) ? ID_EX_SignExtImm : ALUin2_Src;
    RtData_Forwarded =
    (EX_MEM_RegWrite && EX_MEM_WriteReg != 0 && EX_MEM_WriteReg == ID_EX_Rt) ? EX_MEM_ALUResult :
    (MEM_WB_RegWrite && MEM_WB_WriteReg != 0 && MEM_WB_WriteReg == ID_EX_Rt) ? WB_Data :
    ID_EX_RtData;
end
endmodule