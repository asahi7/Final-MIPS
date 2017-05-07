module top_ID(clk, rst, baddr_out, IF_pcsrc, IF_Flush, write_register, write_data, regwrite, pc, read_d1, read_d2, se, rs, rt, rd, w_pc, w_ins, Jump, EX, MEM, WB, jaddr);
    input clk, rst, regwrite;
	output reg IF_Flush;
    input [31:0] write_data, w_pc, w_ins;
    input [4:0] write_register;
    output reg [31:0] pc, read_d1, read_d2, se;
    output reg [4:0] rt, rd, rs;
    wire [31:0] sign_out, reg_out_1, reg_out_2;
    
    wire Jump_wire, IF_Flush_wire;
    wire [3:0] EX_wire;
    wire [2:0] MEM_wire;
    wire [1:0] WB_wire;

    output reg Jump;
	output reg [31:0] baddr_out;
	output reg IF_pcsrc;
    output reg [3:0] EX;
    output reg [2:0] MEM;
    output reg [1:0] WB;

    output reg [31:0] jaddr;
/*
    top_if TOP_IF(
        .clk(clk),
        .rst(rst),
        .pcsrc(pcsrc),
        .baddr(baddr),
        .pc_out(pc_out),
        .ins_out(ins_out)
    );
*/

    control_unit CONTROL_UNIT(
        .opcode(w_ins >> 26),
        .Jump(Jump_wire),
		.IF_Flush(IF_Flush_wire),
        .EX(EX_wire),
        .MEM(MEM_wire),
        .WB(WB_wire)
    );

    register_file REGISTER_FILE(
        .rst(rst),
        .RegWrite(regwrite),
        .read_reg_1((w_ins & 32'b000000_11111_00000_00000_00000_000000) >> 21),  // rs
        .read_reg_2((w_ins & 32'b000000_00000_11111_00000_00000_000000) >> 16),  // rt
        .write_reg(write_register),
        .write_data(write_data),
        .out_data_1(reg_out_1),
        .out_data_2(reg_out_2)
    );

    sign_extend SIGN_EXTEND(
        .in((w_ins & 32'b000000_00000_00000_11111_11111_111111)),  // last 16 bit
        .out(sign_out)
    );
	
	//always @(reg_out_1 or reg_out_2 or MEM_wire) begin // TODO: possible source of bugs
	//end

    always @(posedge clk or negedge rst) begin
        pc = w_pc;
        read_d1 = reg_out_1;
        read_d2 = reg_out_2;
        se = sign_out;
        rt = (w_ins & 32'b000000_00000_11111_00000_00000_000000) >> 16;
        rd = (w_ins & 32'b000000_00000_00000_11111_00000_000000) >> 11;
		rs = (w_ins & 32'b000000_11111_00000_00000_00000_000000) >> 21;
        Jump = Jump_wire;
		IF_Flush = IF_Flush_wire;
        EX = EX_wire;
        MEM = MEM_wire;
        WB = WB_wire;
        jaddr = (pc & 32'b1111_0000_0000_0000_0000_0000_0000_0000) | ((w_ins << 2) & 32'b0000_1111_1111_1111_1111_1111_1111_1111);
		if(reg_out_1 == reg_out_2 && (MEM_wire & 3'b100) >> 2) begin
			baddr_out = ((sign_out << 2) + w_pc);
			IF_pcsrc = 1'b1;
			IF_Flush = 1'b1;
		end else begin
			IF_pcsrc = 1'b0;
		end
		if(!rst) begin
            read_d1 = 32'b0; read_d2 = 32'b0;
            se = 32'b0; rt = 32'b0; rd = 32'b0;
            Jump = 0; EX=0; MEM=0; WB=0;
            jaddr = 0; rs=0;
			IF_Flush = 1'b0;
        end
    end
endmodule