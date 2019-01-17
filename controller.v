`timescale 1ns / 1ps

module controller(
    
    input start,
	 input clk,
	 input [1:0] q_0_1,
    input count_cp_zero,
    output reg reg_uzunB_ld,
    output reg Add_Sub,
    output reg shift_carpim,
    output reg carpim_ld,
    output reg carpim_clr,
    output reg set_count,
    output reg ld_count,
    output reg result_ld,
    output reg result_clr,
	 output reg A_clr,
	 output reg B_clr,
	 output reg done
	  
    );

	 reg [2:0] current_state, state_next;
	 
	 localparam INIT = 3'd0,
					CMP1 = 3'd1,
					SUB = 3'd2,
					ADD = 3'd3,
					SHIFT = 3'd4,
					CMP_COUNT = 3'd5,
					FINISH = 3'd6;
					
	 
	initial
	begin
		current_state<=INIT;
	end

	//state register
	always@(posedge clk)
	begin
		current_state<=state_next;
	end
	
	//next_state_logic and output_logic
	always@*
	begin
		state_next<=current_state;
		case(current_state)
			INIT : begin
						reg_uzunB_ld<=0;
						Add_Sub<=0;
						shift_carpim<=0;
						carpim_ld<=0;
						carpim_clr<=1;
						set_count<=1;
						ld_count<=1;
						result_ld<=0;
						result_clr<=0;
						done<=1;
						A_clr<=0;
						B_clr<=0;
						if(start)
							state_next<=CMP1;
					   else
							state_next<=INIT;
					 end
			CMP1 : begin
						reg_uzunB_ld<=0;
						Add_Sub<=0;
						shift_carpim<=0;
						carpim_ld<=0;
						carpim_clr<=0;
						set_count<=0;
						ld_count<=0;
						result_ld<=0;
						result_clr<=1;
						done<=0;	
						A_clr<=0;
						B_clr<=0;						
						case(q_0_1)
							2'b10: state_next<=SUB;
							2'b01: state_next<=ADD;
							2'b11: state_next<=SHIFT;
							2'b00: state_next<=SHIFT;
					   endcase						
					 end
			SUB : begin
						reg_uzunB_ld<=0;
						Add_Sub<=1;
						shift_carpim<=0;
						carpim_ld<=1;
						carpim_clr<=0;
						set_count<=0;
						ld_count<=0;
						result_ld<=0;
						result_clr<=0;
						done<=0;	
						A_clr<=0;
						B_clr<=0;						
						state_next<=SHIFT;
					 end
			ADD : begin
						reg_uzunB_ld<=0;
						Add_Sub<=0;
						shift_carpim<=0;
						carpim_ld<=1;
						carpim_clr<=0;
						set_count<=0;
						ld_count<=0;
						result_ld<=0;
						result_clr<=0;
						done<=0;	
						A_clr<=0;
						B_clr<=0;						
						state_next<=SHIFT;
					 end
			SHIFT : begin
						reg_uzunB_ld<=1;
						Add_Sub<=0;
						shift_carpim<=1;
						carpim_ld<=1;
						carpim_clr<=0;
						set_count<=0;
						ld_count<=1;
						result_ld<=0;
						result_clr<=0;
						done<=0;		
						A_clr<=0;
						B_clr<=0;
						state_next<=CMP_COUNT;			
					 end
			CMP_COUNT : begin
						reg_uzunB_ld<=0;
						Add_Sub<=0;
						shift_carpim<=0;
						carpim_ld<=0;
						carpim_clr<=0;
						set_count<=0;
						ld_count<=0;
						result_ld<=0;
						result_clr<=0;
						done<=0;
						A_clr<=0;
						B_clr<=0;						
						if(count_cp_zero)
							state_next<=FINISH;
					   else
							state_next<=CMP1;			
					 end
			FINISH : begin
						reg_uzunB_ld<=0;
						Add_Sub<=0;
						shift_carpim<=0;
						carpim_ld<=0;
						carpim_clr<=0;
						set_count<=0;
						ld_count<=0;
						result_ld<=1;
						result_clr<=0;
						done<=1;	
						A_clr<=1;
						B_clr<=1;						
						state_next<=INIT;				
					 end					 
		endcase
	end
endmodule
