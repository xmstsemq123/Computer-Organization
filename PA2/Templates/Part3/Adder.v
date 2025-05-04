module Adder(
    output reg [31:0] Adder_result,
    input wire [31:0] Input1,
    input wire [31:0] Input2
);
    always @(*) begin
        Adder_result = Input1 + Input2;
    end
endmodule