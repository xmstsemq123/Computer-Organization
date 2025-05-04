// Setting timescale
`timescale 10 ns / 1 ns
// Declarations
`define DELAY			1	// # * timescale
`define REGISTER_SIZE	32	// bit width
`define MAX_REGISTER	32	// index
`define DATA_FILE		"testbench/RF.dat"
`define INPUT_FILE		"testbench/tb_CompALU.in"
`define OUTPUT_FILE		"testbench/tb_CompALU.out"
// Declaration
`define LOW	 1'b0
`define HIGH 1'b1
module tb_CompALU;
	// Inputs
	reg [31:0] Instruction;
	// Outputs
	wire [31:0] CompALU_data;
	wire CompALU_zero;
	wire CompALU_carry;
	// Clock
	reg clk = `LOW;
	// Testbench variables
	reg [`REGISTER_SIZE-1:0] register [0:`MAX_REGISTER-1];
	reg [31:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	CompALU UUT(
		// Inputs
		.Instruction(Instruction),
		// Outputs
		.CompALU_data(CompALU_out),
		.CompALU_zero(CompALU_zero),
		.CompALU_carry(CompALU_carry)
	);
	initial
	begin : Preprocess
		// Initialize inputs
		// Format: OpCode_Src1addr_Src2addr_RESERVED_shamt_funct
		Instruction = 32'b000000_00000_00000_00000_00000_000000;
		// Initialize testbench files
		$readmemh(`DATA_FILE, register);
		input_file	= $fopen(`INPUT_FILE, "r");
		output_file	= $fopen(`OUTPUT_FILE);
		// Initialize internal register
		for (i = 0; i < `MAX_REGISTER; i = i + 1)
		begin
			UUT.Register_File.R[i] = register[i];
		end
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
			Instruction = read_data;
			@(negedge clk);	// Wait clock
			$display("Instruction:%b", read_data);
			$display("CompALU_data:%d, Z:%b, C:%b", CompALU_data, CompALU_zero, CompALU_carry);
			$fdisplay(output_file, "%t,%b,%b,%b", $time, CompALU_data, CompALU_zero, CompALU_carry);
		end
		// Close output file for safety
		$fclose(output_file);
		// Stop the simulation
		$stop();
	end
endmodule
