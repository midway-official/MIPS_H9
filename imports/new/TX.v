module uart_tx (
    input        clk,        // 50MHz ʱ��
    input        rst,        // ��λ�źţ��߸�λ��
    input        tx_start,   // ��������
    input  [7:0] tx_data,    // ��������
    output reg   tx,         // ���� TX ���
    output reg   tx_ready    // ������ɱ�־
);

    parameter CLK_FREQ = 50000000;  // ʱ��Ƶ��
    parameter BAUD_RATE = 9600;     // ������
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE; // ÿ�����ص�����

    reg [12:0] clk_count;   // ʱ�Ӽ���
    reg [3:0] bit_index;    // ��ǰ���͵�λ����
    reg [9:0] shift_reg;    // ������λ�Ĵ��������� Start, Data, Stop λ��
    reg sending;            // ����״̬��־

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;  // Ĭ�ϸߵ�ƽ����
            sending <= 0;
            tx_ready <= 1;
            clk_count <= 0;
            bit_index <= 0;
        end else begin
            if (tx_start && !sending) begin
                // ��ʼ���ͣ���������
                shift_reg <= {1'b1, tx_data, 1'b0}; // Stop(1) + Data + Start(0)
                sending <= 1;
                tx_ready <= 0;
                clk_count <= 0;
                bit_index <= 0;
            end

            if (sending) begin
                if (clk_count < BIT_PERIOD - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    tx <= shift_reg[0];  // ���͵�ǰλ
                    shift_reg <= shift_reg >> 1; // ��λ
                    bit_index <= bit_index + 1;

                    if (bit_index == 9) begin
                        sending <= 0;
                        tx_ready <= 1;
                    end
                end
            end
        end
    end
endmodule
