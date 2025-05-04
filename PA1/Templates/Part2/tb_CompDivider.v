`timescale 10 ns / 1 ns
// Declarations
`define DELAY			1	// # * timescale
`define INPUT_FILE		"testbench/tb_CompDivider.in"
`define OUTPUT_FILE		"testbench/tb_CompDivider.out"
// Declaration
`define LOW		1'b0
`define HIGH	1'b1
module tb_CompDivider;
	// Inputs
	reg Reset;
	reg Run;
	reg [31:0] Dividend;
	reg [31:0] Divisor;
	// Outputs
	wire [31:0] Quotient;
	wire [31:0] Remainder;
	wire Ready;
	// Clock
	reg clk = `LOW;
	// Testbench variables
	reg [63:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	CompDivider UUT(
		// Outputs
		.Quotient(Quotient),
		.Remainder(Remainder),
		.Ready(Ready),
		// Inputs
		.Dividend(Dividend),
		.Divisor(Divisor),
		.Run(Run),
		.Reset(Reset),
		.clk(clk)
	);
	initial
	begin : Preprocess
		// Initialize inputs
		Reset 		= `LOW;
		Run 		= `LOW;
		Dividend	= 32'd0;
		Divisor	= 32'd0;
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
			$fscanf(input_file, "%x\n", read_data);
			@(posedge clk);	// Wait clock
			{Dividend, Divisor} = read_data;
			Reset = `HIGH;
			@(posedge clk);	// Wait clock
			Reset = `LOW;
			@(posedge clk);	// Wait clock
			Run = `HIGH;
			@(posedge Ready);	// Wait ready
			Run = `LOW;
		end
		#`DELAY;	// Wait for result stable
		// Close output file for safety
		$fclose(output_file);
		// Stop the simulation
		$stop();
	end
	always @(posedge Ready)
	begin : Monitoring
		$display("Dividend:%d, Divisor:%d", Dividend, Divisor);
		$display("Quotient:%d, Remainder:%d", Quotient, Remainder);
		$fdisplay(output_file, "%x_%x", Quotient, Remainder);
	end
endmodule
