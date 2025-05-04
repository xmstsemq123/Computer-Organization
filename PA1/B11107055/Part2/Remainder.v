module Remainder(
    output reg [63:0] Remainder_out,
    input [31:0] ALU_result, 
    input [31:0] Dividend_in,
    input ALU_carry, SLL_ctrl, SRL_ctrl, W_ctrl, Ready, Reset, clk, Neg_Rem
);
    reg signed [31:0] ALU_result_signed;
    reg SLL_Edge_Carry = 0;
    assign ALU_result_signed = ALU_result;
    always @(posedge clk) begin
        if (Reset) Remainder_out <= {32'b0, Dividend_in};
        else if(Ready) Remainder_out <= Remainder_out;
        else if (W_ctrl) Remainder_out <= {ALU_result, Remainder_out[31:0]};
        else if (SLL_ctrl) {SLL_Edge_Carry, Remainder_out} <= {Remainder_out[63:0], ALU_carry};
        else if (SRL_ctrl) Remainder_out <= {SLL_Edge_Carry, Remainder_out[63:33], Remainder_out[31:0]};
    end
endmodule
