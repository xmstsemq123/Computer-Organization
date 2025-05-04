module tb_Multiplicand;
    reg [31:0] in_data;
    reg clk, reset, w_ctrl;
    wire [31:0] out_data;

    Multiplicand uut (
        .Multiplicand_out(out_data),
        .Multiplicand_in(in_data),
        .clk(clk),
        .Reset(reset),
        .W_ctrl(w_ctrl)
    );

    // Clock 產生器
    always #5 clk = ~clk;

    integer i;

    // 測試資料
    reg [31:0] test_data [0:9];

    initial begin
        // 初始化
        clk = 0; reset = 0; w_ctrl = 0; in_data = 0;

        // 測試資料
        test_data[0] = 32'h00000001;
        test_data[1] = 32'hAAAAAAAA;
        test_data[2] = 32'h12345678;
        test_data[3] = 32'hFFFFFFFF;
        test_data[4] = 32'h0000FFFF;
        test_data[5] = 32'h00FF00FF;
        test_data[6] = 32'hDEADBEEF;
        test_data[7] = 32'h13579BDF;
        test_data[8] = 32'h2468ACE0;
        test_data[9] = 32'h0BADF00D;

        // 測試流程
        for (i = 0; i < 10; i = i + 1) begin
            #10 reset = 1; // 重置
            #10 reset = 0;

            in_data = test_data[i];
            w_ctrl = 1; // 寫入啟用
            #10 w_ctrl = 0;

            #10;
            $display("Test %0d: in = %h, out = %h", i, in_data, out_data);
        end

        #20 $finish;
    end
endmodule
