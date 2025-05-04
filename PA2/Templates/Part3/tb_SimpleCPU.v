// Setting timescale
`timescale 10 ns / 1 ns
// Declarations
`define DELAY			1	// # * timescale
`define INSTR_SIZE		8	// bit width
`define INSTR_MAX		128	// bytes
`define INSTR_FILE		"testbench/IM.dat"
`define REG_SIZE		32	// bit width
`define REG_MAX			32	// words
`define REG_FILE		"testbench/RF.dat"
`define DATA_SIZE		8	// bit width
`define DATA_MAX		128	// bytes
`define DATA_FILE		"testbench/DM.dat"
`define OUTPUT_REG		"testbench/RF.out"
`define OUTPUT_DATA		"testbench/DM.out"
// Declaration
`define LOW		1'b0
`define HIGH	1'b1
module tb_SimpleCPU;
	// Inputs
	reg [31:0] Input_Addr;
	// Outputs
	wire [31:0] Output_Addr;
	// Clock
	reg clk;
	// Testbench variables
	reg [`INSTR_SIZE-1	:0]	instrMem	[0:`INSTR_MAX-1];
	reg [`REG_SIZE-1	:0]	regMem		[0:`REG_MAX-1];
	reg [`DATA_SIZE-1	:0]	dataMem		[0:`DATA_MAX-1];
	integer output_reg;
	integer output_data;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	SimpleCPU UUT(
		// Outputs
		.Output_Addr(Output_Addr),
		// Inputs
		.Input_Addr(Input_Addr),
		.clk(clk)
	);
	initial
	begin : Preprocess
		// Initialize inputs
		Input_Addr	= 32'd0;
		clk = `LOW;
		// Initialize testbench files
		$readmemh(`INSTR_FILE,	instrMem);
		$readmemh(`REG_FILE,	regMem);
		$readmemh(`DATA_FILE,	dataMem);
		output_reg	= $fopen(`OUTPUT_REG);
		output_data	= $fopen(`OUTPUT_DATA);
		// Initialize intruction memory
		for (i = 0; i < `INSTR_MAX; i = i + 1)
		begin
			UUT.Instr_Memory.InstrMem[i] = instrMem[i];
		end
		// Initialize register file
		for (i = 0; i < `REG_MAX; i = i + 1)
		begin
			UUT.Register_File.R[i] = regMem[i];
		end
		// Initialize data memory
		for (i = 0; i < `DATA_MAX; i = i + 1)
		begin
			UUT.Data_Memory.DataMem[i] = dataMem[i];
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
		while (Input_Addr < `INSTR_MAX - 4)
		begin
			@(negedge clk);
			Input_Addr <= Output_Addr;
			@(posedge clk);
		end
		// Read out all register value
		for (i = 0; i < `REG_MAX; i = i + 1)
		begin
			regMem[i] = UUT.Register_File.R[i];
			$fwrite(output_reg, "%x\n", regMem[i]);
		end
		// Read out all memory value
		for (i = 0; i < `DATA_MAX; i = i + 1)
		begin
			dataMem[i] = UUT.Data_Memory.DataMem[i];
			$fwrite(output_data, "%x\n", dataMem[i]);
		end
		// Close output files for safety
		$fclose(output_reg);
		$fclose(output_data);
		//^____^
		$display("   /\\_/\\   /\\_/\\   /\\_/\\    Congratulations !");
		$display("  ( o.o ) ( -.- ) ( ^_^ )   Please Check <<RF.out>><<DM.out>>");
		$display("   > ^ <   > ^ <   > ^ <    Wishing you continued success and happiness.  By ESSLab");
		$display("");
		// Stop the simulation
		$stop();
	end
endmodule
