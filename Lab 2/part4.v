//
// ============================================================
// Laboratory: 	Lab 2 - Part 4 - Digital Logic
// Description:	Implementation of BCD decimal inputs to be summed 
//						and then output onto HEX 7-segment displays.
// By:				K. Walsh
// Date:				September 14, 2016
//

// ============================================================
// Top Level Module
module bcd_adder (SW, LEDR, HEX0, HEX1, HEX3, HEX5);
	input [8:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX3, HEX5;
	
	wire [3:0] x, y, s, r, t, u, v;
	wire [2:0] c, z;
	wire ci, co, w;
	assign x = SW[7:4];
	assign y = SW[3:0];
	assign ci = SW[8];
	assign LEDR[8:0] = SW[8:0];	//light up LEDs when SWs are achtive
	assign LEDR[9] = (z[0] | z[1]);	//light up LEDR9 when X or Y comparator
												//signale are '1', i.e. >9
	
	// Instantiate Full Adder Module
	full_adder f0 (.x(x[0]),.y(y[0]),.ci(ci),.s(s[0]),.co(c[0]));
	full_adder f1 (.x(x[1]),.y(y[1]),.ci(c[0]),.s(s[1]),.co(c[1]));
	full_adder f2 (.x(x[2]),.y(y[2]),.ci(c[1]),.s(s[2]),.co(c[2]));
	full_adder f3 (.x(x[3]),.y(y[3]),.ci(c[2]),.s(s[3]),.co(co));
	// Note, in order to use the same wire/net names as the instantiated
	// full adder module ports, we must used .named port style connections.  
	// Also, ensure that the correct data widths (i.e. 1-bit) are being utilized.
	
	
	// Instantiate cmp_0_9 Module
	cmp_0_9 cmp0 (.cmp_in(x),.cmp_out(z[0]));
	cmp_0_9 cmp1 (.cmp_in(y),.cmp_out(z[1]));
	cmp_0_9 cmp2 (.cmp_in(s),.cmp_out(z[2]));
	
	
	// Instantiate crkt_A Module
	crkt_A ck0 (.crkt_in(s),.crkt_out(r));
	
	
	// Instantiate crkt_B Module
	crkt_B ck1 (.crkt_i(t),.crkt_o(u));
	
	
	// Instantiate MUX Module
	mux_4bit mx0 (.m0(s),.m1(r),.sel(z[2]),.m_out(t));
	mux_4bit mx1 (.m0(t),.m1(u),.sel(co),.m_out(v));
	mux_4bit mx2 (.m0(z[2]),.m1(co),.sel(co),.m_out(w));
	
	
	// Instantiate Display Module
	Display_0_9 d0 (.ch(v),.seg(HEX0));
	Display_0_9 d1 (.ch(w),.seg(HEX1));
	Display_0_9 d2 (.ch(x),.seg(HEX5));
	Display_0_9 d3 (.ch(y),.seg(HEX3));
	
	
endmodule
//
//
//
// Full Adder Module
module full_adder (x, y, ci, s, co);
	input x, y, ci;
	output s, co;
	
	assign s = ((x ^ y) ^ ci);
	assign co = ((x ^ y) == 1'b1) ? ci : y;

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
	4'b1010: crkt_out = 4'b0000;  //10 in, 0 out
	4'b1011: crkt_out = 4'b0001;	//11 in, 1 out
	4'b1100: crkt_out = 4'b0010;	//12 in, 2 out
	4'b1101: crkt_out = 4'b0011;	//13 in, 3 out
	4'b1110: crkt_out = 4'b0100;	//14 in, 4 out
	4'b1111: crkt_out = 4'b0101;	//15 in, 5 out
	default: crkt_out = 4'bxxxx;	
	endcase
	end
endmodule
//
//
//
// Circuit 'B' Module
module crkt_B (crkt_i, crkt_o);
	input [3:0] crkt_i;
	output reg [3:0] crkt_o;
	
	always @ (crkt_i)
	begin
	case (crkt_i)
	4'b0000: crkt_o = 4'b0110; //0 in, 6 out
	4'b0001: crkt_o = 4'b0111;	//1 in, 7 out
	4'b0010: crkt_o = 4'b1000;	//2 in, 8 out
	4'b0011: crkt_o = 4'b1001;	//3 in, 9 out
	default: crkt_o = 4'bxxxx;	
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
module Display_0_9 (ch, seg);
	input [3:0] ch;
	output [6:0] seg;
	
	assign seg[0] = (~ch[3]&~ch[2]&~ch[1]&ch[0])|(~ch[3]&ch[2]&~ch[1]&~ch[0]);	//seg off, digits(1,4)
	//0001 OR 0100
	assign seg[1] = (~ch[3]&ch[2]&~ch[1]&ch[0])|(~ch[3]&ch[2]&ch[1]&~ch[0]);	//seg off, digits(5,6)
	//0101 OR 0110
	assign seg[2] = (~ch[3]&~ch[2]&ch[1]&~ch[0]);	//seg off, digits(2)
	//0010
	assign seg[3] = (~ch[3]&~ch[2]&~ch[1]&ch[0])|(~ch[3]&ch[2]&~ch[1]&~ch[0])|(~ch[3]&ch[2]&ch[1]&ch[0])|(ch[3]&~ch[2]&~ch[1]&ch[0]);	//seg off, digits(1,4,7,9)
	//0001 OR 0100 OR 0111 OR 1001
	assign seg[4] = (~ch[3]&~ch[2]&~ch[1]&ch[0])|(~ch[3]&~ch[2]&ch[1]&ch[0])|(~ch[3]&ch[2]&~ch[1]&~ch[0])|(~ch[3]&ch[2]&~ch[1]&ch[0])|(~ch[3]&ch[2]&ch[1]&ch[0])|(ch[3]&~ch[2]&~ch[1]&ch[0]);	//seg off, digits(1,3,4,5,7,9)
	//0001 OR 0011 OR 0100 OR 0101 OR 0111 OR 1001 
	assign seg[5] = (~ch[3]&~ch[2]&~ch[1]&ch[0])|(~ch[3]&~ch[2]&ch[1]&~ch[0])|(~ch[3]&~ch[2]&ch[1]&ch[0])|(~ch[3]&ch[2]&ch[1]&ch[0]);	//seg off, digits(1,2,3,7)
	//0001 OR 0010 OR 0011 OR 0111 
	assign seg[6] = (~ch[3]&~ch[2]&~ch[1]&~ch[0])|(~ch[3]&~ch[2]&~ch[1]&ch[0])|(~ch[3]&ch[2]&ch[1]&ch[0]);	//seg off, digits(0,1,7)
	//0000 OR 0001 OR 0111

endmodule

