module ALU(
    output reg [31:0] Result,
    output reg Carry,
    input [31:0] Src_1, Src_2,
    input [5:0] Funct,
    input clk
);
    assign Carry = 0;
    always @(*) begin
        case(Funct) 
            6'b000001: {Carry, Result} = Src_1 + Src_2;
            6'b000000: {Carry, Result} = {1'b0, Src_1};
            default: {Carry, Result} = {Carry, Result};
        endcase
    end
endmodule
