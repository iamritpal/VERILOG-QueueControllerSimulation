/*
	Student Name - Amritpal Singh, Rezaur Rahman
	File Creation Date - 05/01/2015
	File name - chip.v
	Class - CSCI 660 Intro to VLSI, Final project, NYIT
	Last Updated - 05/02/2015
*/

module chip (ser_clk, 
             ser_in, 
             reset_n, 
             ser_out,
			 clk_div_4);

input  ser_in; 
input  ser_clk; 
input  reset_n;
output ser_out;
output clk_div_4;
wire ser_in;
wire ser_clk;
wire reset_n;
wire clk_div_4;
wire clk_div_8;
wire [7:0] par_out;
wire decode_AB;
wire [63:0] data_out;
wire valid_data_out;
wire ser_out;
framer UU2 (
         .ser_in (ser_in),
         .ser_clk (ser_clk), 
         .reset_n (reset_n),
         .clk_div_4 (clk_div_4),
         .clk_div_8 (clk_div_8),
         .par_out (par_out),
         .decode_AB (decode_AB)
         );

QueueController UU3 (
         .reset_n (reset_n),
         .clk_div_8 (clk_div_8),
         .par_out (par_out),
         .decode_AB (decode_AB),
         .data_out (data_out), 
         .valid_data_out (valid_data_out)
         );

SerOutputCtrlr UU4 (
         .reset_n (reset_n),
         .clk_div_4 (clk_div_4),
         .data_out (data_out), 
         .valid_data_out (valid_data_out),
         .ser_out (ser_out)
        );

endmodule 
