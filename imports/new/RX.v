module uart_rx (
    input        clk,       // 50MHz 时钟
    input        rst,       // 复位信号
    input        rx,        // 串口 RX 输入
    output reg   rx_ready,  // 数据接收完成标志
    output reg [7:0] rx_data // 接收到的数据
);

    parameter CLK_FREQ = 50000000;  // 时钟频率
    parameter BAUD_RATE = 9600;     // 波特率
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;
    parameter HALF_BIT_PERIOD = BIT_PERIOD / 2;

    reg [12:0] clk_count;  // 计数器
    reg [3:0] bit_index;   // 当前接收的位索引
    reg [7:0] shift_reg;   // 接收移位寄存器
    reg receiving;         // 是否正在接收

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            receiving <= 0;
            rx_ready <= 0;
            clk_count <= 0;
            bit_index <= 0;
        end else begin
            if (!receiving && rx == 0) begin
                // 检测到 Start Bit（下降沿），进入接收状态
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
                        shift_reg <= {rx, shift_reg[7:1]}; // 低位优先
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
