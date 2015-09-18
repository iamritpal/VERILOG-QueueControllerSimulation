/*
	Student Name - Amritpal Singh, Rezaur Rahman
	File Creation Date - 05/04/2015
	File name - chip_top.v
	Class - CSCI 660 Intro to VLSI, Final project, NYIT
	Last Updated - 05/02/2015
*/
module chip_top;

wire ser_in;
wire ser_clk;
wire reset_n;
wire ser_out;
wire clk_div_4;

tb_gen U1 (
         .ser_in (ser_in),
         .ser_clk (ser_clk), 
         .reset_n (reset_n)
         );

chip U2 (
	     .ser_in (ser_in),
         .ser_clk (ser_clk), 
         .reset_n (reset_n),
		 .ser_out (ser_out),
		 .clk_div_4 (clk_div_4)
	);

endmodule