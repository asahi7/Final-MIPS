`timescale 1ns/1ps
module tb_data_memory();
    reg [31:0] addr, writedata;
    reg rst, MemWrite, MemRead;
    wire [31:0] readdata;

    data_memory DATA_MEMORY(
        .rst(rst),
        .addr(addr),
        .writedata(writedata),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .readdata(readdata)
    );

    initial begin
        rst = 1; #10;
        rst = 0; #10;
        rst = 1; #10;

        MemWrite = 0; #10;
        addr = 40; #10;
        MemRead = 1; #10;
		MemRead = 0;
		addr = 0; #10;
		addr = 20; #10;
		MemRead = 1; #10;
		MemRead = 0; #10;

        writedata = 50; #20;

        writedata = 20; #10;
        MemWrite = 1; #10;
        MemWrite = 0; #10;
		
        MemRead = 1; #10;
        MemRead = 0; #10;

        // -----
   
        rst = 1; #10;
        rst = 0; #10;
        rst = 1; #10;

        MemWrite = 0;
        addr = 4; #10;
        MemRead = 1;#10;
        MemRead = 0; #10;

        writedata = 333; #10;

        writedata = 77;
        MemWrite = 1; #10;
        MemWrite = 0; #10;
		
        MemRead = 1; #10;

        MemRead = 0; #10;

        // -----

        rst = 1; #10;
        rst = 0; #10;
        rst = 1; #10;

        MemRead = 1; #10;

        $stop;
    end
endmodule