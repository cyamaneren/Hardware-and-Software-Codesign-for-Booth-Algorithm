`timescale 1ns / 1ps

module UST_modul(
    input clk,
    input reset
    );
wire [9:0] address;
wire [17:0] instruction;
wire [7:0] port_id;
wire write_strobe;
wire [7:0] out_port;
wire read_strobe;
wire [7:0] in_port;
wire interrupt_ack;
wire [7:0] A; 
wire A_write;
wire [7:0] B; 
wire B_write;
wire [7:0] start; 
wire [15:0] Result;
wire done;
wire [7:0] ram_giris;

block_ram_1 blockram (
  .clka(clk), // input clka
  .wea(1'b0), // input [0 : 0] wea
  .addra(port_id[6:0]), // input [6 : 0] addra
 // .dina(dina), // input [7 : 0] dina
  .douta(ram_giris) // output [7 : 0] douta
);

kcpsm3 picoblaze (
    .address(address), 
    .instruction(instruction), 
    .port_id(port_id), 
    .write_strobe(write_strobe), 
    .out_port(out_port), 
    .read_strobe(read_strobe), 
    .in_port(in_port), 
    .interrupt(1'b0), 
    .interrupt_ack(interrupt_ack), 
    .reset(reset), 
    .clk(clk)
    );
	 
proje prog_rom (
    .address(address), 
    .instruction(instruction), 
    .clk(clk)
    );
	 
booth_top multiplier(
    .A(A), 
    .Awrite(A_write), 
    .B(B), 
    .Bwrite(B_write), 
    .start(start[0]), 
    .clk(clk), 
    .done(done), 
    .Result(Result)
    );

DEMUX demux1 (
    .in(out_port), 
    .port_id(port_id), 
    .cikis_A(A), 
    .cikis_B(B), 
    .cikis_start(start)
    );
	 
DEMUX_strobe demux_strobe (
    .in(write_strobe), 
    .port_id(port_id), 
    .cikis_A_write(A_write), 
    .cikis_B_write(B_write)
    );
	 
MUX mux1 (
    .ram_giris(ram_giris), //?
    .result_msb_giris(Result[15:8]), 
    .result_lsb_giris(Result[7:0]), 
    .done_giris({7'd0,done}), 
    .port_id(port_id), 
    .out(in_port)
    );
	 
endmodule

module DEMUX (
	input [7:0] in,
	input [7:0] port_id,
	output reg [7:0] cikis_A,
	output reg [7:0] cikis_B,
	output reg [7:0] cikis_start
);
   always@*
	begin
		case(port_id)
			8'h80: begin
						cikis_A=in;
						cikis_B=0;
						cikis_start=0;
					 end
			8'h81: begin
						cikis_A=0;
						cikis_B=in;
						cikis_start=0;
					 end
			8'h82: begin
						cikis_A=0;
						cikis_B=0;
						cikis_start=in;
					 end
			default: begin
						cikis_A=0;
						cikis_B=0;
						cikis_start=0;
					 end
		  endcase
	end
endmodule

module DEMUX_strobe (
	input in,
	input [7:0] port_id,
	output reg cikis_A_write,
	output reg cikis_B_write
);
   always@*
	begin
		case(port_id)
			8'h80: begin
						cikis_A_write=in;
						cikis_B_write=0;
						
					 end
			8'h81: begin
						cikis_A_write=0;
						cikis_B_write=in;
						
					 end
			default: begin
						cikis_A_write=0;
						cikis_B_write=0;
						
					 end
		   endcase
	end
endmodule

module MUX (
	input [7:0] ram_giris,
	input [7:0] result_msb_giris,
	input [7:0] result_lsb_giris,
	input [7:0] done_giris,
	input [7:0] port_id,
	output reg [7:0] out
);
	always@*
	begin
		case(port_id)
			8'h80: out=result_msb_giris;
			8'h81: out=result_lsb_giris;
			8'h82: out=done_giris;
			default: out=ram_giris;
		endcase
	end
	

endmodule