module four_segments (segments, p1, clk, dp);
	output reg [0:6] segments;
	output reg [0:3] p1;
	output reg dp;
	wire divided_clk, digit_clk;
	reg dp_clk = 0;
	input wire clk;
	reg [7:0] minutes, seconds;
	wire [3:0] minutes_ones, minutes_tens, seconds_ones, seconds_tens;
	integer digit = 0;
	
	clock_divider DUT(.clk(clk), .divided_clk(divided_clk), .digit_clk(digit_clk));
	binary_to_bcd DUT_minute(.clk(clk), .eight_bit_value(minutes), .ones(minutes_ones), .tens(minutes_tens), .hundreds());
	binary_to_bcd DUT_second(.clk(clk), .eight_bit_value(seconds), .ones(seconds_ones), .tens(seconds_tens), .hundreds());
	
	initial
		begin
			seconds = 8'b00000000;
			minutes = 8'b00000000;
			p1 = 4'b1110;
		end
		
	always @(posedge digit_clk)
		begin
			if (p1 != 4'b0111)
				p1 = (p1 << 1) | 4'b0001;
			else
				p1 = 4'b1110;
			case (p1)
				4'b1110 : 
					begin 
						digit = seconds_ones[3:0];
						dp = 1;
					end
				4'b1101 : 
					begin
						digit = seconds_tens[3:0];
						dp = 1;
					end
				4'b1011 : 
					begin 
						digit = minutes_ones[3:0];
						dp = 0;
					end
				4'b0111 : 
					begin
						digit = minutes_tens[3:0];
						dp = 1;
					end
			endcase
		end

	always @(posedge divided_clk)
		begin
			if(seconds <= 58)
				seconds = seconds + 1;
			else
				begin
					seconds = 0;
					if(minutes != 59)
						minutes = minutes + 1;
					else
						minutes = 0;
				end
		end
			
	always @(digit)
		case (digit)
			0 : segments = 7'b0000001;
			1 : segments = 7'b1001111;
			2 : segments = 7'b0010010;
			3 : segments = 7'b0000110;
			4 : segments = 7'b1001100;
			5 : segments = 7'b0100100;
			6 : segments = 7'b0100000;
			7 : segments = 7'b0001111;
			8 : segments = 7'b0000000;
			9 : segments = 7'b0000100;
		endcase
endmodule
