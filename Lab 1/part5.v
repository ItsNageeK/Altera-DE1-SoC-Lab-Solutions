// ============================================================
// Laboratory: 	Lab 1 - Part 5 - Digital Logic
// Description:	3x 7-Seg Displays; multiplex to 3x displays 
//						to output different combinations.
// By:				K. Walsh
// Date:				August 23, 2016
//
// SW  9  8    Displayed characters
//     0  0    dE1 
//     0  1    E1d
//     1  0    1dE

// Top Level Module
module display3 (SW, LEDR, HEX0, HEX1, HEX2);
	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2;
	// SW		= Switches, [9:8] selects for HEX and [5:0] toggle displays3 
	
	assign LEDR = SW;
	
	wire [1:0] Ch_Sel, Ch1, Ch2, Ch3;
	wire [1:0] H2_Ch, H1_Ch, H0_Ch;
	assign Ch_Sel = SW[9:8];
	assign Ch1 = SW[5:4];	//'U' wire
	assign Ch2 = SW[3:2];	//'V' wire
	assign Ch3 = SW[1:0];	//'W' wire

	// 3x Instantiations of Mux/Display Modules
	mux2_1 m0 (Ch_Sel,Ch3,Ch1,Ch2,H0_Ch);
	mux2_1 m1 (Ch_Sel,Ch2,Ch3,Ch1,H1_Ch);
	mux2_1 m2 (Ch_Sel,Ch1,Ch2,Ch3,H2_Ch);
	segment7 s0 (H0_Ch, HEX0);
	segment7 s1 (H1_Ch, HEX1);
	segment7 s2 (H2_Ch, HEX2);
	// Note, important as to how you mix Ch1, Ch2, Ch3 in each MUX
	// instantiation.  Keep in mind how this will look when outputing
	// to the HEX display, orientation matters!
	
endmodule



// Mux Module
// SW  9  8    Displayed characters
//     0  0    d  'U'
//     0  1    E  'V'
//     1  0    1  'W'
//     1  1    - - -	
//
module mux2_1 (S, U, V, W, M);
	input [1:0] S, U, V, W;
	output [1:0] M;

	assign M[0] = (~S[1] & ~S[0] & U[0]) | (~S[1] & S[0] & V[0]) | (S[1] & ~S[0] & W[0]) | (S[1] & S[0] & W[0]); 
	assign M[1] = (~S[1] & ~S[0] & U[1]) | (~S[1] & S[0] & V[1]) | (S[1] & ~S[0] & W[1]) | (S[1] & S[0] & W[1]);

endmodule


// Display Module
// SW  9  8    Displayed characters
//     0  0    dE1 
//     0  1    E1d
//     1  0    1dE
module segment7 (C, Display);
	input [1:0] C;
	output [6:0] Display;
	
	assign Display[0] = (~C[1] & ~C[0]) | (C[1] & ~C[0]) | (C[1] & C[0]);
	assign Display[1] = (~C[1] & C[0]) | (C[1] & C[0]);
	assign Display[2] = (~C[1] & C[0]) | (C[1] & C[0]);
	assign Display[3] = (C[1] & ~C[0]) | (C[1] & C[0]);
	assign Display[4] = (C[1] & ~C[0]) | (C[1] & C[0]);
	assign Display[5] = (~C[1] & ~C[0]) | (C[1] & ~C[0]) | (C[1] & C[0]);
	assign Display[6] = (C[1] & ~C[0]) | (C[1] & C[0]);
	//Display[0] = (~c1&~c0)|(c1&~c0)|(c1&c0)
	//Display[1] = (~c1&c0)|(c1&c0)
	//Display[2] = (~c1&c0)|(c1&c0)
	//Display[3] = (c1&~c0)|(c1&c0)
	//Display[4] = (c1&~c0)|(c1&c0)
	//Display[5] = (~c1&~c0)|(c1&~c0)|(c1&c0)
	//Display[6] = (c1&~c0)|(c1&c0)

endmodule

