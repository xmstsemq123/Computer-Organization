module ALU(
    output reg [31:0] ALU_result,
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [4:0] Shamt,
    input wire [5:0] Funct
);
    assign ALU_result = 32'b0;
    always @(*) begin
        case(Funct)
            6'b001001: ALU_result = in1 + in2;
            6'b001010: ALU_result = in1 - in2;
            6'b100001: ALU_result = in1 << Shamt;
            6'b100101: ALU_result = in1 | in2;
            default: ALU_result = 32'b0;
        endcase
    end
endmodule
