module CompDivider(
	// Outputs
	output	[31:0]	Quotient,
	output	[31:0]	Remainder,
	output			Ready,
	// Inputs
	input	[31:0]	Dividend,
	input	[31:0]	Divisor,
	input			Run,
	input			Reset,
	input			clk
);
wire [63:0] Remainder_out;
wire [31:0] Divisor_out, ALU_result;
wire [5:0] Subu_ctrl;
wire W_ctrl, SLL_ctrl, SRL_ctrl, Neg_Rem, ALU_Carry;
assign Quotient = Remainder_out[31:0];
assign Remainder = Remainder_out[63:32];
Divisor DivisorRegister(
    .Divisor_out(Divisor_out),
    .Divisor_in(Divisor),
    .Reset(Reset), 
	.W_ctrl(W_ctrl), 
	.clk(clk)
);
Remainder RemainderRegister(
    .Remainder_out(Remainder_out),
    .Neg_Rem(Neg_Rem),
    .ALU_result(ALU_result), 
	.Dividend_in(Dividend),
    .ALU_carry(ALU_Carry), 
	.SLL_ctrl(SLL_ctrl), 
	.SRL_ctrl(SRL_ctrl), 
	.W_ctrl(W_ctrl), 
	.Ready(Ready), 
	.Reset(Reset), 
	.clk(clk)
);
ALU ALU(
    .Result(ALU_result),
	.Neg_Rem(Neg_Rem),
    .Carry(ALU_Carry),
    .Src_1(Remainder_out[63:32]), 
	.Src_2(Divisor_out),
    .Subu_ctrl(Subu_ctrl),
    .clk(clk)
);
Control Control(
    .Subu_ctrl(Subu_ctrl),
    .W_ctrl(W_ctrl), 
	.SLL_ctrl(SLL_ctrl), 
	.SRL_ctrl(SRL_ctrl), 
	.Ready(Ready),
    .Run(Run), 
	.Reset(Reset), 
	.clk(clk), 
	.Neg_Rem(Neg_Rem)
);
endmodule
