// Setting timescale
`timescale 10 ns / 1 ns
// Configuration
`define DELAY			1	// # * timescale
`define INPUT_FILE		"testbench/tb_ALU.in"
`define OUTPUT_FILE		"testbench/tb_ALU.out"
// Declaration
`define LOW		1'b0
`define HIGH	1'b1
module tb_ALU;
	// Inputs
	reg [31:0] Src_1;
	reg [31:0] Src_2;
	reg [4:0] Shamt;
	reg [5:0] Funct;
	// Outputs
	wire [31:0] ALU_result;
	wire Zero;
	wire Carry;
	// Clock
	reg clk = `LOW;
	// Testbench variables
	reg [74:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	ALU UUT(
		// Inputs
		.Src_1(Src_1),
		.Src_2(Src_2),
		.Shamt(Shamt),
		.Funct(Funct),
		// Outputs
		.ALU_result(ALU_result),
		.Zero(Zero),
		.Carry(Carry)
	);
	initial
	begin : Preprocess
		// Initialize inputs
		Src_1	= 32'b0;
		Src_2	= 32'b0;
		Shamt	= 5'b0;
		Funct	= 6'b0;
		// Initialize testbench files
		input_file	= $fopen(`INPUT_FILE, "r");
		output_file	= $fopen(`OUTPUT_FILE);
		#`DELAY;	// Wait for global reset to finish
	end
	always
	begin : ClockGenerator
		#`DELAY;
		clk <= ~clk;
	end
	always
	begin : StimuliProcess
		// Start testing
		while (!$feof(input_file))
		begin
			$fscanf(input_file, "%b\n", read_data);
			@(posedge clk);	// Wait clock
			{Src_1, Src_2, Shamt, Funct} = read_data;
			@(negedge clk);	// Wait clock
			$display("Src_1:%b, Src_2:%b, Shamt:%b, Funct:%b", Src_1, Src_2, Shamt, Funct);
			$display("ALU_result:%d, Z:%b, C:%b", ALU_result, Zero, Carry);
			$fdisplay(output_file, "%t,%b,%b,%b", $time, ALU_result, Zero, Carry);
		end
		// Close output file for safety
		$fclose(output_file);
		// Stop the simulation
		$stop();
	end
endmodule
