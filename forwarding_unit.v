module forwarding_unit(clk, rst, Rs, Rt, EXMEMRegRd, EXMEM_WB, MEMWBRegRd, MEMWB_WB, ForwardA, ForwardB);
    input clk, rst;
	input [4:0] Rs, Rt, EXMEMRegRd, MEMWBRegRd;
    input [1:0] EXMEM_WB, MEMWB_WB;
    output reg[1:0] ForwardA, ForwardB;

    always @(*) begin
		ForwardA <= 2'b00;
		ForwardB <= 2'b00;
	
		if(EXMEM_WB>>1 && EXMEMRegRd != 0 && EXMEMRegRd == Rs) begin
			ForwardA <= 2'b10;
		end
		if(EXMEM_WB>>1 && EXMEMRegRd != 0 && EXMEMRegRd == Rt) begin
			ForwardB <= 2'b10;
		end
		
		// WB >> 1 == WB.RegWrite
        if(MEMWB_WB>>1 && MEMWBRegRd != 0 && !(EXMEM_WB>>1 && EXMEMRegRd != 0 && EXMEMRegRd == Rs) && MEMWBRegRd == Rs) begin
			ForwardA <= 2'b01;
        end        
		if(MEMWB_WB>>1 && MEMWBRegRd != 0 && !(EXMEM_WB>>1 && EXMEMRegRd != 0 && EXMEMRegRd == Rt) && MEMWBRegRd == Rt) begin
			ForwardB <= 2'b01;
        end


        if(!rst) begin
            ForwardA <= 2'b00;
            ForwardB <= 2'b00;
        end
    end
endmodule
