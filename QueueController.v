/*
	Student Name - Amritpal Singh, Rezaur Rahman
	File Creation Date - 05/01/2015
	Class - CSCI 660 Intro to VLSI, Final project, NYIT
	Last Updated - 05/08/2015
*/

module QueueController (clk_div_8, reset_n, par_out, decode_AB, data_out, valid_data_out);

input clk_div_8;
input reset_n;
input [7:0] par_out;
input decode_AB;
output [63:0] data_out;
output valid_data_out;

reg new_valid_pkt;
reg write_finished;
reg valid_data_out;
reg [63:0] data;
reg [63:0] data_out;
reg [63:0] shift_reg64;
reg [7:0] service_type;

integer byte_count = 0;
integer cycle_count = 0;
integer out_cycle_count = 0;
integer pkts_dequed = 0;
integer service_typ_sel = 0;
// Circular FIFO Buffer

parameter max_size = 7;
parameter NMB_QUES = 4;

integer pkts_serving_rate [3:0];

reg wren [NMB_QUES-1:0];
reg que_is_full [NMB_QUES-1:0];          // 4 1bit signals to, set when a queue is full
reg [8:0] que_get_ix [NMB_QUES-1:0];     // read address pointers, creates 4 put counters of 9bit each per queue
reg [8:0] que_put_ix [NMB_QUES-1:0];     // write address pointers, creates 4 get counters of 9bit each per queue
reg [3:0] nmb_pkts_que [NMB_QUES-1:0];   // count of number of items in each queue, creates 4 4bit counters for items in queue 

wire [63:0] q [NMB_QUES-1:0];

integer put_in_que_state=0;
integer get_from_que_state=0;
integer i;

// each RAM component is of total size 32k bits

dpram U21 (
         .clock (clk_div_8),
         .data (data), 
         .rdaddress (que_get_ix[0]),
         .wraddress (que_put_ix[0]),
         .wren (wren[0]),
         .q (q[0])
		 );

dpram U22 (
         .clock (clk_div_8),
         .data (data), 
         .rdaddress (que_get_ix[1]),
         .wraddress (que_put_ix[1]),
         .wren (wren[1]),
         .q (q[1])
         );

dpram U23 (
         .clock (clk_div_8),
         .data (data), 
         .rdaddress (que_get_ix[2]),
         .wraddress (que_put_ix[2]),
         .wren (wren[2]),
         .q (q[2])
         );

dpram U24 (
         .clock (clk_div_8),
         .data (data), 
         .rdaddress (que_get_ix[3]),
         .wraddress (que_put_ix[3]),
         .wren (wren[3]),
         .q (q[3])
         );

initial
begin
	data = 0;
    data_out = 0;
	shift_reg64 = 0;
    new_valid_pkt = 1'b0;
    write_finished = 1'b0;
    valid_data_out = 1'b0;
    service_type = 8'b00000000;

    for (i=0; i<NMB_QUES; i=i+1) begin
        wren[i] = 1'b0;
        que_is_full[i] = 1'b0;
        que_get_ix[i] = 9'b000000000;
        que_put_ix[i] = 9'b000000000;
        nmb_pkts_que[i] = 4'b0000;
        pkts_serving_rate[i] = i+1;
    end
end

// Byte counter
always @ (posedge clk_div_8 or negedge reset_n)
begin : BYTECOUNTER
    if (!reset_n) begin
        byte_count <= 0;
    end
    else begin
		if (decode_AB == 1) begin
			byte_count <= 0;
		end
		else begin 
			byte_count <= byte_count+1;
			if (byte_count == 15) begin
				byte_count <= 0;
			end
		end 
	end
end // end of block BYTECOUNTER

// Shift 7 bytes to data register
always @ (posedge clk_div_8 or negedge reset_n)
begin : SHIFTPARIN
    if (!reset_n) begin
        shift_reg64 <= 0;
    end
    else begin
		shift_reg64 <= { shift_reg64[55:0], par_out };
	end
end // end of block SHIFTPARIN


// Set the data input for RAM to be 8 bytes of the incoming frame
always @ (posedge clk_div_8 or negedge reset_n)
begin : SETRAMDATA
    if (!reset_n) begin
        data <= 0;
        new_valid_pkt <= 0;
    end
    else begin
        if (byte_count == 3) begin
            service_type <= par_out;
        end

	    if (byte_count == 6) begin
            new_valid_pkt <= 1;
	        data <= shift_reg64;
	    end

        if ((new_valid_pkt == 1) && (byte_count == 8)) begin
            new_valid_pkt <= 0;            
        end
	end
end // end of block SETRAMDATA


always @ (posedge clk_div_8 or negedge reset_n)
begin : SETWRITEADDRESS

end // end SETWRITEADDRESS

// put a new packet in queue
always @ (posedge clk_div_8 or negedge reset_n)
begin : PUTINQUE
    if (!reset_n) begin
        put_in_que_state = 0;
		  valid_data_out = 0;
        out_cycle_count = 0;
        data_out = 0;
        pkts_dequed = 0;
    end
    else begin
        case (put_in_que_state)
            0       :       begin                               // check if valid packet
                                if (new_valid_pkt == 1) begin
                                    put_in_que_state = 1;
                                end
                            end

            1       :       begin                               // check if que is full
                                if (que_is_full[service_type] == 1'b1) begin
                                    put_in_que_state = 15;
                                end
                                else begin
                                    wren[service_type] = 1;     // write to memory
                                    put_in_que_state = 2;
                                    cycle_count = 0;
                                end
                            end

            2       :       begin
                                if (write_finished == 1) begin      // write completed
                                    wren[service_type] = 0;
                                    write_finished = 0;
                                    put_in_que_state = 3;
                                end
                                else begin
                                    cycle_count = cycle_count + 1;
                                    if (cycle_count == 2)
                                        write_finished = 1;
                                end
                            end

            3       :       begin                       // increment que put ix
                                if (que_put_ix[service_type] == max_size-1) begin
                                    que_put_ix[service_type] = 0;
                                end
                                else begin
                                    que_put_ix[service_type] = que_put_ix[service_type] + 1;
                                end
                                nmb_pkts_que[service_type] = nmb_pkts_que[service_type] + 1;
                                if (nmb_pkts_que[service_type] == max_size-1) begin
                                    que_is_full[service_type] = 1'b1;
                                end
                                put_in_que_state <= 15;
                            end

            15      :       begin           // finish state
                                put_in_que_state = 0;
                            end

        endcase
		  
		          /*
                priority rate       deque(service) # pkts everytime service selected in RR fashion
                    0                     1
                    1                     2
                    2                     3
                    3                     4
            */

            if (nmb_pkts_que[service_typ_sel] != 0) 
            begin
					if (pkts_dequed <= pkts_serving_rate[service_typ_sel]) begin
						 data_out <= q[service_typ_sel];
						 out_cycle_count <= out_cycle_count+1;
						 valid_data_out <= 1;
						 if (out_cycle_count == 25) begin
							  out_cycle_count <= 0;
							  valid_data_out <= 0;
							  pkts_dequed <= pkts_dequed + 1;
							  if (que_get_ix[service_typ_sel] == max_size-1) begin
									que_get_ix[service_typ_sel] = 0;
							  end
							  else begin
									que_get_ix[service_typ_sel] = que_get_ix[service_typ_sel] + 1;
							  end
							  nmb_pkts_que[service_typ_sel] = nmb_pkts_que[service_typ_sel] - 1;
						 end
					 end
					 else begin          // select next service type
						   if (service_typ_sel < NMB_QUES-1) begin
							    service_typ_sel = service_typ_sel+1;                        
						   end
						   else begin
                          service_typ_sel = 0; 
						   end
                     pkts_dequed = 0;
                end
            end
            else begin          // select next service type
                if (service_typ_sel < NMB_QUES-1) begin
                    service_typ_sel = service_typ_sel+1;                        
                end
                else begin
                    service_typ_sel = 0; 
                end
                pkts_dequed = 0;
            end
		  
    end
end // put in que


endmodule

/*

Revision History:

*/