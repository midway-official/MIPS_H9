module Clock_Gate (
    input  wire clk,    // 输入时钟信号
    input  wire lock,   // 使能信号
    output wire clk_out // 输出时钟信号
);

    assign clk_out = lock ? clk : 1'b0;

endmodule