module uart_rx (
    input        clk,       // 50MHz ʱ��
    input        rst,       // ��λ�ź�
    input        rx,        // ���� RX ����
    output reg   rx_ready,  // ���ݽ�����ɱ�־
    output reg [7:0] rx_data // ���յ�������
);

    parameter CLK_FREQ = 50000000;  // ʱ��Ƶ��
    parameter BAUD_RATE = 9600;     // ������
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;
    parameter HALF_BIT_PERIOD = BIT_PERIOD / 2;

    reg [12:0] clk_count;  // ������
    reg [3:0] bit_index;   // ��ǰ���յ�λ����
    reg [7:0] shift_reg;   // ������λ�Ĵ���
    reg receiving;         // �Ƿ����ڽ���

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            receiving <= 0;
            rx_ready <= 0;
            clk_count <= 0;
            bit_index <= 0;
        end else begin
            if (!receiving && rx == 0) begin
                // ��⵽ Start Bit���½��أ����������״̬
                receiving <= 1;
                clk_count <= HALF_BIT_PERIOD;
                bit_index <= 0;
            end

            if (receiving) begin
                if (clk_count < BIT_PERIOD - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;

                    if (bit_index < 8) begin
                        shift_reg <= {rx, shift_reg[7:1]}; // ��λ����
                        bit_index <= bit_index + 1;
                    end else begin
                        rx_ready <= 1;
                        receiving <= 0;
                        rx_data <= shift_reg;
                    end
                end
            end
        end
    end
endmodule
