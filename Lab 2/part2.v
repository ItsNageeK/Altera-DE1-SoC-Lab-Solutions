//
// ============================================================
// Laboratory: 	Lab 2 - Part 2 - Digital Logic
// Description:	Using 2x 7-Seg displays, output 1x 4-bit number 
//						combination from 4x switches.
// By:				K. Walsh
// Date:				August 27, 2016
//

// ============================================================
// Top Level Module
module bcd_4bit_2hex (SW, LEDR, HEX0, HEX1);
	input [3:0] SW;
	output [3:0] LEDR;
	output [6:0] HEX0, HEX1;
	
	assign LEDR = SW; //activate LED when switch is high '1'
	
	wire [3:0] V, A, h0;
	wire Z;
	assign V = SW[3:0]; //4'bxxxx to HEX0
	
	// Instantiate Display/Comparator/CircuitA/MUX Modules
	cmp_0_9 c0 (V, Z);
	crkt_A a0 (V, A);
	mux_4bit m0 (V, A, Z, h0);
	Display_0_9 d0 (h0, HEX0);
	Display_0_9 d1 (Z, HEX1);
	
	
endmodule
//
//
//
// Comparator Module
module cmp_0_9 (cmp_in, cmp_out);
	input [3:0] cmp_in;
	output cmp_out;

	assign cmp_out = (cmp_in > 4'b1001) ? 1'b1 : 1'b0; 
	
endmodule
//
//
//
// Circuit 'A' Module
module crkt_A (crkt_in, crkt_out);
	input [3:0] crkt_in;
	output reg [3:0] crkt_out;
	
	always @ (crkt_in)
	begin
	case (crkt_in)
	4'b1010: crkt_out = 4'b0000;
	4'b1011: crkt_out = 4'b0001;
	4'b1100: crkt_out = 4'b0010;
	4'b1101: crkt_out = 4'b0011;
	4'b1110: crkt_out = 4'b0100;
	4'b1111: crkt_out = 4'b0101;
	default: crkt_out = 4'bxxxx;
	endcase
	end
endmodule
//
//
//
// Multiplexer Module
module mux_4bit (m0, m1, sel, m_out);
	input [3:0] m0, m1;
	input sel;
	output [3:0] m_out;

	assign m_out = (sel == 1'b1) ? m1 : m0; 
	
endmodule
//
//
//
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
