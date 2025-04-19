module uart_tx (
    input        clk,        // 50MHz 时钟
    input        rst,        // 复位信号（高复位）
    input        tx_start,   // 触发发送
    input  [7:0] tx_data,    // 发送数据
    output reg   tx,         // 串口 TX 输出
    output reg   tx_ready    // 发送完成标志
);

    parameter CLK_FREQ = 50000000;  // 时钟频率
    parameter BAUD_RATE = 9600;     // 波特率
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE; // 每个比特的周期

    reg [12:0] clk_count;   // 时钟计数
    reg [3:0] bit_index;    // 当前发送的位索引
    reg [9:0] shift_reg;    // 发送移位寄存器（包含 Start, Data, Stop 位）
    reg sending;            // 发送状态标志

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;  // 默认高电平空闲
            sending <= 0;
            tx_ready <= 1;
            clk_count <= 0;
            bit_index <= 0;
        end else begin
            if (tx_start && !sending) begin
                // 开始发送，加载数据
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
                    tx <= shift_reg[0];  // 发送当前位
                    shift_reg <= shift_reg >> 1; // 移位
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
