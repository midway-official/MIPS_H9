module always_ONE (
    output reg out_signal   // ���˿������޸�Ϊ out_signal
);

    // ʼ�ս��������Ϊ 0
    always @(*) begin
        out_signal = 1;
    end

endmodule
