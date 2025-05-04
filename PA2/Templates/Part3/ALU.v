module ALU(
    output reg [31:0] ALU_result,
    output reg Zero,
    input wire [31:0] Rs_data,
    input wire [31:0] Second_data,
    input wire [4:0] Shamt,
    input wire [5:0] Funct
);
    assign ALU_result = 32'b0;
    always @(*) begin
        case(Funct)
            6'b001001: ALU_result = Rs_data + Second_data;
            6'b001010: ALU_result = Rs_data - Second_data;
            6'b100001: ALU_result = Rs_data << Shamt;
            6'b100101: ALU_result = Rs_data | Second_data;
            default: ALU_result = 32'b0;
        endcase
        Zero = (ALU_result == 32'b0);
    end
endmodule
