module top_if(clk, rst, pcsrc, baddr, pc_out, ins_out, Jump, jaddr, Flush);
	input clk, rst, pcsrc;
	input [31:0] baddr;
	output reg [31:0] pc_out, ins_out;
	input Jump;
	input Flush;
	input [31:0] jaddr;
	
//////////////////////////////////////////////////////////////////////////////////////////////
// IF stage

	wire [31:0] w_pc_im_pcaddr, w_mux_pc, w_im_ifid, w_mux_tmp;

	program_counter PC(
		.clk(clk),
		.rst(rst),
		.addr_in(w_mux_pc),
		.addr_out(w_pc_im_pcaddr)
	);

	instruction_memory IM(
		.rst(rst),
		.addr(w_pc_im_pcaddr),
		.ins(w_im_ifid)
	);

	mux_2to1 #(
		.N(32)
	) PC_MUX (
		.in0(w_pc_im_pcaddr + 4),
		.in1(baddr),
		.sel(pcsrc),
		.out(w_mux_tmp)
	);

	mux_2to1 #(
		.N(32)
	) JUMP_MUX(
		.in0(w_mux_tmp),
		.in1(jaddr),
		.sel(Jump),
		.out(w_mux_pc)
	);
	
//////////////////////////////////////////////////////////////////////////////////////////////
// IF/ID stage

	always@ (posedge clk or negedge rst or Flush) begin // TODO: possible source of bugs Jump
		if (!rst) begin
			pc_out = 32'b0;
			ins_out = 32'b0;		
		end
		else begin
			pc_out = w_pc_im_pcaddr + 4;
			ins_out = w_im_ifid;
		end
		if(Flush) begin
			ins_out = 0; // TODO: possible source of bugs, delete the statement
		end
	end

//////////////////////////////////////////////////////////////////////////////////////////////
	
endmodule
