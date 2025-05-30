module ALU_Control(
    output reg [5:0] Funct,
    input wire [5:0] Funct_ctrl,
    input wire [1:0] ALU_op
);
    always @(*) begin
        // R-type
        if(ALU_op == 2'b10) begin
            case(Funct_ctrl)
                6'b100001: Funct = 6'b001001; // Add
                6'b100011: Funct = 6'b001010; // Sub
                6'b000000: Funct = 6'b100001; // SLL
                6'b100101: Funct = 6'b100101; // Or
                default: Funct = 6'b000000;
            endcase
        end 
        // I-type, J-type (Don't care about Funct_ctrl)
        else if(ALU_op == 2'b00) Funct = 6'b001001; // Add
        else if(ALU_op == 2'b01) Funct = 6'b001010; // Sub
        else if(ALU_op == 2'b11) Funct = 6'b100101; // Or
        else Funct = 6'b000000;
    end
endmodule