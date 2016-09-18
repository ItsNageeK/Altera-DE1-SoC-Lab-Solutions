//
// ============================================================
// Laboratory: 	Lab 2 - Part 5 - Digital Logic
// Description:	Implementation of BCD adder similar to part 4 
//						but instead of as robust of a design, utilize
//						more of the Verilog compiler to do the work.
//						The psuedo-code below is what we'll mirror.
//
//						To = A+B+c0
//						if (T0 > 9) then
//							Z0 = 10;
//							c1 = 1;
//						else
//							Z0 = 0;
//							c1 = 0;
//						end if
//						S0 = T0 - Z0
//						S1 = c1
//
//
// By:				K. Walsh
// Date:				September 17, 2016
//

// ============================================================
//
//
//
// Top Level Module
module bcd_add (SW, LEDR, HEX0, HEX1, HEX3, HEX5);
	input [8:0] SW;
	output [8:0] LEDR;
	output [6:0] HEX0, HEX1, HEX3, HEX5;
	
	wire [3:0] a,b,s0,s1;
	wire [4:0] t0;
	wire ci;
	reg [4:0] z0;
	reg c1;
	
	assign LEDR = SW;
	assign a = SW[7:4];
	assign b = SW[3:0];
	assign ci = SW[8];
	assign t0 = a + b + ci;
	
	always @ (t0)
	begin
	if (t0 > 9)
		begin
			z0 = 5'd10;
			c1 = 1'd1;
		end
	else
		begin
			z0 = 5'd0;
			c1 = 1'd0;
		end
	end
	
	assign s0 = t0 - z0;
	assign s1 = c1;
	//
	//
	// Instantiate Display Module
	disp_0_9 d0 (.ch(s0),.seg(HEX0));	//HEX0
	disp_0_9 d1 (.ch(s1),.seg(HEX1));	//HEX1
	disp_0_9 d2 (.ch(b),.seg(HEX3));		//HEX3
	disp_0_9 d3 (.ch(a),.seg(HEX5));		//HEX5
	
endmodule
//
//
//
// Display Module (digits 0-9)
module disp_0_9 (ch, seg);
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


