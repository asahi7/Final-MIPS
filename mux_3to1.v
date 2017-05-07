module mux_3to1(in0, in1, in2, sel, out);
	parameter integer N = 32;

	input [N-1:0] in0, in1, in2;
	input [1:0] sel;
	output reg [N-1:0] out;


	always@ (sel or in0 or in1 or in2) begin
		case (sel)
			// 0 : out <= in0;
			2'b01 : out <= in1;
2'b10 : out <= in2;
			default : out <= in0;
		endcase
	end

endmodule

