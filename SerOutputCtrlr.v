/*
	Student Name - Amritpal Singh, Rezaur Rahman
	File Creation Date - 05/07/2015
	File name - SerOutputCtrlr
	Class - CSCI 660 Intro to VLSI, Final project, NYIT
	Last Updated - 05/07/2015
*/

module SerOutputCtrlr (clk_div_4, reset_n, data_out, valid_data_out, ser_out);

input clk_div_4;
input reset_n;
input [63:0] data_out;
input valid_data_out;
output ser_out;

reg [63:0] shiftreg_dout;
reg prev_valid_data_out;

reg ser_out;

initial
begin
	ser_out = 0;
	prev_valid_data_out = 0;
end


always @ (posedge clk_div_4 or negedge reset_n)
begin : SETDOUTPUT
	if (!reset_n) begin
		ser_out <= 0;
		shiftreg_dout <= 0;
		prev_valid_data_out <= 0;
	end
	else begin
		// set shift register value to data to be outputed 
		if ((prev_valid_data_out == 0) && (valid_data_out != 0)) begin
			shiftreg_dout = data_out;
		end
		prev_valid_data_out = valid_data_out;
		ser_out = shiftreg_dout[63];
		shiftreg_dout <= { shiftreg_dout[62:0], 1'b0 };
	end
end

endmodule
