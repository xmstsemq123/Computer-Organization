module ALU(
    output reg [31:0] Result,
    output reg Carry, Neg_Rem,
    inout reg [31:0] Src_1,
    input [31:0] Src_2,
    input [5:0] Subu_ctrl,
    input clk
);
    assign Carry = 0, Neg_Rem = 0;
    assign Result = Src_1;
    reg signed [63:0] Result_signed;
    assign Result_signed = Result;
    always @(*) begin
        case(Subu_ctrl) 
            6'b000000: {Carry, Result} = {Carry, Result};
            6'b000001: begin 
                Carry = 0;
                Result = Src_1 + Src_2;
                Result_signed = Result;
            end
            6'b000010: begin
                Carry = 1;
                Result = Src_1 - Src_2; 
                Result_signed = Src_1 - Src_2;
            end
            6'b000011: begin
                Carry = 0;
                Neg_Rem = 0;
                Result = Src_1;
                Result_signed = Result;
            end
            default: {Carry, Result} = {Carry, Result};
        endcase
        if (Result_signed < 0) begin
            Neg_Rem = 1;
        end 
        else begin 
            Neg_Rem = 0;
        end    
    end
endmodule
