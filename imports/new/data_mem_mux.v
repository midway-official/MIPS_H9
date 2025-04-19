module data_mem_mux (
    input wire data_mem_en,      // ���ݴ洢��ʹ���ź�
    input wire data_mem_wen,     // ���ݴ洢��дʹ���ź�
    input wire [31:0] data_mem_in, // ���ݴ洢����������
    output reg [31:0] data_mem_out // ���ݴ洢���������
);

always @(*) begin
    if (data_mem_en && data_mem_wen) begin
        data_mem_out = data_mem_in;  // ��� data_mem_en �� data_mem_wen ��Ϊ 1������� data_mem_in
    end else begin
        data_mem_out = 32'b0;        // ������� 0
    end
end

endmodule
