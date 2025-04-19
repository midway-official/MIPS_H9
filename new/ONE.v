module always_ONE (
    output reg out_signal   // 将端口名称修改为 out_signal
);

    // 始终将输出设置为 0
    always @(*) begin
        out_signal = 1;
    end

endmodule
