/*
	Student Name - Amritpal Singh, Rezaur Rahman
	File Creation Date - 04/29/2015
	Class - CSCI 660 Intro to VLSI, Final project, NYIT
	Last Updated - 04/29/2015
*/
module tb_gen (ser_in, ser_clk, reset_n);
output ser_in;
output ser_clk;
output reset_n;

reg ser_in;
reg ser_clk;
reg reset_n;

integer bit_count=0;
integer byte_count=0;
integer frame_count=0;
						//	SIZE (bytes)	Description
reg [7:0] Preamble;     //       1          Preamble byte 
reg [7:0] SFD_byte;     //       1          SFD Byte  
reg [7:0] S_address;	// 		 1			Source Address	
reg [7:0] D_address;	// 		 1			Destination Address
reg [7:0] Serv_type;	//		 1			Service Type: Range is decimal (0-9), where 9 is highest priority
reg [15:0] data;		//		 2			Data attached to each packet is 2 bytes						
//reg [7:0] check_sum;	//		 7			Check sum (Longitudinal redundancy check)
						// Total = 5bytes per packet
//reg priority_level;

initial
begin
	reset_n = 1'b0;
	ser_clk = 1'b0;
    // initial clearing of all signals
    Preamble = 8'hAB;
    SFD_byte = 8'h28;
    S_address = 8'b00000000;
	D_address = 8'b00000000;
    Serv_type = 8'b00000000;
    data = 16'b0000000000000000;
    #26 reset_n = 1'b1;
end

// Serial clock gen
always
begin : clock_gen	// begin clock generation
	#5 ser_clk = ~ser_clk;
end	// end clock_gen

// Bit counter
always @ (posedge ser_clk or negedge reset_n)
begin : BITCOUNTER
    if (!reset_n) begin
        bit_count <= 0;
    end
    else begin
		if (bit_count == 7) begin
			bit_count <= 0;
		end
		else begin
			bit_count <= bit_count + 1;
		end
	end
end // end of block BITCOUNTER

// Byte counter
always @ (posedge ser_clk or negedge reset_n)
begin : BYTECOUNTER
    if (!reset_n) begin
        byte_count <= 0;
    end
    else begin
		if (bit_count == 7) begin
			byte_count <= byte_count+1;
			if (byte_count == 15) begin
				byte_count <= 0;
                frame_count <= frame_count+1;
			end
		end
	end
end // end of block BYTECOUNTER

// 4 different priority rates
always @ (ser_clk or byte_count)
begin : UPDATEPKTCONTENT
    if (byte_count == 1) begin
        case (frame_count % 4)
            0       :   begin    
                            S_address = 8'b10101010;
                            D_address = 8'b10101010;
                            Serv_type = 8'b00000000;    // <--- Priority level 0
                            data = 16'b0000000000000000;
                        end

            1       :   begin    
                            S_address = 8'b10101010;
                            D_address = 8'b10101010;
                            Serv_type = 8'b00000001;    // <--- Priority level 1
                            data = 16'b0000000000000000;
                        end

            2       :   begin    
                            S_address = 8'b10101010;
                            D_address = 8'b10101010;
                            Serv_type = 8'b00000010;    // <--- Priority level 2
                            data = 16'b0000000000000000;
                        end

            3       :   begin    
                            S_address = 8'b10101010;
                            D_address = 8'b10101010;
                            Serv_type = 8'b00000011;    // <--- Priority level 3
                            data = 16'b0000000000000001;
                        end
        endcase
    end
end // end of block UPDATEPKTCONTENT

// Set the value of ser_in output either ON or OFF
always @ (bit_count or reset_n)
begin : SER_IN_GEN
	if (!reset_n) begin
		ser_in <= 1'b0;
	end
	else begin
		case (byte_count)
            0        :      ser_in <= Preamble[7 - bit_count];
            1        :      ser_in <= SFD_byte[7 - bit_count];
			2		 :		ser_in <= S_address[7 - bit_count];
			3		 :		ser_in <= D_address[7 - bit_count];
			4		 :		ser_in <= Serv_type[7 - bit_count];
			5		 :		ser_in <= data[15 - bit_count];
			6		 :		ser_in <= data[7 - bit_count];
			default  : 		ser_in <= 1'b0;
		endcase
	end
end	// end of block SER_IN_GEN

endmodule // end of tb_gen module

/* Revision History

04/29/2015 v1.02 AS		1. Created tb_gen.v file for adding necessary code for generating ser_in, ser_clk and reset_n ports.
						2. Added bit counter and byte counter and simulation of clock output.
						3. Added setting of ser_in value using case statement. 
                        4. Added setting contents of the frame bytes for different priority rates.
05/02/2015 v1.06 AS     1. Added Preamble and SFD Byte to each packet
*/
		