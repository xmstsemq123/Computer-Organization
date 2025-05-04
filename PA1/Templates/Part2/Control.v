module Control(
    output reg [5:0] Subu_ctrl,
    output reg W_ctrl, SLL_ctrl, SRL_ctrl, Ready,
    input Run, Reset, clk, Neg_Rem
);
    reg is_initialize = 0, is_first_round = 1, is_second_round_sub = 0, is_second_round_write = 0, is_third_round_sub = 0, is_third_round_write = 0, is_done_round_sll = 0, is_done_round_write = 0;
    reg is_final_done_SRL = 0, has_w_ctrl = 0;
    integer count = 1;
    always @(posedge clk) begin
        if (Reset) begin
            Subu_ctrl <= 6'b000000;
            W_ctrl <= 1;
            SLL_ctrl <= 0;
            SRL_ctrl <= 0;
            Ready <= 0;
            is_initialize <= 0;
            is_first_round <= 1;
            is_second_round_sub <= 0;
            is_second_round_write <= 0;
            is_third_round_sub <= 0;
            is_third_round_write <= 0;
            is_done_round_sll <= 0;
            is_done_round_write <= 0;
            is_final_done_SRL <= 0;
            count <= 1;
        end 
        else if(Run) begin
            // First, let ALU get remainder_out
            if (SLL_ctrl) SLL_ctrl <= 0;
            else if(W_ctrl) W_ctrl <= 0;
            else if(Subu_ctrl != 6'b000000) Subu_ctrl <= 6'b000000;
            // first round
            else if(is_first_round) begin
                is_first_round <= 0;
                SLL_ctrl <= 1;
                is_second_round_sub <= 1;
            end
            // second round
            else if(is_second_round_sub) begin
                is_second_round_sub <= 0;
                Subu_ctrl <= 6'b000010; // subtract
                is_second_round_write <= 1;
            end
            else if(is_second_round_write) begin
                is_second_round_write <= 0;
                W_ctrl <= 1;
                is_third_round_sub <= 1;
            end
            // third round
            else if(is_third_round_sub) begin
                is_third_round_sub <= 0;
                Subu_ctrl <= (Neg_Rem) ? 6'b000001 : 6'b000000;
                is_third_round_write <= 1;
            end 
            else if(is_third_round_write) begin
                is_third_round_write <= 0;
                W_ctrl <= 1;
                is_done_round_sll <= 1;
            end
            // final
            else if(is_done_round_sll) begin
                is_done_round_sll <= 0;
                SLL_ctrl <= 1;
                is_done_round_write <= 1;
            end
            else if(is_done_round_write) begin
                is_done_round_write <= 0;
                W_ctrl <= 1;
                count <= count + 1;
                is_second_round_sub <= 1;
            end
            // check count
            if (count > 32) begin
                is_second_round_sub <= 0;
                if(!is_final_done_SRL) begin
                    SRL_ctrl <= 1;
                    is_final_done_SRL <= 1;
                end else begin
                    SRL_ctrl <= 0;
                    Ready <= 1;
                end
            end
         end
    end
endmodule
