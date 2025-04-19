module sram_wrapper_test (
    input  wire        clka,    // ʱ���ź�
    input  wire        rstb,    // ��λ�ź�
    input  wire        wea,     // дʹ�ܣ���ʹ�ã�
    input  wire [31:0] waddr,   // д���ַ����ʹ�ã�
    input  wire [31:0] dina,    // д�����ݣ���ʹ�ã�
    input  wire [31:0] addra,   // ��ȡ��ַ
    output reg  [31:0] douta    // ��ȡ����
);

    // ����һ���򵥵� 32-bit ��ַ���Ϊ 8 �� SRAM
    reg [31:0] sram_mem [0:7];  // �洢���� 8 ��λ��

    // ��ʼ���洢�������ݸ����ĳ�ʼ��������
    initial begin
        sram_mem[0] = 32'b00111100000010000000000000000000;
        sram_mem[1] = 32'b00100001000010000000000000000101;
        sram_mem[2] = 32'b00111100000010010000000000000000;
        sram_mem[3] = 32'b00100001001001000000000000001010;
        sram_mem[4] = 32'b00000001000010010101000001000000;
        sram_mem[5] = 32'b00111100000010110000100111110000;
        sram_mem[6] = 32'b00100001011010111111111111111111;
        sram_mem[7] = 32'b10101101011010000000000000000000;
    end

    // ��ȡ������������ addra ���ж�ȡ��
    always @(*) begin
        douta = sram_mem[addra[2:0]];  // ��ַȡ��3λ����ѡ��洢���е�λ��
    end

endmodule
