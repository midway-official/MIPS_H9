module always_zero (
    output reg out_signal   // ���˿������޸�Ϊ out_signal
);

    // ʼ�ս��������Ϊ 0
    always @(*) begin
        out_signal = 0;
    end

endmodule
