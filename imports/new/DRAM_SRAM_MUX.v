module data_selector (
    input  wire [31:0] addr,          // 32λ��ַ����
    input  wire [31:0] data_in,       // 32λд������
    input  wire        mem_data_wen,  // дʹ���ź�
    output reg         pc_wen,        // ָ��洢��дʹ��
    output reg [31:0]  pc_mem_wdata,  // ָ��洢��д������
    output reg         data_mem_wen,  // ���ݴ洢��дʹ��
    output reg [31:0]  data_mem_wdata // ���ݴ洢��д������
);

    // 32KB��1024 * 32����ֵ
    localparam ADDR_THRESHOLD = 32'h007FFFFF;  // 32KB = 0x8000

    always @(*) begin
        if (addr < ADDR_THRESHOLD) begin
            // ��ַ����ָ��洢��Χ
            pc_wen        = mem_data_wen;
            pc_mem_wdata  = mem_data_wen ? data_in : 32'b0;
            data_mem_wen  = 1'b0;
            data_mem_wdata = 32'b0;
        end else begin
            // ��ַ�������ݴ洢��Χ
            pc_wen        = 1'b0;
            pc_mem_wdata  = 32'b0;
            data_mem_wen  = mem_data_wen;
            data_mem_wdata = mem_data_wen ? data_in : 32'b0;
        end
    end

endmodule
