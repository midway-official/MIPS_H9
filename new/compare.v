module compare (
    input [31:0] A,              // ����A
    input [31:0] B,              // ����B
    input [4:0] compareOp,       // ������
    input flag_in,               // ���������ź�
    output reg [31:0] Result,    // ������
    output reg flag_out          // ��������ź�
);

always @(*) begin
    case (compareOp)
        // ���A��B
        5'd14:  Result = A;
        5'd15:  Result = B;

        // ��ȱȽ�
        5'd17:  Result = (A == B) ? 32'b1 : 32'b0;

        // ����ȱȽ�
        5'd18:  Result = (A != B) ? 32'b1 : 32'b0;

        // ������0���0
        5'd0:   Result = 32'b0;

        default: Result = 32'b0;
    endcase

    // flag_out�߼�
    if (Result == 32'b1)
        flag_out = 1'b1;
    else
        flag_out = 1'b0;
end

endmodule