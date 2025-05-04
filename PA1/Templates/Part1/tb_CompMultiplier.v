`timescale 10 ns / 1 ns
// Declarations
`define DELAY			3	// # * timescale
`define INPUT_FILE		"testbench/tb_CompMultiplier.in"
`define OUTPUT_FILE		"testbench/tb_CompMultiplier.out"
// Declaration
`define LOW		1'b0
`define HIGH	1'b1
module tb_CompMultiplier;
	// Inputs
	reg Reset, Run;
	reg [31:0] Multiplicand, Multiplier;
	// Outputs
	wire [63:0] Product;
	wire Ready;
	// Clock
	reg clk = `LOW;	
	// Testbench variables
	reg [63:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	CompMultiplier UUT(
		// Outputs
		.Product(Product),
		.Ready(Ready),
		// Inputs
		.Multiplicand(Multiplicand),
		.Multiplier(Multiplier),
		.Run(Run),
		.Reset(Reset),
		.clk(clk)
	);
	initial
	begin : Preprocess
		// Initialize inputs
		Reset 		= `LOW;
		Run 		= `LOW;
		Multiplicand	= 32'd0;
		Multiplier 	= 32'd0;
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
			{Multiplicand, Multiplier} = read_data;
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
		$display("Multiplicand:%d, Multiplier:%d", Multiplicand, Multiplier);
		$display("result:%d", Product);
		$fdisplay(output_file, "%x", Product);
	end
endmodule
