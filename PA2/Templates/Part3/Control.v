module Control(
    output reg Reg_dst, Branch, Reg_w, ALU_src, Mem_w, Mem_r, Mem_to_reg, Jump, 
    output reg [1:0] ALU_op,
    input reg [5:0] OpCode
);
    always @(*) begin
        // All reset to 0
        Reg_dst    = 0;
        ALU_src    = 0;
        ALU_op     = 2'b00;
        Mem_r      = 0;
        Mem_w      = 0;
        Mem_to_reg = 0;
        Reg_w      = 0;
        Branch     = 0;
        Jump       = 0;
        case (OpCode)
            6'b000000: begin  // R-type
                Reg_dst    = 1;
                ALU_src    = 0;
                ALU_op     = 2'b10;
                Reg_w      = 1;
            end
            6'b001001: begin  // addiu
                ALU_src    = 1;
                ALU_op     = 2'b00;
                Reg_w      = 1;
            end
            6'b100011: begin  // lw
                ALU_src    = 1;
                ALU_op     = 2'b00;
                Mem_r      = 1;
                Mem_to_reg = 1;
                Reg_w      = 1;
            end
            6'b101011: begin  // sw
                ALU_src    = 1;
                ALU_op     = 2'b00;
                Mem_w      = 1;
            end
            6'b001101: begin  // ori
                ALU_src    = 1;
                ALU_op     = 2'b11;
                Reg_w      = 1;
            end
            6'b000100: begin  // beq
                ALU_src    = 0;
                ALU_op     = 2'b01;
                Branch     = 1;
            end
            6'b000010: begin  // j
                Jump       = 1;
            end
            default: begin
                // all output reset to zero if opcode is not support
            end
        endcase
    end
endmodule
