module portmapquectrlr;

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
tb_gen U1 (
         .ser_in (ser_in),
         .ser_clk (ser_clk), 
         .reset_n (reset_n)
		 );

framer U2 (
         .ser_in (ser_in),
         .ser_clk (ser_clk), 
         .reset_n (reset_n),
         .clk_div_4 (clk_div_4),
		 .clk_div_8 (clk_div_8),
		 .par_out (par_out),
		 .decode_AB (decode_AB)
		 );

QueueController U3 (
         .reset_n (reset_n),
         .clk_div_8 (clk_div_8),
		 .par_out (par_out),
		 .decode_AB (decode_AB),
		 .data_out (data_out), 
		 .valid_data_out (valid_data_out)
		 );

SerOutputCtrlr U4 (
		 .reset_n (reset_n),
         .clk_div_4 (clk_div_4),
		 .data_out (data_out), 
		 .valid_data_out (valid_data_out),
		 .ser_out (ser_out)
		);

endmodule