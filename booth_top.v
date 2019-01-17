`timescale 1ns / 1ps

module booth_top(
    input [7:0] A,
    input Awrite,
    input [7:0] B,
    input Bwrite,
    input start,
	 input clk,
    output done,
    output [15:0] Result
    );

    wire [1:0] q_0_1; 
    wire count_cp_zero; 
    wire reg_uzunB_ld;
    wire Add_Sub; 
    wire shift_carpim; 
    wire carpim_ld;
    wire carpim_clr; 
    wire set_count;
    wire ld_count; 
    wire result_ld;
    wire result_clr;
	 wire A_clr;
	 wire B_clr;

controller cu1 (
    .start(start), 
    .clk(clk), 
    .q_0_1(q_0_1), 
    .count_cp_zero(count_cp_zero), 
    .reg_uzunB_ld(reg_uzunB_ld), 
    .Add_Sub(Add_Sub), 
    .shift_carpim(shift_carpim), 
    .carpim_ld(carpim_ld), 
    .carpim_clr(carpim_clr), 
    .set_count(set_count), 
    .ld_count(ld_count), 
    .result_ld(result_ld), 
    .result_clr(result_clr), 
    .done(done),
	 .A_clr(A_clr),
	 .B_clr(B_clr)
    );
	 
datapath dat1 (
    .A(A), 
    .B(B), 
    .clk(clk), 
    .Awrite(Awrite), 
    .Bwrite(Bwrite), 
    .reg_uzunB_ld(reg_uzunB_ld), 
    .Add_Sub(Add_Sub), 
    .shift_carpim(shift_carpim), 
    .carpim_ld(carpim_ld), 
    .carpim_clr(carpim_clr), 
    .set_count(set_count), 
    .ld_count(ld_count), 
    .result_ld(result_ld), 
    .result_clr(result_clr), 
    .q_0_1(q_0_1), 
    .count_cp_zero(count_cp_zero), 
    .Result(Result),
	 .A_clr(A_clr),
	 .B_clr(B_clr)
    );	 
endmodule
