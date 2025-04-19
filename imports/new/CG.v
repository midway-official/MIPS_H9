module Clock_Gate (
    input  wire clk,    // ����ʱ���ź�
    input  wire lock,   // ʹ���ź�
    output wire clk_out // ���ʱ���ź�
);

    assign clk_out = lock ? clk : 1'b0;

endmodule