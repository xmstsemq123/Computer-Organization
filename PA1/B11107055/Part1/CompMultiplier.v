module CompMultiplier(
	// Outputs
	output  [63:0]	Product,
	output		Ready,
	// Inputs
	input	[31:0]	Multiplicand, Multiplier,
	input		Run, Reset, clk
);
	wire [31:0] Src_1, Src_2, Result;
	wire [5:0] Funct;
	wire W_ctrl, LSB, SRL_ctrl, Carry;
	assign Src_1 = Product[63:32];
	Multiplicand MultiplicandRegister (
		.Multiplicand_out(Src_2),
        .Multiplicand_in(Multiplicand),
        .clk(clk),
        .Reset(Reset),
        .W_ctrl(W_ctrl)
	);
	Product ProductRegister (
        .Multiplier_in(Multiplier),
        .Product_out(Product),
        .LSB(LSB),
        .ALU_result(Result),
        .ALU_carry(Carry),
        .SRL_ctrl(SRL_ctrl),
        .W_ctrl(W_ctrl),
        .Ready(Ready),
        .Reset(Reset),
        .clk(clk)
    );
	ALU ALU (
        .Result(Result),
        .Carry(Carry),
        .Src_1(Src_1),
        .Src_2(Src_2),
        .Funct(Funct),
        .clk(clk)
    );
	Control Controller (
        .Addu_ctrl(Funct),
        .SRL_ctrl(SRL_ctrl),
        .W_ctrl(W_ctrl),
        .Ready(Ready),
        .Run(Run),
        .Reset(Reset),
        .clk(clk),
        .LSB(LSB)
    );
endmodule
