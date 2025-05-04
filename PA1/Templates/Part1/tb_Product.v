`timescale 1ns / 1ps

module tb_Product;
    reg [31:0] Multiplier_in;
    reg [31:0] ALU_result;
    reg ALU_carry;
    reg SRL_ctrl;
    reg W_ctrl;
    reg Ready;
    reg Reset;
    reg clk;
    wire [31:0] Multiplier;
    wire [63:0] Product_out;
    wire LSB;

    // Instantiate the Product module
    Product uut (
        .Multiplier(Multiplier),
        .Product_out(Product_out),
        .LSB(LSB),
        .Multiplier_in(Multiplier_in),
        .ALU_result(ALU_result),
        .ALU_carry(ALU_carry),
        .SRL_ctrl(SRL_ctrl),
        .W_ctrl(W_ctrl),
        .Ready(Ready),
        .Reset(Reset),
        .clk(clk)
    );

    // Generate clock
    always #5 clk = ~clk;

    integer i;
    reg [31:0] test_multiplier[0:9];
    reg [31:0] test_alu_result[0:9];

    initial begin
        // Initialize
        clk = 0; Reset = 0; W_ctrl = 0; SRL_ctrl = 0; Ready = 0;
        Multiplier_in = 0; ALU_result = 0; ALU_carry = 0;

        // Test patterns
        test_multiplier[0] = 32'h00000001;
        test_multiplier[1] = 32'hAAAAAAAA;
        test_multiplier[2] = 32'h12345678;
        test_multiplier[3] = 32'hFFFFFFFF;
        test_multiplier[4] = 32'h0000FFFF;
        test_multiplier[5] = 32'h00FF00FF;
        test_multiplier[6] = 32'hDEADBEEF;
        test_multiplier[7] = 32'h13579BDF;
        test_multiplier[8] = 32'h2468ACE0;
        test_multiplier[9] = 32'h0BADF00D;

        test_alu_result[0] = 32'h11111111;
        test_alu_result[1] = 32'h22222222;
        test_alu_result[2] = 32'h33333333;
        test_alu_result[3] = 32'h44444444;
        test_alu_result[4] = 32'h55555555;
        test_alu_result[5] = 32'h66666666;
        test_alu_result[6] = 32'h77777777;
        test_alu_result[7] = 32'h88888888;
        test_alu_result[8] = 32'h99999999;
        test_alu_result[9] = 32'hABCDEF01;

        // Apply Reset
        #10 Reset = 1;
        #10 Reset = 0;

        // Test 10 patterns
        for (i = 0; i < 10; i = i + 1) begin
            Multiplier_in = test_multiplier[i];
            ALU_result = test_alu_result[i];

            // Write data
            W_ctrl = 1;
            #10 W_ctrl = 0;

            $display("Write %0d: Multiplier_in = %h, ALU_result = %h, Product_out = %h", i, Multiplier_in, ALU_result, Product_out);

            // Shift right with ALU_carry = i % 2
            ALU_carry = i % 2;
            SRL_ctrl = 1;
            #10 SRL_ctrl = 0;

            $display("After SRL  %0d: ALU_carry = %b, Product_out = %h", i, ALU_carry, Product_out);
        end

        #20 $finish;
    end
endmodule