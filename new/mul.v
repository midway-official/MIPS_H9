module array_multiplier_32x32 (
    input [31:0] a,       // 32λ������
    input [31:0] b,       // 32λ����
    output [63:0] result  // 64λ�˻����
);
    wire [31:0] partial_products [31:0];  // ���ڴ洢32�鲿�ֻ�
    wire [63:0] sum [30:0];               // �ӷ������е����ۼӽ��
    wire [63:0] carry [30:0];             // ��λ���

    // ���ɲ��ֻ���Partial Products��
    genvar i, j;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                assign partial_products[i][j] = a[j] & b[i];  // ���ֻ� = A[j] & B[i]
            end
        end
    endgenerate

    // ��һ�㲿�ֻ��ۼӣ�ʹ�üӷ���
    assign sum[0] = {32'b0, partial_products[0]} + {31'b0, partial_products[1], 1'b0};
    assign carry[0] = {32'b0, partial_products[0]} & {31'b0, partial_products[1], 1'b0};

    // ʹ�����ӷ������ۼӲ��ֻ���ѹ�����ֻ����������
    generate
        for (i = 1; i < 31; i = i + 1) begin
            assign sum[i] = sum[i-1] + {carry[i-1][62:0], 2'b00} + {partial_products[i+1], i+1'b0};
            assign carry[i] = sum[i-1] & {carry[i-1][62:0], 2'b00} & {partial_products[i+1], i+1'b0};
        end
    endgenerate

    // ���ս�����
    assign result = sum[30] + {carry[30][62:0], 2'b00};

endmodule