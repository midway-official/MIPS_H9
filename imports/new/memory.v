module DATA_MEM (
    input  wire        clka,       // 时钟输入
    input  wire        ena,        // 使能信号
    input  wire        wea,        // 写使能信号
    input  wire [31:0] addra,      // 32 位地址输入
    input  wire [31:0] dina,       // 32 位写入数据
    output reg  [31:0] douta,      // 32 位读出数据

    // 串口扩展端口
    output reg         tx_start,   // 触发发送
    output reg  [7:0]  tx_data,    // 发送数据
    input  wire        rx_ready,   // 数据接收完成标志
    input  wire [7:0]  rx_data,    // 接收到的数据
    input  wire        tx_ready    // 发送就绪信号
);

    // 2MB = 512K 个 32 位存储单元
    reg [31:0] memory [0:512];  // 内存块
    reg [31:0] special_reg;      // 用于映射 `32'h009FFFFF`

    always @(posedge clka) begin
        if (tx_start) begin
            tx_start <= 1'b0;  // 发送触发后自动清零
        end

        if (ena) begin
            // **RAM 地址范围**
            if (addra >= 32'h007FFFFF && addra < 32'h00A00000) begin
                if (wea) begin
                    memory[addra - 32'h007FFFFF] <= dina; // 写入数据
                end
                douta = memory[addra - 32'h007FFFFF]; // 读取数据

            // **额外映射地址 `32'h009FFFFF`**
            end else if (addra == 32'h009FFFFF) begin
                if (wea) begin
                    special_reg <= dina; // 写入数据
                end
                douta = special_reg; // 读取数据

            // **串口地址映射**
            end else if (addra == 32'h00900100) begin  // TXD（发送数据）
                if (wea) begin
                    tx_data  = dina[7:0];   // 低 8 位是要发送的数据
                    tx_start = 1'b1;        // 触发发送
                end
                douta <= 32'b0;
             
            end else if (addra == 32'h00900104) begin  // RXD（接收数据）
                douta = {24'b0, rx_data};  // 返回接收的数据（高位填 0）

            end else if (addra == 32'h00900108) begin  // STATUS（状态寄存器）
                douta = {30'b0, rx_ready, tx_ready};  // 状态寄存器（tx_ready 在低 0 位，rx_ready 在低 1 位）

            end else begin
                douta = 32'b0; // 非法地址返回 0
            end
        end
    end

endmodule
