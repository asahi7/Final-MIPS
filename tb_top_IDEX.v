module tb_top_IDEX();
    
    wire [31:0] baddr_out, result, read_d2_out;
    wire zero;
    wire [4:0] write_register_out;
    wire [2:0] MEM;
    wire [1:0] WB;

    reg clk, rst, pcsrc, regwrite;
    reg [31:0] baddr, write_data;
    reg [4:0] write_register;

    top_IDEX TOP_IDEX(
        .clk(clk),
        .rst(rst),
        .pcsrc(pcsrc),
        .write_register(write_register),
        .regwrite(regwrite),
        .baddr(baddr),
        .write_data(write_data),

        .baddr_out(baddr_out),
        .result_out(result),
        .zero(zero),
        .write_register_out(write_register_out),
        .MEM_out(MEM),
        .WB_out(WB),
		.read_d2_out(read_d2_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // TODO:

        rst = 1'b1; #10;
        rst = 1'b0; #10;
        rst = 1'b1; #10;

        pcsrc = 1'b0;
        baddr = 1'b0; #10;

        #150;

        $stop;
    end

endmodule
