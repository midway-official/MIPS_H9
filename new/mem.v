module MEM (
    input wire clk,                    // 时钟信号
    input wire reset,                  // 复位信号
    
    // 从 EX/MEM 传入的数据
    input wire [31:0] ALU_result_in,    // EX 阶段的 ALU 计算结果（用于地址计算）
    input wire [4:0] w_in,              // EX 阶段的目标寄存器地址
    input wire data_mem_en_in,          // 内存访问使能
    input wire data_mem_wen_in,         // 内存写使能
    input wire reg_wen_in,              // EX 阶段的寄存器写使能
    input wire [31:0] mem_write_data_in,// 内存写入的数据
    
    // 连接数据存储器
    output reg [31:0] mem_addr,         // 内存地址
    output reg [31:0] mem_write_data,   // 内存写入数据
    output reg mem_en,                  // 内存访问使能
    output reg mem_wen,                 // 内存写使能
    input wire [31:0] mem_read_data,    // 内存读取的数据（从存储器返回）

    // 传递到 MEM/WB
    output reg [31:0] ALU_result_out,   // 传递 ALU 计算结果
    output reg [4:0] w_out,             // 目标寄存器地址
    output reg data_mem_en_out,         // 内存访问使能
    output reg data_mem_wen_out,        // 内存写使能
    output reg reg_wen_out,             // 传递寄存器写使能
    output reg [31:0] mem_read_data_out // 读取的内存数据（如果是 LW 指令）
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 复位时清零所有信号
            ALU_result_out <= 32'b0;
            w_out <= 5'b0;
            data_mem_en_out <= 0;
            data_mem_wen_out <= 0;
            reg_wen_out <= 0;
            mem_read_data_out <= 32'b0;

            mem_addr <= 32'b0;
            mem_write_data <= 32'b0;
            mem_en <= 0;
            mem_wen <= 0;
        end else begin
            // 传递 ALU 计算结果和目标寄存器地址
            ALU_result_out <= ALU_result_in;
            w_out <= w_in;
            
            // 默认情况下，寄存器写使能跟随传入的信号
            reg_wen_out <= reg_wen_in;
            
            // 处理内存访问
            if (data_mem_en_in) begin
                mem_en <= 1;
                mem_addr <= ALU_result_in; // 使用 ALU 计算的地址访问内存
                if (data_mem_wen_in) begin
                    // 写入内存
                    mem_wen <= 1;
                    mem_write_data <= mem_write_data_in;
                    data_mem_wen_out <= 1;
                    data_mem_en_out <= 1;
                end else begin
                    // 读取内存
                    mem_wen <= 0;
                    data_mem_wen_out <= 0;
                    data_mem_en_out <= 1;
                    mem_read_data_out <= mem_read_data; // 读取的数据存入输出
                end
            end else begin
                // 不访问内存
                mem_en <= 0;
                mem_wen <= 0;
                data_mem_en_out <= 0;
                data_mem_wen_out <= 0;
                mem_write_data <= 32'b0;
            end
            
            // 处理寄存器写入情况
            if (!data_mem_wen_in && !data_mem_en_in) begin
                // 既不写入内存，也不读取内存，意味着 ALU 结果写入寄存器
                reg_wen_out <= 1;
            end
        end
    end
endmodule
