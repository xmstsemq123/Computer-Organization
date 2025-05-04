module CompALU(
    // Inputs
    input  [31:0] Instruction,
    // Outputs
    output [31:0] CompALU_out,
    output        CompALU_zero,
    output        CompALU_carry
);
wire [31:0] Inner_Src_1;
wire [31:0] Inner_Src_2;
RF Register_File(
    // Inputs
    .Rs_addr(Instruction[25:21]),
    .Rt_addr(Instruction[20:16]),
    // Outputs
    .Src_1(Inner_Src_1),
    .Src_2(Inner_Src_2)
);
ALU Arithmetic_Logical_Unit(
    // Inputs
    .Src_1(Inner_Src_1),
    .Src_2(Inner_Src_2),
    .Shamt(Instruction[10:6]),
    .Funct(Instruction[5:0]),
    // Outputs
    .ALU_result(CompALU_out),
    .Zero(CompALU_zero),
    .Carry(CompALU_carry)
);
endmodule