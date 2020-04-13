`timescale 1ns / 1ps
module clock_divider(
    input clk,
    output reg divided_clk = 0,
	 output reg digit_clk = 0
    );

	integer counter_value = 0;
	integer counter_digit = 0;
	 	
	 always@ (posedge clk)
		begin
			if(counter_digit == 5000)
				begin
					counter_digit <= 0;
					digit_clk <= ~digit_clk;
				end
			else
				begin
					digit_clk <= digit_clk;
					counter_digit <= counter_digit + 1;
				end
		end
		
	 always@ (posedge clk)
		begin
			if(counter_value == 6000000)
				begin
					counter_value <= 0;
					divided_clk <= ~divided_clk;
				end
			else
				begin
					divided_clk <= divided_clk;
					counter_value <= counter_value + 1;
				end
		end
		
endmodule
