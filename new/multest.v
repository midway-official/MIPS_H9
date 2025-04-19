module multest (
    input [31:0] a,       // 32位被乘数
    input [31:0] b,       // 32位乘数
    output [63:0] result  // 64位乘积结果
);

    wire [31:0] partial_products [31:0];  // 用于存储32组部分积
    wire [63:0] sum [31:0];               // 加法器链中的逐步累加结果
    wire [63:0] carry [31:0];             // 进位输出

    // 生成部分积（Partial Products）
    genvar i, j;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                assign partial_products[i][j] = a[j] & b[i];  // 部分积 = A[j] & B[i]
            end
        end
    endgenerate

    // 初始化第0层的加法器链
    assign sum[0] = {32'b0, partial_products[0]};  // 初始部分积
    assign carry[0] = 64'b0;  // 初始进位为零

    // 逐层累加部分积，处理每一层的加法与进位
    generate
        for (i = 1; i < 32; i = i + 1) begin
            // 累加前一层的结果、当前层的部分积，并考虑进位
            assign sum[i] = sum[i-1] + {carry[i-1][62:0], 2'b00} + {partial_products[i], i[31:0]};
            // 计算进位
            assign carry[i] = sum[i-1] & {carry[i-1][62:0], 2'b00} & {partial_products[i], i[31:0]};
        end
    endgenerate

    // 最终结果输出
    assign result = sum[31] + {carry[31][62:0], 2'b00};

endmodule