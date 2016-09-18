//
// ============================================================
// Laboratory: 	Lab 1 - Part 1 - Digital Logic
// Description:	Switches, Lights and Multiplexers
// By:				K. walsh
// Date:				August 20, 2016
//

// Top Level Module
module sw_leds (
	input [9:0] SW,
	output [9:0] LEDR);
	
	assign LEDR = SW;

endmodule