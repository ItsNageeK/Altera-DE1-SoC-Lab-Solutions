//
// ============================================================
// Laboratory: 	Lab 2 - Part 1 - Digital Logic
// Description:	Using 2x 7-Seg displays, control each one to 
//						output the values of 0-9 using 8x switches.  4x switches
//						control one 7-seg and 4x switchs control another.
//						The idea using BCDs, 4'bxxxx -> 1'd
// By:				K. Walsh
// Date:				August 24, 2016
//

// ============================================================
// Top Level Module
module bcd_2hex (SW, LEDR, HEX0, HEX1);
	input [7:0] SW;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1;
	
	assign LEDR = SW; //activate LED when switch is high '1'
	
	wire [3:0] Ch0, Ch1;
	assign Ch0 = SW[3:0]; //4'bxxxx to HEX0
	assign Ch1 = SW[7:4]; //4'bxxxx to HEX1
	
	// Instantiate BCD/Display Module
	Display_0_9 d0 (Ch0, HEX0);
	Display_0_9 d1 (Ch1, HEX1);
	
endmodule


// Display Module (digits 0-9)
module Display_0_9 (C, segment);
	input [3:0] C;
	output [6:0] segment;
	
	assign segment[0] = (~C[3]&~C[2]&~C[1]&C[0])|(~C[3]&C[2]&~C[1]&~C[0]);	//segment off, digits(1,4)
	//0001 OR 0100
	assign segment[1] = (~C[3]&C[2]&~C[1]&C[0])|(~C[3]&C[2]&C[1]&~C[0]);	//segment off, digits(5,6)
	//0101 OR 0110
	assign segment[2] = (~C[3]&~C[2]&C[1]&~C[0]);	//segment off, digits(2)
	//0010
	assign segment[3] = (~C[3]&~C[2]&~C[1]&C[0])|(~C[3]&C[2]&~C[1]&~C[0])|(~C[3]&C[2]&C[1]&C[0])|(C[3]&~C[2]&~C[1]&C[0]);	//segment off, digits(1,4,7,9)
	//0001 OR 0100 OR 0111 OR 1001
	assign segment[4] = (~C[3]&~C[2]&~C[1]&C[0])|(~C[3]&~C[2]&C[1]&C[0])|(~C[3]&C[2]&~C[1]&~C[0])|(~C[3]&C[2]&~C[1]&C[0])|(~C[3]&C[2]&C[1]&C[0])|(C[3]&~C[2]&~C[1]&C[0]);	//segment off, digits(1,3,4,5,7,9)
	//0001 OR 0011 OR 0100 OR 0101 OR 0111 OR 1001 
	assign segment[5] = (~C[3]&~C[2]&~C[1]&C[0])|(~C[3]&~C[2]&C[1]&~C[0])|(~C[3]&~C[2]&C[1]&C[0])|(~C[3]&C[2]&C[1]&C[0]);	//segment off, digits(1,2,3,7)
	//0001 OR 0010 OR 0011 OR 0111 
	assign segment[6] = (~C[3]&~C[2]&~C[1]&~C[0])|(~C[3]&~C[2]&~C[1]&C[0])|(~C[3]&C[2]&C[1]&C[0]);	//segment off, digits(0,1,7)
	//0000 OR 0001 OR 0111

endmodule
