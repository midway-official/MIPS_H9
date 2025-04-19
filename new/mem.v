module MEM (
    input wire clk,                    // ʱ���ź�
    input wire reset,                  // ��λ�ź�
    
    // �� EX/MEM ���������
    input wire [31:0] ALU_result_in,    // EX �׶ε� ALU �����������ڵ�ַ���㣩
    input wire [4:0] w_in,              // EX �׶ε�Ŀ��Ĵ�����ַ
    input wire data_mem_en_in,          // �ڴ����ʹ��
    input wire data_mem_wen_in,         // �ڴ�дʹ��
    input wire reg_wen_in,              // EX �׶εļĴ���дʹ��
    input wire [31:0] mem_write_data_in,// �ڴ�д�������
    
    // �������ݴ洢��
    output reg [31:0] mem_addr,         // �ڴ��ַ
    output reg [31:0] mem_write_data,   // �ڴ�д������
    output reg mem_en,                  // �ڴ����ʹ��
    output reg mem_wen,                 // �ڴ�дʹ��
    input wire [31:0] mem_read_data,    // �ڴ��ȡ�����ݣ��Ӵ洢�����أ�

    // ���ݵ� MEM/WB
    output reg [31:0] ALU_result_out,   // ���� ALU ������
    output reg [4:0] w_out,             // Ŀ��Ĵ�����ַ
    output reg data_mem_en_out,         // �ڴ����ʹ��
    output reg data_mem_wen_out,        // �ڴ�дʹ��
    output reg reg_wen_out,             // ���ݼĴ���дʹ��
    output reg [31:0] mem_read_data_out // ��ȡ���ڴ����ݣ������ LW ָ�
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // ��λʱ���������ź�
            ALU_result_out <= 32'b0;
            w_out <= 5'b0;
            data_mem_en_out <= 0;
            data_mem_wen_out <= 0;
            reg_wen_out <= 0;
            mem_read_data_out <= 32'b0;

            mem_addr <= 32'b0;
            mem_write_data <= 32'b0;
            mem_en <= 0;
            mem_wen <= 0;
        end else begin
            // ���� ALU ��������Ŀ��Ĵ�����ַ
            ALU_result_out <= ALU_result_in;
            w_out <= w_in;
            
            // Ĭ������£��Ĵ���дʹ�ܸ��洫����ź�
            reg_wen_out <= reg_wen_in;
            
            // �����ڴ����
            if (data_mem_en_in) begin
                mem_en <= 1;
                mem_addr <= ALU_result_in; // ʹ�� ALU ����ĵ�ַ�����ڴ�
                if (data_mem_wen_in) begin
                    // д���ڴ�
                    mem_wen <= 1;
                    mem_write_data <= mem_write_data_in;
                    data_mem_wen_out <= 1;
                    data_mem_en_out <= 1;
                end else begin
                    // ��ȡ�ڴ�
                    mem_wen <= 0;
                    data_mem_wen_out <= 0;
                    data_mem_en_out <= 1;
                    mem_read_data_out <= mem_read_data; // ��ȡ�����ݴ������
                end
            end else begin
                // �������ڴ�
                mem_en <= 0;
                mem_wen <= 0;
                data_mem_en_out <= 0;
                data_mem_wen_out <= 0;
                mem_write_data <= 32'b0;
            end
            
            // ����Ĵ���д�����
            if (!data_mem_wen_in && !data_mem_en_in) begin
                // �Ȳ�д���ڴ棬Ҳ����ȡ�ڴ棬��ζ�� ALU ���д��Ĵ���
                reg_wen_out <= 1;
            end
        end
    end
endmodule
