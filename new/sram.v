module sram_wrapper (
    input  wire        clka,    // 时钟信号
    input  wire        rstb,    // 复位信号
    input  wire        wea,     // 写使能（1 位）
    input  wire [31:0] waddr,   // **写入地址**
    input  wire [31:0] dina,    // 写入数据
    input  wire [31:0] addra,   // **读取地址**
    output wire [31:0] douta    // 读取数据
);

    // SRAM IP 核的实例化
    SRAM blk_mem_inst (
        .clka(clka),     // 时钟
        .rstb(rstb),     // 复位
        .ena(1),         // 使能信号设置为 1
        .wea({4{wea}}),  // 扩展 1 位写使能为 4 位
        .addra(waddr),   // **写入地址**
        .dina(dina),     // **写入数据**
        .addrb(addra),   // **读取地址**
        .doutb(douta)    // **读取数据**
    );

endmodule
