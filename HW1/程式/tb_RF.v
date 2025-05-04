// Setting timescale
`timescale 10 ns / 1 ns
// Configuration
`define DELAY			1	// # * timescale
`define REGISTER_SIZE	32	// bit width
`define MAX_REGISTER	32	// index
`define DATA_FILE		"testbench/RF.dat"
`define OUTPUT_FILE		"testbench/tb_RF.out"
// Declaration
`define LOW		1'b0
`define HIGH	1'b1
module tb_RF;
	// Inputs
	reg [4:0] Rs_addr;
	reg [4:0] Rt_addr;
	// Outputs
	wire [31:0] Rs_data;
	wire [31:0] Rt_data;
	// Clock
	reg clk = `LOW;
	// Testbench variables
	reg [`REGISTER_SIZE-1:0] register [0:`MAX_REGISTER-1];
	integer output_file;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	RF UUT(
		// Inputs
		.Rs_addr(Rs_addr),
		.Rt_addr(Rt_addr),
		// Outputs
		.Src_1(Rs_data),
		.Src_2(Rt_data)
	);
	initial
	begin : Preprocess
		// Initialize inputs
		Rs_addr = 32'b0;
		Rt_addr = 32'b0;

		// Initialize testbench files
		$readmemh(`DATA_FILE, register);
		output_file = $fopen(`OUTPUT_FILE);
		
		// Initialize internal register
		for (i = 0; i < `MAX_REGISTER; i = i + 1)
		begin
			UUT.R[i] = register[i];
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
		for (i = 0; i < `MAX_REGISTER; i = i + 1)
		begin
			Rs_addr = i[`REGISTER_SIZE-1:0];
			Rt_addr = `REGISTER_SIZE'd`MAX_REGISTER-1 - i[`REGISTER_SIZE-1:0];
			@(clk);	// Wait clock
			$display("Rs_addr:%h, Rt_addr:%h", Rs_addr, Rt_addr);
			$display("Src_1:%h, Src_2:%h", Rs_data, Rt_data);
			$fdisplay(output_file, "%t,%h,%h", $time, Rs_data, Rt_data);
		end

		// Close output file for safety
		$fclose(output_file);

		// Stop the simulation
		$stop();
	end
endmodule
