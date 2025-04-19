module compare (
    input [31:0] A,              // 输入A
    input [31:0] B,              // 输入B
    input [4:0] compareOp,       // 操作码
    input flag_in,               // 新增输入信号
    output reg [31:0] Result,    // 输出结果
    output reg flag_out          // 新增输出信号
);

always @(*) begin
    case (compareOp)
        // 输出A或B
        5'd14:  Result = A;
        5'd15:  Result = B;

        // 相等比较
        5'd17:  Result = (A == B) ? 32'b1 : 32'b0;

        // 不相等比较
        5'd18:  Result = (A != B) ? 32'b1 : 32'b0;

        // 操作码0输出0
        5'd0:   Result = 32'b0;

        default: Result = 32'b0;
    endcase

    // flag_out逻辑
    if (Result == 32'b1)
        flag_out = 1'b1;
    else
        flag_out = 1'b0;
end

endmodule