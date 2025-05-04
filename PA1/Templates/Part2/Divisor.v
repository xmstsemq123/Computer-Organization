module Divisor(
    output reg [31:0] Divisor_out,
    input reg [31:0] Divisor_in,
    input Reset, W_ctrl, clk
);
    always @(*) begin
        if(Reset) Divisor_out = 32'b0;
        else if(W_ctrl) Divisor_out = Divisor_in;
    end
endmodule
