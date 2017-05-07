`timescale 1ns/1ps
/*
 To be used for Spring 2017, CSE301 Computer Architecture course, by Prof. Lee.
 
 Prepared by Daewoo Kim, UNIST.
 
 TODO
   - Change the following instance names according to your design: RF, IM, DM
 
 */

module tb_top_mips;
	reg clk;
	reg rst;
	wire [31:0] PCaddr, IM_Ins;
	wire [5:0] OP;
	wire [4:0] RS, RT, RD, SH;
	wire [5:0] FU;
	wire [31:0] RF_D1, RF_D2, SE, Branch_Addr, ALU_Result;
	wire ALU_Zero;
	wire [31:0] Write_Data, Read_Data, WB_Data;
	integer i;
	// EXPERIMENTAL OUTPUTS BEGIN
	wire [4:0] WriteRegister_MEMID; //
	wire [31:0] ALU_Result_MEMWB;
	wire [1:0] WB_ctrl_MEMWB;
	wire [4:0] EXMEMRegRd, EXMEM_WB, MEMWBRegRd;
	wire [1:0] MEMWB_WB;
	//
	wire [1:0] WB_ctrl_EXMEM;
	wire [4:0] WriteRegister_EXMEM;
	wire [1:0] ForwardA, ForwardB;
	// EXPERIMENTAL OUTPUTS END
	
	top_mips DUT(
		// EXPERIMENTAL OUTPUTS BEGIN
		.WriteRegister_MEMID(WriteRegister_MEMID),
		.ALU_Result_MEMWB(ALU_Result_MEMWB),
		// EXPERIMENTAL OUTPUTS END
		.clk(clk),
		.rst(rst),
		.PCaddr(PCaddr),
		.IM_Ins(IM_Ins),
		.OP(OP),
		.RS(RS),
		.RT(RT),
		.RD(RD),
		.SH(SH),
		.FU(FU),
		.RF_D1(RF_D1),
		.RF_D2(RF_D2),
		.SE(SE),
		.ALU_Result(ALU_Result),
		.ALU_Zero(ALU_Zero),
		.Branch_Addr(Branch_Addr),
		.Write_Data(Write_Data),
		.Read_Data(Read_Data),
		.WB_Data(WB_Data),
		.WB_ctrl_MEMWB(WB_ctrl_MEMWB),
		///
		.WriteRegister_EXMEM(WriteRegister_EXMEM),
		.WB_ctrl_EXMEM(WB_ctrl_EXMEM),
		.ForwardA(ForwardA),
		.ForwardB(ForwardB)
		//.WriteRegister_MEMID(WriteRegister_MEMID)
		//.EXMEMRegRd(ALU_Result),
		//.EXMEM_WB(WB_ctrl_EXMEM),
		//.MEMWBRegRd(WriteRegister_MEMID),
		//.MEMWB_WB(WB_ctrl_MEMWB)
	);

	
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		rst = 1'b0; #10;
		rst = 1'b1; #10;

    // TODO: Modify the following number as necessary
	/////////////////////////////////////////////////
	///////////////I don't understand////////////////
		#200;

		// TODO: Replace IM with Instruction Memory's instance name
    $display("Test ID: #%d\n", DUT.TOP_IF.IM.memory[31]);
    for ( i = 0; i < 32; i = i + 1 ) begin
			// TODO: Replace RF with Register File's instance name
			$display("R[%02d]: %8x\n", i, DUT.TOP_ID.REGISTER_FILE.register[i]);
    end
	
		for ( i = 0; i < 32; i = i + 1 ) begin
			// TODO: Replace DM with Data Memory's instance name
			$display("DATA[%02d]: %8x\n", i, DUT.TOP_MEM.MEMORY.memory[i]);
    end

		$stop;

	end
	
endmodule
