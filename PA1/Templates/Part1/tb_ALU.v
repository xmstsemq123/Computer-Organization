`timescale 1ns / 1ps

module tb_ALU;
    reg [31:0] Src_1, Src_2;
    reg [5:0] Funct;
    reg clk;
    wire [31:0] Result;
    wire Carry;

    ALU uut (
        .Result(Result),
        .Carry(Carry),
        .Src_1(Src_1),
        .Src_2(Src_2),
        .Funct(Funct),
        .clk(clk)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        // 初始化
        clk = 0;
        Src_1 = 0; Src_2 = 0; Funct = 6'b000001;

        // 等待幾個 clock edge 開始測試
        #10;

        // 測試 1: 加法 (無進位)
        Src_1 = 32'h00000001;
        Src_2 = 32'h00000002;
        Funct = 6'b000001;
        #10 $display("Test 1 - Add: %h + %h = %h, Carry = %b", Src_1, Src_2, Result, Carry);

        // 測試 2: 加法 (有進位)
        Src_1 = 32'hFFFFFFFF;
        Src_2 = 32'h00000001;
        Funct = 6'b000001;
        #10 $display("Test 2 - Add with Carry: %h + %h = %h, Carry = %b", Src_1, Src_2, Result, Carry);

        // 測試 3: Funct = 0（保持原狀）
        Src_1 = 32'h12345678;
        Src_2 = 32'h9ABCDEF0;
        Funct = 6'b000000;
        #10 $display("Test 3 - Hold: Result = %h, Carry = %b", Result, Carry);

        // 測試 4: Funct = default case
        Funct = 6'b111111;
        #10 $display("Test 4 - Default: Result = %h, Carry = %b", Result, Carry);

        #20 $finish;
    end
endmodule
