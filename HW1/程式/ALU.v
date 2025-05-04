`define ADDU    6'b100100
`define SUBU    6'b100011
`define OR      6'b100101
`define SRL     6'b000010
`define SLL     6'b000000

module ALU(
    // Inputs
    input  [31:0] Src_1,
    input  [31:0] Src_2,
    input  [4:0]  Shamt,
    input  [5:0]  Funct,
    // Outputs
    output reg [31:0] ALU_result,
    output reg       Zero,
    output reg       Carry
);
    always @(*) begin
        {Carry, Zero, ALU_result} = 0;
        case (Funct)
            `ADDU: {Carry, ALU_result} = Src_1 + Src_2;
            `SUBU: {Carry, ALU_result} = Src_1 - Src_2;
            `OR:   ALU_result = {1'b0, Src_1 | Src_2};
            `SRL:  ALU_result = Src_1 >> Shamt;
            `SLL:  ALU_result = Src_1 << Shamt;
            default: {Carry, ALU_result, Zero} = 0;
        endcase
        Zero = (ALU_result == 0) ? 1 : 0;
    end

endmodule
