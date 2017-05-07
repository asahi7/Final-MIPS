module top_mips(clk, rst, PCaddr, IM_Ins, OP, RS, RT, RD, SH, FU, RF_D1, RF_D2, SE, ALU_Result, ALU_Zero,
				Branch_Addr, Write_Data, Read_Data, WB_Data,
				// EXPERIMENTAL OUTPUTS BEGIN
				ALU_Result_MEMWB,
				//EXMEMRegRd_reg, EXMEM_WB_reg, MEMWBRegRd_reg, MEMWB_WB_reg
				WriteRegister_EXMEM, WB_ctrl_EXMEM, WriteRegister_MEMID, WB_ctrl_MEMWB,
				ForwardA, ForwardB
				// EXPERIMENTAL OUTPUTS END
				);
    input clk, rst;
    
	output wire [31:0] PCaddr, IM_Ins;
	output wire [5:0] OP;
	output wire [4:0] RS, RT, RD, SH;
	output wire [5:0] FU;
	output wire [31:0] RF_D1, RF_D2, SE, Branch_Addr, ALU_Result;
	output wire ALU_Zero;
	output wire [31:0] Write_Data, Read_Data, WB_Data;
	// EXPERIMENTAL OUTPUTS BEGIN
	output wire [4:0] WriteRegister_MEMID;
	output wire [31:0] ALU_Result_MEMWB;
	output wire [1:0] WB_ctrl_MEMWB;
	// EXPERIMENTAL OUTPUTS END
	wire IF_Flush;
    wire pcsrc, Jump, RegWrite;
    wire [31:0] jaddr;
    output wire [4:0] WriteRegister_EXMEM; // WriteRegister_MEMID
    wire [31:0] PCAddr_IDEX;
    // wire [31:0] ALU_Result_MEMWB;

    wire [3:0] EX_ctrl_IDEX;
    wire [2:0] MEM_ctrl_IDEX, MEM_ctrl_EXMEM;
    wire [1:0] WB_ctrl_IDEX, WB_ctrl_WBID;
    output wire [1:0] WB_ctrl_EXMEM;
	output [1:0] ForwardA, ForwardB; // remove this after
	wire pcsrc_from_ID;
	
	wire [4:0] EXMEMRegRd, EXMEM_WB, MEMWBRegRd;
	wire [1:0] MEMWB_WB;
	//reg EXMEMRegRd_reg[4:0], EXMEM_WB_reg[4:0], MEMWBRegRd_reg[4:0];
	//reg MEMWB_WB_reg[1:0];
	
    top_if TOP_IF(
        .clk(clk),
        .rst(rst),
		.Flush(IF_Flush),
        // .pcsrc(pcsrc), 
		// (MEM & 3'b100) >> 2)
        //.pcsrc(ALU_Zero & ((MEM_ctrl_EXMEM & 3'b100) >> 2)),
		.pcsrc(pcsrc_from_ID),
		.baddr(Branch_Addr),
        .pc_out(PCaddr),
        .ins_out(IM_Ins),
        .Jump(Jump),
        .jaddr(jaddr)
    );

    top_ID TOP_ID(
        .clk(clk),
        .rst(rst),
        .write_register(WriteRegister_MEMID),
        .write_data(WB_Data),
        // .regwrite(WB_ctrl_WBID >> 1),
        .regwrite((WB_ctrl_MEMWB & 2'b10) >> 1),
		.pc(PCAddr_IDEX),
        .read_d1(RF_D1),
        .read_d2(RF_D2),
        .se(SE),
        .rt(RT),
        .rd(RD),
		.baddr_out(Branch_Addr),
		.IF_pcsrc(pcsrc_from_ID),
        .w_pc(PCaddr),
        .w_ins(IM_Ins),
        .Jump(Jump),
		.IF_Flush(IF_Flush),
        .EX(EX_ctrl_IDEX),
        .MEM(MEM_ctrl_IDEX),
        .WB(WB_ctrl_IDEX),
        .jaddr(jaddr), 
		.rs(RS)
    );

    top_EX TOP_EX(
        .clk(clk),
        .rst(rst),
        .WB(WB_ctrl_IDEX),
        .MEM(MEM_ctrl_IDEX),
        .EX(EX_ctrl_IDEX),
        .pc(PCAddr_IDEX),
        .rt(RT),
        .rd(RD),
        .se(SE),
        .read_d1(RF_D1),
        .read_d2(RF_D2),
        //.baddr_out(Branch_Addr),
        .result_out(ALU_Result),
        .zero(ALU_Zero),
        .write_register_out(WriteRegister_EXMEM),
        .MEM_out(MEM_ctrl_EXMEM),
        .WB_out(WB_ctrl_EXMEM),
        .read_d2_out(Write_Data), // should come from mux not read_d2
		
		// FORWARDING BEGIN
		.rs(RS),
		.EXMEMRegRd(WriteRegister_EXMEM),
		.EXMEM_WB(WB_ctrl_EXMEM),
		.MEMWBRegRd(WriteRegister_MEMID),
		.MEMWB_WB(WB_ctrl_MEMWB),
		.ALU_result(ALU_Result),
		.ForwardA(ForwardA),
		.ForwardB(ForwardB)
		// FORWARDING END
    );
	
	/*always @(WriteRegister_EXMEM or WB_ctrl_EXMEM or WriteRegister_MEMID or WB_ctrl_MEMWB) begin
		EXMEMRegRd_reg <= WriteRegister_EXMEM;
		WB_ctrl_EXMEM_reg <= WB_ctrl_EXMEM;
		WriteRegister_MEMID_reg <= WriteRegister_MEMID;
		WB_ctrl_MEMWB_reg <= WB_ctrl_MEMWB;
	end*/
	
    top_MEM TOP_MEM(
        .clk(clk),
        .rst(rst),
        .WB(WB_ctrl_EXMEM),
        .MEM(MEM_ctrl_EXMEM),
        .zero(ALU_Zero),
        .result(ALU_Result),
        .write_data(Write_Data),
        .write_register(WriteRegister_EXMEM),
        // .WB_out(WB_ctrl),
        .read_data(Read_Data),
        .branch(pcsrc),
        // EXPERIMENTAL OUTPUTS BEGIN
		.result_out(ALU_Result_MEMWB),
        .write_register_out(WriteRegister_MEMID),
		.WB_out(WB_ctrl_MEMWB)
		// EXPERIMENTAL OUTPUTS END
    );

    top_WB TOP_WB(
        .MemtoReg(WB_ctrl_MEMWB & 2'b01),
        // .data0(Read_Data),
        // .data1(ALU_Result_MEMWB),
		.data0(ALU_Result_MEMWB),
        .data1(Read_Data),
		.write_data(WB_Data) // WB_Data should be register?
    );
endmodule