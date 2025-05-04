`timescale 1ns / 1ps

module tb_Control;
    reg Run, Reset, clk, LSB;
    wire [5:0] Addu_ctrl;
    wire SRL_ctrl, W_ctrl, Ready;

    Control uut (
        .Addu_ctrl(Addu_ctrl),
        .SRL_ctrl(SRL_ctrl),
        .W_ctrl(W_ctrl),
        .Ready(Ready),
        .Run(Run),
        .Reset(Reset),
        .clk(clk),
        .LSB(LSB)
    );

    // clock generator
    always #5 clk = ~clk;

    integer i;

    initial begin
        // Init
        clk = 0; Run = 0; Reset = 0; LSB = 0;

        // Reset pulse
        #10 Reset = 1;
        #10 Reset = 0;

        // Run = 1 and simulate 32 cycles
        Run = 1;

        for (i = 0; i < 35; i = i + 1) begin
            LSB = i % 4; // Alternate LSB between 0 and 1
            #10;
            $display("Cycle %0d: W_ctrl = %b, Addu_ctrl = %b, Ready = %b", i, W_ctrl, Addu_ctrl, Ready);
        end

        Run = 0;
        #20 $finish;
    end
endmodule
