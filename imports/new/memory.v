module DATA_MEM (
    input  wire        clka,       // ʱ������
    input  wire        ena,        // ʹ���ź�
    input  wire        wea,        // дʹ���ź�
    input  wire [31:0] addra,      // 32 λ��ַ����
    input  wire [31:0] dina,       // 32 λд������
    output reg  [31:0] douta,      // 32 λ��������

    // ������չ�˿�
    output reg         tx_start,   // ��������
    output reg  [7:0]  tx_data,    // ��������
    input  wire        rx_ready,   // ���ݽ�����ɱ�־
    input  wire [7:0]  rx_data,    // ���յ�������
    input  wire        tx_ready    // ���;����ź�
);

    // 2MB = 512K �� 32 λ�洢��Ԫ
    reg [31:0] memory [0:512];  // �ڴ��
    reg [31:0] special_reg;      // ����ӳ�� `32'h009FFFFF`

    always @(posedge clka) begin
        if (tx_start) begin
            tx_start <= 1'b0;  // ���ʹ������Զ�����
        end

        if (ena) begin
            // **RAM ��ַ��Χ**
            if (addra >= 32'h007FFFFF && addra < 32'h00A00000) begin
                if (wea) begin
                    memory[addra - 32'h007FFFFF] <= dina; // д������
                end
                douta = memory[addra - 32'h007FFFFF]; // ��ȡ����

            // **����ӳ���ַ `32'h009FFFFF`**
            end else if (addra == 32'h009FFFFF) begin
                if (wea) begin
                    special_reg <= dina; // д������
                end
                douta = special_reg; // ��ȡ����

            // **���ڵ�ַӳ��**
            end else if (addra == 32'h00900100) begin  // TXD���������ݣ�
                if (wea) begin
                    tx_data  = dina[7:0];   // �� 8 λ��Ҫ���͵�����
                    tx_start = 1'b1;        // ��������
                end
                douta <= 32'b0;
             
            end else if (addra == 32'h00900104) begin  // RXD���������ݣ�
                douta = {24'b0, rx_data};  // ���ؽ��յ����ݣ���λ�� 0��

            end else if (addra == 32'h00900108) begin  // STATUS��״̬�Ĵ�����
                douta = {30'b0, rx_ready, tx_ready};  // ״̬�Ĵ�����tx_ready �ڵ� 0 λ��rx_ready �ڵ� 1 λ��

            end else begin
                douta = 32'b0; // �Ƿ���ַ���� 0
            end
        end
    end

endmodule
