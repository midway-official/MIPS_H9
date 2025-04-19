module DECODER (
    input [31:0] instruction,  // 32位指令输入
    output reg [5:0] op,       // 6位操作码
    output reg [4:0] rs,       // 5位源寄存器rs
    output reg [4:0] rt,       // 5位目标寄存器rt
    output reg [4:0] rd,       // 5位结果寄存器rd
    output reg [4:0] shamt,    // 5位移位量shamt
    output reg [5:0] func,     // 6位功能码func
    output reg [15:0] immediate, // 16位立即数
    output reg [25:0] addr     // 26位J型指令地址
);
// MIPS指令集解码器
    always @(*) begin
        if (instruction[31:26] == 6'b000000) begin
            // R型指令: 提取op, rs, rt, rd, shamt, func字段
            op = instruction[31:26];   // 提取6位操作码（R型指令的op字段始终为000000）
            rs = instruction[25:21];   // 提取5位源寄存器rs
            rt = instruction[20:16];   // 提取5位目标寄存器rt
            rd = instruction[15:11];   // 提取5位结果寄存器rd
            shamt = instruction[10:6]; // 提取5位移位量shamt
            func = instruction[5:0];   // 提取6位功能码func
            immediate = 16'b0;         // R型指令没有立即数
            addr = 26'b0;              // R型指令没有地址
        end else if (instruction[31:26] == 6'b011100) begin
            // mul指令: 提取op, rs, rt, rd, shamt, func字段
            op = instruction[31:26];   // 提取6位操作码（R型指令的op字段始终为000000）
            rs = instruction[25:21];   // 提取5位源寄存器rs
            rt = instruction[20:16];   // 提取5位目标寄存器rt
            rd = instruction[15:11];   // 提取5位结果寄存器rd
            shamt = instruction[10:6]; // 提取5位移位量shamt
            func =  6'b0;   // 提取6位功能码func
            immediate = 16'b0;;         // R型指令没有立即数
            addr = 26'b0;              // R型指令没有地址
        end else if (instruction[31:28] == 4'b0000 && (instruction[27] == 1'b1 || instruction[26] == 1'b1)) begin
            // J型指令: 提取op和地址字段
            op = instruction[31:26];   // 提取6位操作码
            addr = instruction[25:0];  // 提取26位地址字段
            rs = 5'b0;                  // J型指令没有源寄存器rs
            rt = 5'b0;                  // J型指令没有目标寄存器rt
            immediate = 16'b0;         // J型指令没有立即数
            shamt = 5'b0;               // J型指令没有移位量shamt
            func = 6'b0;                // J型指令没有功能码func
        end else begin
            // I型指令: 提取op, rs, rt, 和立即数字段
            op = instruction[31:26];   // 提取6位操作码
            rs = instruction[25:21];   // 提取5位源寄存器rs
            rt = instruction[20:16];   // 提取5位目标寄存器rt
            immediate = instruction[15:0]; // 提取16位立即数
            addr = 26'b0;              // I型指令没有地址字段
            rd = 5'b0;                 // I型指令没有结果寄存器rd
            shamt = 5'b0;              // I型指令没有移位量shamt
            func = 6'b0;               // I型指令没有功能码func
        end
    end

endmodule
