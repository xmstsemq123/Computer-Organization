module Product(
    output reg [63:0] Product_out,
    output reg LSB,
    input [31:0] Multiplier_in,
    input [31:0] ALU_result,
    input ALU_carry,
    input SRL_ctrl,
    input W_ctrl,
    input Ready,
    input Reset,
    input clk
);
    reg pre_carry = 0;
    assign LSB = Product_out[0];
    always @(posedge clk) begin
        pre_carry <= ALU_carry;
        if (Reset) begin
            pre_carry <= 0;
            Product_out[31:0] <= Multiplier_in;
            Product_out[63:32] <= 32'b0;
        end
        else if(!Ready) begin
            if(W_ctrl) begin
                Product_out[63:32] <= ALU_result;
            end
            else if(SRL_ctrl) Product_out <= {pre_carry, Product_out[63:1]};
        end
    end
endmodule
