`timescale 1ns/1ps
module tb_ALU();
    reg[31:0] data1, data2;
    reg[3:0] ctrl;
    wire zero_out;
    wire[31:0] result_out;

ALU alu(
    .data1(data1),
    .data2(data2),
    .ctrl(ctrl),
    .zero(zero_out),
    .result(result_out)
);

initial begin
    ctrl <= 4'b0000;
    data1 <= 32'd8;
    data2 <= 32'd0;

    #10;

    ctrl <= 4'b0001;
    data1 <= 32'd8;
    data2 <= 32'd0;

    #10;

    ctrl <= 4'b0010;
    data1 <= 32'd55;
    data2 <= 32'd100;

    #10;

    ctrl <= 4'b0110; // considering 55 - 100, i.e. negative values
    
    #10;

    ctrl <= 4'b0111;
    data1 <= 32'd100;
    data2 <= 32'd150;
    
    #10;

	data1 <= 32'd150;
	data2 <= 32'd100;
	
	#10;
	
    ctrl <= 4'b1100;
    data1 <= 32'b1111;
    data2 <= 32'b1111;

	#10;
	
	data1 <= 4'b1011;
	data2 <= 4'b0111;
	
    #10;

    ctrl <= 4'b1111; // checks the result, if it is equal to 0, and if zero wire is 1

    #10;

    ctrl <= 4'b0010; // checks if the zero wire is 0
    data1 <= 32'd30;
    data2 <= 32'd55;

    #10;
	
	ctrl <=4'b0110;
	data1 <=55;
	data2 <=55;
	
	#10;
	
	$stop;
end
endmodule
