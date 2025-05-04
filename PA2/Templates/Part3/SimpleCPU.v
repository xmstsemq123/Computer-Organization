module SimpleCPU(
	// Outputs
	output	reg	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);
	wire [31:0] Instruction, Rs_Data, Rt_Data;
	reg [31:0] Mem_to_Reg_Data;
	reg [4:0] Rd_Addr;
	wire Reg_w;
	IM Instr_Memory(
		// Outputs
		.Instr(Instruction),
		// Inputs
		.InstrAddr(Input_Addr)
	);
	RF Register_File(
		// Outputs
		.RsData(Rs_Data),
		.RtData(Rt_Data),
		// Inputs
		.RsAddr(Instruction[25:21]),
		.RtAddr(Instruction[20:16]),
		.RdAddr(Rd_Addr),
		.RdData(Mem_to_Reg_Data),
		.RegWrite(Reg_w),
		.clk(clk)
	);
	wire Mem_Write, Mem_Read;
	wire [31:0] ALU_src_Data, Mem_r_data;
	DM Data_Memory(
		// Outputs
		.MemReadData(Mem_r_data),
		// Inputs
		.MemAddr(ALU_src_Data),
		.MemWriteData(Rt_Data),
		.MemWrite(Mem_Write),
		.MemRead(Mem_Read),
		.clk(clk)
	);
	wire [31:0] NextPC;
	Adder Plus4Adder(
		// Outputs
		.Adder_result(NextPC),
		// Inputs
		.Input1(4),
		.Input2(Input_Addr)
	);
	wire [31:0] BranchPC;
	reg [31:0] SignExtendedAddr, SignExtendedShiftedAddr;
	Adder PlusAddrAdder(
		// Outputs
		.Adder_result(BranchPC),
		// Inputs
		.Input1(NextPC),
		.Input2(SignExtendedShiftedAddr)
	);
	reg [31:0] ALU_src_Mux_Data;
	wire Zero;
	wire [5:0] Funct;
	ALU ALUBlock(
		// Outputs
		.ALU_result(ALU_src_Data),
		.Zero(Zero),
		// Inputs
		.Rs_data(Rs_Data),
		.Second_data(ALU_src_Mux_Data),
		.Shamt(Instruction[10:6]),
		.Funct(Funct)
	);
	wire [1:0] ALU_op;
	ALU_Control ALUController(
		// Outputs
		.Funct(Funct),
		// Inputs
		.Funct_ctrl(Instruction[5:0]),
		.ALU_op(ALU_op)
	);
	wire Reg_dst, Branch, ALU_src, Mem_to_reg, Jump;
	Control Controller(
		// Outputs
		.Reg_dst(Reg_dst), 
		.Branch(Branch), 
		.Reg_w(Reg_w), 
		.ALU_src(ALU_src), 
		.Mem_w(Mem_Write), 
		.Mem_r(Mem_Read), 
		.Mem_to_reg(Mem_to_reg), 
		.Jump(Jump), 
		.ALU_op(ALU_op),
		// Inputs
		.OpCode(Instruction[31:26])
	);
	always @(*) begin
		Rd_Addr = (Reg_dst) ? Instruction[15:11] : Instruction[20:16];
		SignExtendedAddr = {{16{Instruction[15]}}, Instruction[15:0]};
		SignExtendedShiftedAddr = SignExtendedAddr << 2;
		ALU_src_Mux_Data = (ALU_src) ? SignExtendedAddr : Rt_Data;
		Mem_to_Reg_Data = (Mem_to_reg) ? Mem_r_data : ALU_src_Data;
		Output_Addr = (Jump) ? {NextPC[31:28], Instruction[25:0], 2'b00} : (Zero & Branch) ? BranchPC : NextPC;
	end
endmodule
