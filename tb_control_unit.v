`timescale 1ns/1ps
module tb_control_unit();
    reg[5:0] opcode;
    wire Jump;
    wire [3:0] EX;
    wire [2:0] MEM;
    wire [1:0] WB;

    control_unit CONTROL_UNIT(
        .opcode(opcode),
        .Jump(Jump),
        .EX(EX),
        .MEM(MEM),
        .WB(WB)
    );

    initial begin
        opcode = 6'b000000; #10;
        opcode = 6'b000001; #10;
        opcode = 6'b000010; #10;
        opcode = 6'b000011; #10;
        opcode = 6'b001000; #10;
        opcode = 6'b001001; #10;
        opcode = 6'b000100; #10;
    end
endmodule