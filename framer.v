/*
	Student Name - Amritpal Singh, Rezaur Rahman
	File Creation Date - 05/01/2015
	File name - framer.v
	Class - CSCI 660 Intro to VLSI, Final project, NYIT
	Last Updated - 05/02/2015
*/

module framer (ser_in, ser_clk, reset_n, clk_div_4, clk_div_8, par_out, decode_AB);

input ser_in;
input ser_clk;
input reset_n;
output clk_div_4;
output clk_div_8;
output [7:0] par_out;
output decode_AB;

reg clk_div_4;
reg clk_div_8;
reg [7:0] par_out;
reg decode_AB;
reg [3:0] count_4bit;
parameter N = 8;

parameter AB = 171;		// hex AB in decimal is 171

reg [7:0] shiftreg_8;

integer bit_counter = 0;

initial
begin
	clk_div_4 = 1'b0;
	clk_div_8 = 1'b0;
	decode_AB = 1'b0;
    par_out = 8'b00000000;
end

// shiftreg_8 counter
always @ (posedge ser_clk or negedge reset_n)
begin : SHIFTIN
    if (!reset_n) begin
        shiftreg_8 <= 0;
    end
    else begin
		shiftreg_8 <= { shiftreg_8[6:0], ser_in };
	end
end // end of block SHIFTIN


// decode AB in the incoming data byte 
always @ (posedge ser_clk or negedge reset_n)
begin : DECODEAB
    if (!reset_n) begin
        decode_AB <= 0;
    end
    else begin
	    if (shiftreg_8 == AB) begin
	        decode_AB <= 1'b1;
	    end
	    else begin
	    	if (bit_counter == 7) begin
	    		decode_AB <= 1'b0;	    		
	    	end
		end
	end
end // end of block DECODEAB

// divide by 8 clock output
always @ (posedge ser_clk or negedge reset_n)
begin : DIVBYEIGHTCLK
    if (!reset_n) begin
        count_4bit <= 0;
    end
    else begin
		count_4bit <= count_4bit + 1;
		if (count_4bit == 15) begin
			count_4bit <= 0;
		end
		clk_div_4 <= count_4bit[1];
		clk_div_8 <= count_4bit[2];
	end
end // end of block DIVBYEIGHTCLK


// set bit counter
always @ (posedge ser_clk or negedge reset_n)
begin : SETBITCOUNTER
    if (!reset_n) begin
        bit_counter <= 0;
    end
    else begin
    	bit_counter <= bit_counter + 1;
		if (bit_counter == N-1) begin
			bit_counter <= 0;
		end
	end
end // end of block SETBITCOUNTER

// set par_out
always @ (posedge ser_clk or negedge reset_n)
begin : SETPAROUT
    if (!reset_n) begin
        par_out <= 0;
    end
    else begin
		if (bit_counter == 0) begin
			par_out <= shiftreg_8;
		end
	end
end // end of block SETPAROUT

endmodule

/*

Revision History:

05/02/2015 v1.06 AS     1. Added SETBITCOUNTER and SETPAROUT blocks for setting the par_out byte output per 8 serial bits.

*/