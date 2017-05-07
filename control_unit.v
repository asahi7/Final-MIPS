module control_unit(opcode, Jump, IF_Flush, EX, MEM, WB);
	input [5:0] opcode;
	output reg Jump, IF_Flush;
	output reg [3:0] EX;
	output reg [2:0] MEM;
	output reg [1:0] WB;

	// ALU op
	// 00 : lw, sw, addi(add)
	// 01 : beq, subi(sub)
	// 10 : R-Type
	// 11 : (add)
	always@ (opcode) begin
		if(opcode == 6'b000000) begin  // R-Type
			Jump <= 1'b0;
			EX <= 4'b1100;
			MEM <= 3'b000;
			WB <= 2'b10;
			IF_Flush <= 1'b0;
		end else if(opcode == 6'b100011) begin  // lw
			Jump <= 1'b0;
			IF_Flush <= 1'b0;
			EX <= 4'b0001;
			MEM <= 3'b010;
			WB <= 2'b11;
		end else if(opcode == 6'b101011) begin  // sw
			/*
			EX[2] = 1'b0;
			EX[1] = 1'b0;
			EX[0] = 1'b1;
			*/
			Jump <= 1'b0;
			EX <= 4'bx001;
			IF_Flush <= 1'b0;
			MEM <= 3'b001;
			WB <= 2'b0x;
		end else if(opcode == 6'b000100) begin  // beq
			Jump <= 1'b0;
			EX <= 4'bx010;
			MEM <= 3'b100;
			IF_Flush <= 1'b0;
			WB <= 2'b0x;
		end else if(opcode == 6'b001000) begin  // addi
			Jump <= 1'b0;
			EX <= 4'b0001;
			MEM <= 3'b000;
			IF_Flush <= 1'b0;
			WB <= 2'b10;
		end else if(opcode == 6'b000010) begin  // jump
			Jump <= 1'b1;
			EX <= 4'bx;
			MEM <= 3'bx;
			WB <= 2'bx;
			IF_Flush <= 1'b1;
		end
	end
endmodule
