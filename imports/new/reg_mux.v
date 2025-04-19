module register_mux (
    input wire reg_wen,          // �Ĵ���дʹ���ź�
    input wire data_mem_en,     // ���ݴ洢��ʹ���ź�
    input wire data_mem_wen,    // ���ݴ洢��дʹ���ź�
    input wire [31:0] data_mem, // 32 λ���ݴ洢������ź�
    input wire [31:0] ALU_out,  // 32 λ ALU ����ź�
    output reg [31:0] data_out  // 32 λѡ������ź�
);

always @(*) begin
    if (reg_wen&& !data_mem_en) begin
        data_out = ALU_out;  // ��� reg_wen Ϊ 1���ڴ治�������� ALU ����ź�
    end else if (data_mem_en && !data_mem_wen && data_mem_en) begin
        data_out = data_mem; // ��� data_mem_en Ϊ 1 �� data_mem_wen Ϊ 0���ڴ�Ϊ��ģʽ������� data_mem �ź�
    end else begin
        data_out = 32'b0;     // Ĭ����� 0
    end
end

endmodule
