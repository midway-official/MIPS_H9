module array_multiplier_32x32 (
    input [31:0] a,       // 32位被乘数
    input [31:0] b,       // 32位乘数
    output [63:0] result  // 64位乘积结果
);
    wire [31:0] partial_products [31:0];  // 用于存储32组部分积
    wire [63:0] sum [30:0];               // 加法器链中的逐步累加结果
    wire [63:0] carry [30:0];             // 进位输出

    // 生成部分积（Partial Products）
    genvar i, j;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                assign partial_products[i][j] = a[j] & b[i];  // 部分积 = A[j] & B[i]
            end
        end
    endgenerate

    // 第一层部分积累加，使用加法器
    assign sum[0] = {32'b0, partial_products[0]} + {31'b0, partial_products[1], 1'b0};
    assign carry[0] = {32'b0, partial_products[0]} & {31'b0, partial_products[1], 1'b0};

    // 使用逐层加法器链累加部分积，压缩部分积到最终输出
    generate
        for (i = 1; i < 31; i = i + 1) begin
            assign sum[i] = sum[i-1] + {carry[i-1][62:0], 2'b00} + {partial_products[i+1], i+1'b0};
            assign carry[i] = sum[i-1] & {carry[i-1][62:0], 2'b00} & {partial_products[i+1], i+1'b0};
        end
    endgenerate

    // 最终结果输出
    assign result = sum[30] + {carry[30][62:0], 2'b00};

endmodule