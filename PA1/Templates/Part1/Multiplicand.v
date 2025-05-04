module Multiplicand(
    output reg [31:0] Multiplicand_out,
    input [31:0] Multiplicand_in,
    input clk,
    input Reset,
    input W_ctrl
);
    always @(*) begin
        if (Reset)
            Multiplicand_out = 32'b0;
        else if (W_ctrl)
            Multiplicand_out = Multiplicand_in;
    end
endmodule
