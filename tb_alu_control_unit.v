`timescale 1ns/1ps
module tb_alu_control_unit();
    reg [5:0] ins;
    reg [1:0] ALUOp;
    wire [3:0] ALUctrl;

    alu_control_unit ALU_CONTROL_UNIT(
        .ins(ins),
        .ALUOp(ALUOp),
        .ALUctrl(ALUctrl)
    );

    initial begin
        ALUOp = 2'b00; #10;
        ALUOp = 2'b01; #10;
        ALUOp = 2'b10;
        ins = 6'b100000; #10;
        ins = 6'b100010; #10;
        ins = 6'b100100; #10;
        ins = 6'b100101; #10;
        ins = 6'b101010; #10;
        $stop;
    end
endmodule