module top_MEM(clk, rst, 
                WB, MEM, zero, result, write_data, write_register,
				WB_out, read_data, branch,
				result_out, write_register_out); // TODO: add the outputs and delete unnecessary params
    // INPUT FOR IDEX BEGIN
    input clk, rst;
	input [1:0] WB;
	input [2:0] MEM;
	input [4:0] write_register;
	input [31:0] result, write_data;
	input zero;
    // INPUT FOR IDEX END
	// OUTPUT FOR IDEX BEGIN
	output reg [31:0] result_out, read_data;
	output reg [4:0] write_register_out;
	output reg [1:0] WB_out;
	output reg branch;
	// OUTPUT FOR IDEX END
	wire [31:0] read_data_res;
	
	data_memory MEMORY (
		.rst(rst),
		.addr(result), // TODO: what if the result is not the address?
					   // or if the result is larger than the size of memory array?
		.MemWrite(MEM & 3'b001),
		.MemRead((MEM & 3'b010) >> 1),
		.writedata(write_data),
		.readdata(read_data_res)
	);
	
	always @(posedge clk or negedge rst) begin // TODO: consider the rst
		WB_out = WB;
		branch = ((MEM & 3'b100) >> 2) & zero; // TODO: is this correct MEM for branching?
		read_data = read_data_res;
		write_register_out = write_register;
		result_out = result;
		if(! rst) begin
			WB_out = 2'b0;
			branch = 1'b0;
			read_data = 32'b0; write_register_out = 5'b0;
			result_out = 32'b0;
		end
	end
	
endmodule