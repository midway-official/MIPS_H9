module sram_wrapper_test (
    input  wire        clka,    // 时钟信号
    input  wire        rstb,    // 复位信号
    input  wire        wea,     // 写使能（不使用）
    input  wire [31:0] waddr,   // 写入地址（不使用）
    input  wire [31:0] dina,    // 写入数据（不使用）
    input  wire [31:0] addra,   // 读取地址
    output reg  [31:0] douta    // 读取数据
);

    // 定义一个简单的 32-bit 地址深度为 8 的 SRAM
    reg [31:0] sram_mem [0:7];  // 存储器有 8 个位置

    // 初始化存储器（根据给定的初始化向量）
    initial begin
        sram_mem[0] = 32'b00111100000010000000000000000000;
        sram_mem[1] = 32'b00100001000010000000000000000101;
        sram_mem[2] = 32'b00111100000010010000000000000000;
        sram_mem[3] = 32'b00100001001001000000000000001010;
        sram_mem[4] = 32'b00000001000010010101000001000000;
        sram_mem[5] = 32'b00111100000010110000100111110000;
        sram_mem[6] = 32'b00100001011010111111111111111111;
        sram_mem[7] = 32'b10101101011010000000000000000000;
    end

    // 读取操作（仅基于 addra 进行读取）
    always @(*) begin
        douta = sram_mem[addra[2:0]];  // 地址取低3位用于选择存储器中的位置
    end

endmodule
