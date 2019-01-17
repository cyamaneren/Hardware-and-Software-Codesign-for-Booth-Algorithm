`timescale 1ns / 1ps

module datapath(
    input [7:0] A,
    input [7:0] B,
  	 input clk,
    input Awrite,
    input Bwrite,
    input reg_uzunB_ld,
    input Add_Sub,
    input shift_carpim,
    input carpim_ld,
    input carpim_clr,
    input set_count,
    input ld_count,
    input result_ld,
    input result_clr,
	 input A_clr,
	 input B_clr,
    output [1:0] q_0_1,
    output count_cp_zero,
    output [15:0] Result
    );

	wire [15:0] carpim_out, shift_carry_out, mux_16_bit_out, add_sub_out, regA_out;
	wire [8:0] mux_9_bit_out, shift_9_bit_out, reg_uzun_B_out;
	wire [4:0] mux_5_bit_out, count_out, sub_1_out;
	wire reg_uzun_B_ld_wire;
	wire C;
	
	assign reg_uzun_B_ld_wire = (/*(~start)&*/Bwrite)|reg_uzunB_ld;
	assign  q_0_1 = reg_uzun_B_out[1:0];
	
	reg_A reg_a1 (
    .clk(clk), 
    .in({A,8'd0}), 
    .load(Awrite),
	 .clr(A_clr),
    .out(regA_out)
    );

	reg_uzunB reg_uzunB1 (
    .clk(clk), 
    .in(mux_9_bit_out), 
    .load(reg_uzun_B_ld_wire),
	 .clr(B_clr),
    .out(reg_uzun_B_out)
    );
	 
	 carpim carpim1 (
    .clk(clk), 
    .in(mux_16_bit_out), 
    .load(carpim_ld), 
    .clr(carpim_clr), 
    .out(carpim_out)
    );

	count count1 (
    .clk(clk), 
    .in(mux_5_bit_out), 
    .load(ld_count), 
    .out(count_out)
    );


	result result1 (
    .clk(clk), 
    .in(carpim_out), 
    .clr(result_clr), 
    .load(result_ld), 
    .out(Result)
    );


	mux_2_1_16bit mux0 (
    .sifir(add_sub_out), 
    .bir(shift_carry_out), 
    .sel(shift_carpim), 
    .out(mux_16_bit_out)
    );


	mux_2_1_5bit mux1 (
    .sifir(sub_1_out), 
    .bir(5'd8), 
    .sel(set_count), 
    .out(mux_5_bit_out)
    );

	mux_2_1_9bit mux2 (
    .sifir(shift_9_bit_out), 
    .bir({B,1'b0}), 
    .sel(Bwrite), 
    .out(mux_9_bit_out)
    );


	add_sub_mod add_sub_1 (
    .A(carpim_out), 
    .B(regA_out), 
    .add_sub(Add_Sub), 
    .C(C), 
    .out(add_sub_out)
    );
	
	right_shift shift0 (
    .in(reg_uzun_B_out), 
    .out(shift_9_bit_out)
    );
	 
	 right_shift_carry shift1 (
    .in(carpim_out), 
    .out(shift_carry_out)
    );
	
	sub_1 sub2 (
    .in(count_out), 
    .out(sub_1_out)
    );
	
	zero_comparator zero_1 (
    .in(count_out), 
    .Z(count_cp_zero)
    );




endmodule

// registerlar
module reg_A (
	input clk,
	input [15:0] in,
	input load,
	input clr,
	output [15:0] out

);

	reg [15:0] register_t;
	initial begin
		register_t<=16'd0;
	end
	always@(posedge clk)
	begin
		if(clr)
			register_t<=16'd0;
		else if(load)
			register_t<=in;
	end

	assign out=register_t;
endmodule

module reg_uzunB (
	input clk,
	input [8:0] in,
	input load,
	input clr,
	output [8:0] out

);

	reg [8:0] register_t;
	initial begin
		register_t<=9'd0;
	end
	always@(posedge clk)
	begin
		if(clr)
		   register_t<=9'd0;
		else if(load)
			register_t<=in;
	end

	assign out=register_t;
endmodule

module carpim (
	input clk,
	input [15:0] in,
	input load,
	input clr,
	output [15:0] out

);

	reg [15:0] register_t;
	initial begin
		register_t<=16'd0;
	end
	always@(posedge clk)
	begin
		if(clr)
			register_t<=16'd0;
		else if(load)
			register_t<=in;
	end

	assign out=register_t;
endmodule

module count (
	input clk,
	input [4:0] in,
	input load,
   output [4:0] out

);

	reg [4:0] register_t;
	initial begin
		register_t<=5'd8;
	end
	always@(posedge clk)
	begin
		if(load)
			register_t<=in;
	end

	assign out=register_t;
endmodule


module result (
	input clk,
	input [15:0] in,
	input clr,
	input load,
   output [15:0] out

);

	reg [15:0] register_t;
	initial begin
		register_t<=16'd0;
	end
	always@(posedge clk)
	begin
		if(clr)
			register_t<=0;
		else if(load)
			register_t<=in;
	end

	assign out=register_t;
endmodule
// iþlem bloklarý

module right_shift (
	input [8:0] in,
	output [8:0] out
);

	assign out = {1'b0, in[8:1]};

endmodule

module add_sub_mod (
	input [15:0] A,
	input [15:0] B,
	input add_sub,
	output C,
	output [15:0] out
);
	// add_sub 0 ise toplama, 1 ise çýkarma
 assign {C,out} = (~add_sub) ? (A+B) : (A-B); 
endmodule

module right_shift_carry (
	input [15:0] in,
	output [15:0] out
);

	assign out = {in[15], in[15:1]};

endmodule

module sub_1 (
	input [4:0] in,
	output [4:0] out

);

	assign out = in-5'd1;
endmodule

module zero_comparator (
	input [4:0] in,
	output Z
// count 0 ise z=1
);

	assign Z = ~(|in);
endmodule

module mux_2_1_9bit (
	input [8:0] sifir,
	input [8:0] bir,
	input  sel,
	output reg [8:0] out

);
	always @* 
	begin
		case(sel)
			1'd0: out=sifir;
			1'd1: out=bir;
		endcase
	end
	
endmodule

module mux_2_1_16bit (
	input [15:0] sifir,
	input [15:0] bir,
	input  sel,
	output reg [15:0] out

);
	always @* 
	begin
		case(sel)
			1'd0: out=sifir;
			1'd1: out=bir;
		endcase
	end
	
endmodule

module mux_2_1_5bit (
	input [4:0] sifir,
	input [4:0] bir,
	input  sel,
	output reg [4:0] out

);
	always @* 
	begin
		case(sel)
			1'd0: out=sifir;
			1'd1: out=bir;
		endcase
	end
	
endmodule


















































