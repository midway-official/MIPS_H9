module REGISTER (
    input clk,                  // 时钟信号
    input rst,                  // 异步复位信号 (高电平有效)
    input [4:0] R1,             // 读地址1 (5位地址)
    input [4:0] R2,             // 读地址2 (5位地址)
    input [4:0] R3,              //读地址3
    input [4:0] R4,             //读地址4
    input [4:0] W,              // 写地址 (5位地址)
    input [31:0] WD,            // 写数据 (32位)
    input WE,                   // 写使能信号 (1位)
    output reg [31:0] R1_data,  // 读地址1对应的数据 (32位)
    output reg [31:0] R2_data,   // 读地址2对应的数据 (32位)
    output reg [31:0] R3_data,  // 读地址1对应的数据 (32位)
    output reg [31:0] R4_data   // 读地址2对应的数据 (32位)
);

    // 32个32位宽的寄存器堆 (32个寄存器，每个寄存器32位)
    reg [31:0] registers [31:0];  // 32个32位寄存器

    // 写入数据和复位控制 (时钟上升沿触发，带异步复位)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时清除所有寄存器
            registers[0] <= 32'b0;
            registers[1] <= 32'b0;
            registers[2] <= 32'b0;
            registers[3] <= 32'b0;
            registers[4] <= 32'b0;
            registers[5] <= 32'b0;
            registers[6] <= 32'b0;
            registers[7] <= 32'b0;
            registers[8] <= 32'b0;
            registers[9] <= 32'b0;
            registers[10] <= 32'b0;
            registers[11] <= 32'b0;
            registers[12] <= 32'b0;
            registers[13] <= 32'b0;
            registers[14] <= 32'b0;
            registers[15] <= 32'b0;
            registers[16] <= 32'b0;
            registers[17] <= 32'b0;
            registers[18] <= 32'b0;
            registers[19] <= 32'b0;
            registers[20] <= 32'b0;
            registers[21] <= 32'b0;
            registers[22] <= 32'b0;
            registers[23] <= 32'b0;
            registers[24] <= 32'b0;
            registers[25] <= 32'b0;
            registers[26] <= 32'b0;
            registers[27] <= 32'b0;
            registers[28] <= 32'b0;
            registers[29] <= 32'b0;
            registers[30] <= 32'b0;
            registers[31] <= 32'b0;
        end else if (WE && W != 5'b00000) begin
            // 如果写使能有效且写地址不为0，则执行写入操作
            registers[W] <= WD;
        end
    end

    // 读取数据 (组合逻辑)
    always @(*) begin
        // 读操作，若写地址和读地址相同且写使能有效，则绕过数据冒险，直接返回写入数据
        if (R1 == W && WE) begin
            R1_data = WD;
        end else if (R1 == 5'b00000) begin
            R1_data = 32'b0;  // R1为0时，返回32位0
        end else begin
            R1_data = registers[R1];  // 否则，读取对应的寄存器
        end

        if (R2 == W && WE) begin
            R2_data = WD;
        end else if (R2 == 5'b00000) begin
            R2_data = 32'b0;  // R2为0时，返回32位0
        end else begin
            R2_data = registers[R2];  // 否则，读取对应的寄存器
        end
        
        if (R3 == W && WE) begin
            R3_data = WD;
        end else if (R3 == 5'b00000) begin
            R3_data = 32'b0;  // R3为0时，返回32位0
        end else begin
            R3_data = registers[R3];  // 否则，读取对应的寄存器
        end

        if (R4 == W && WE) begin
            R4_data = WD;
        end else if (R4 == 5'b00000) begin
            R4_data = 32'b0;  // R2为0时，返回32位0
        end else begin
            R4_data = registers[R4];  // 否则，读取对应的寄存器
        end
        
        
    end

endmodule
