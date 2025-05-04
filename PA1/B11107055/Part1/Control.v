module Control(
    output reg [5:0] Addu_ctrl,
    output reg SRL_ctrl, W_ctrl, Ready,
    input Run, Reset, clk, LSB
);
    integer count = 1;
    reg has_W_ctrl = 0;
    always @(posedge clk) begin
        if(Reset) begin
            Addu_ctrl <= 6'b0;
            SRL_ctrl <= 0;
            W_ctrl <= 0;
            Ready <= 0;
        end 
        else if(Run) begin
            if(count > 32) Ready <= 1;
            else begin
                W_ctrl <= 1;
                SRL_ctrl <= 0;
                if (has_W_ctrl) begin
                    count <= count + 1;
                    Addu_ctrl <= (LSB) ? 6'b000001 : 6'b000000;
                    W_ctrl <= 0;
                    SRL_ctrl <= 1;
                    has_W_ctrl <= 0;
                end else has_W_ctrl <= 1;
            end
        end else count <= 0;
    end
endmodule
