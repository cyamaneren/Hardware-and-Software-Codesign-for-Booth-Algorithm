`timescale 1ns / 1ps


module booth_tb;

	// Inputs
	reg [7:0] A;
	reg Awrite;
	reg [7:0] B;
	reg Bwrite;
	reg start;
	reg clk;

	// Outputs
	wire done;
	wire [15:0] Result;

	// Instantiate the Unit Under Test (UUT)
	booth_top uut (
		.A(A), 
		.Awrite(Awrite), 
		.B(B), 
		.Bwrite(Bwrite), 
		.start(start), 
		.done(done), 
		.Result(Result),
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		clk=0;
		A = -8'd3;
		Awrite = 1;
		B = -8'd31;
		Bwrite = 1;
		start = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Awrite = 0;
		Bwrite = 0;
		#60;
		start=1;
		// 
		/*
		#80;
		start=0;
		#6000;
		A = -8'd5;
		Awrite = 1;
		B = -8'd8;
		Bwrite = 1;
		#100;
  		Awrite = 0;
		Bwrite = 0;
		#60;
		start=1;
		*/
		//
	end
	
	always #30 clk=~clk;
      
endmodule

