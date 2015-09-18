module portmap;

wire ser_in;
wire ser_clk;
wire reset_n;
wire clk_div_8;
wire [7:0] par_out;
wire decode_AB;

tb_gen U1 (
         .ser_in (ser_in),
         .ser_clk (ser_clk), 
         .reset_n (reset_n)
		 );

framer U2 (
         .ser_in (ser_in),
         .ser_clk (ser_clk), 
         .reset_n (reset_n),
		 .clk_div_8 (clk_div_8),
		 .par_out (par_out),
		 .decode_AB (decode_AB)
		 );
		 
endmodule