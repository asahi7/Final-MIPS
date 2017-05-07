module alu_control_unit(ins, ALUOp, ALUctrl);
	input [5:0] ins;
	input [1:0] ALUOp;
	output reg [3:0] ALUctrl;

	always@ (ins or ALUOp) begin
           // TODO
		   if(ALUOp == 2'b00) begin
		       ALUctrl = 4'b0010;
		   end else if(ALUOp == 2'b01) begin
		       ALUctrl = 4'b0110;
		   end else if(ALUOp == 2'b10) begin
		       if(ins == 6'b100000) begin
			       ALUctrl = 4'b0010;
               end else if(ins == 6'b100010) begin
			       ALUctrl = 4'b0110;
			   end else if(ins == 6'b100100) begin
			       ALUctrl = 4'b0000;
			   end else if(ins == 6'b100101) begin
			   	   ALUctrl = 4'b0001;
			   end else if(ins == 6'b101010) begin
			   	   ALUctrl = 4'b0111;
			   end else if(ins == 6'b100110) begin
				   ALUctrl = 4'b1100;
			   end
		   end
	end
endmodule
