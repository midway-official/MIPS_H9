module Comparator (
    input  wire        mem_wen,    // �ڴ�дʹ�� (1 = д, 0 = ��)
    input  wire        mem_en,     // �ڴ�ʹ�� (1 = �����ڴ�, 0 = ������)
    input  wire [31:0] ALUresult,  // ALU ������
    input  wire [31:0] mem_out,    // �ڴ��ȡ������
    output wire [31:0] final_result // �������
);

    // �ж��߼���
    // ��� mem_en Ϊ 1 �� mem_wen Ϊ 0����ѡ�� mem_out�����ڴ��ȡ�����ݣ�
    // ����ѡ�� ALUresult��Ĭ�������
    assign final_result = (mem_en && ~mem_wen) ? mem_out : ALUresult;

endmodule
