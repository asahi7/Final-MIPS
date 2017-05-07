module top_EX(clk, rst,
				WB, MEM, EX, pc, rs, rt, rd, se, read_d1, read_d2, // inputs from IFID
	    WB_data, ALU_result, EXMEMRegRd, EXMEM_WB, MEMWBRegRd, MEMWB_WB,
                result_out, zero, write_register_out, MEM_out, WB_out, // deleted baddr_out
				ForwardA, ForwardB,
				read_d2_out); // TODO: add the outputs and delete unnecessary params
    // INPUT FOR IDEX BEGIN
    input clk, rst;
	input [31:0] pc, read_d1, read_d2, se; // output from IFID
    input [4:0] rt, rd; // output from IFID
	input [1:0] WB;
	input [2:0] MEM;
	input [3:0] EX;
	input [4:0] EXMEMRegRd, EXMEM_WB, MEMWBRegRd;
	input [1:0] MEMWB_WB;
	input [4:0] rs;
	input [31:0] WB_data, ALU_result;
	wire [1:0] sel_A, sel_B;
	
	output [1:0] ForwardA, ForwardB; // remove output and replace reg with wire

	wire Jump; // TODO: where to pass the Jump?
    // INPUT FOR IDEX END
    wire [31:0] output_MUX_A, output_MUX_B;	

    wire [31:0] result_alu, alu_sec_choice;
    wire zero_alu;
    wire [4:0] write_reg_mux;
    wire [3:0] ctrl;
    wire [1:0] ALUOp;

    // OUTPUT FOR IDEX BEGIN
    output reg [31:0] result_out, read_d2_out; // deleted baddr_out
    output reg zero;
    output reg [4:0] write_register_out;
    output reg [2:0] MEM_out;
    output reg [1:0] WB_out;
    // OUTPUT FOR IDEX END

	// The following code was commented because we do not need 
	// to call the previous level in the pipeline.
	// We just connect each output from level k to the k+1 level
	// by using TOP MIPS
    /* top_IFID TOP_IFID(
        // INPUTS FOR IFID BEGIN
        .clk(clk),
        .rst(rst),
        .write_data(write_data),
        // INPUTS FOR IFID END
        // OUTPUTS FROM IFID BEGIN
        .read_d1(read_d1),
        .read_d2(read_d2),
        .pc(pc),
        .se(se),
        .rt(rt),
        .rd(rd),

        .Jump(Jump),
        .EX(EX),
        .MEM(MEM),
        .WB(WB)
        // OUTPUTS FROM IFID END
    ); */
   forwarding_unit FORWARDING_UNIT(
.clk(clk),
.rst(rst),
.Rs(rs),
.Rt(rt),
.EXMEMRegRd(EXMEMRegRd),
.EXMEM_WB(EXMEM_WB),
.MEMWBRegRd(MEMWBRegRd),
.MEMWB_WB(MEMWB_WB),
.ForwardA(ForwardA),
.ForwardB(ForwardB)
);

   mux_3to1 MUX_3TO1_A(
        .in0(read_d1),
        .in1(WB_data), 
        .in2(ALU_result), 
        .sel(ForwardA), 
        .out(output_MUX_A)
);
    mux_3to1 MUX_3TO1_B(
        .in0(read_d2),
        .in1(WB_data), 
        .in2(ALU_result), 
        .sel(ForwardB), 
        .out(output_MUX_B)
);    
	mux_2to1 #(
		.N(5)
	) REG_DST_MUX (
		.in0(rt),
		.in1(rd),
		.sel((EX & 4'b1000) >> 3), // TODO: comes from control unit
		.out(write_reg_mux)
	);
	

    alu_control_unit ALU_CONTROL ( // TODO: not tested yet, maybe will require change of params
        .ins((se & 32'b000000_00000_00000_00000_00000_111111)),
        .ALUOp((EX & 4'b0110) >> 1), // TODO: comes from control unit
        .ALUctrl(ctrl)
    );

    mux_2to1 #(
        .N(32)
    ) ALU_SEC_MUX (
        .in0(output_MUX_B),
        .in1(se),
        .sel((EX & 4'b0001)), // TODO: comes from control unit
        .out(alu_sec_choice)
    );

    ALU ALU_UNIT (
        .data1(output_MUX_A),
        .data2(alu_sec_choice),
        .ctrl(ctrl),
        .zero(zero_alu),
        .result(result_alu)
    );
	
    always @(posedge clk or negedge rst) begin // TODO: consider the rst 
        // baddr_out = (se << 2) + pc;
        write_register_out = write_reg_mux;
        result_out = result_alu;
        zero = zero_alu;
        // read_d2_out = read_d2;
        read_d2_out = output_MUX_B;
		MEM_out = MEM;
        WB_out = WB;
		if(! rst) begin
		//	baddr_out = 32'b0;
			write_register_out = 5'b0;
			result_out = 32'b0;
			zero = 1'b0;
			read_d2_out = 32'b0;
			MEM_out = 3'b0;
			WB_out = 2'b0;
		end
    end

endmodule
