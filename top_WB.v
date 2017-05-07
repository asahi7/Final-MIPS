module top_WB(MemtoReg, data0, data1, write_data);
    input MemtoReg;
    input [31:0] data0, data1;
    output [31:0] write_data;
    mux_2to1 MUX(
        .in0(data0),
        .in1(data1),
        .sel(MemtoReg),
        .out(write_data)
    );
endmodule