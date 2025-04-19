module register_mux (
    input wire reg_wen,          // 寄存器写使能信号
    input wire data_mem_en,     // 数据存储器使能信号
    input wire data_mem_wen,    // 数据存储器写使能信号
    input wire [31:0] data_mem, // 32 位数据存储器输出信号
    input wire [31:0] ALU_out,  // 32 位 ALU 输出信号
    output reg [31:0] data_out  // 32 位选择输出信号
);

always @(*) begin
    if (reg_wen&& !data_mem_en) begin
        data_out = ALU_out;  // 如果 reg_wen 为 1，内存不激活，则输出 ALU 输出信号
    end else if (data_mem_en && !data_mem_wen && data_mem_en) begin
        data_out = data_mem; // 如果 data_mem_en 为 1 且 data_mem_wen 为 0，内存为读模式，则输出 data_mem 信号
    end else begin
        data_out = 32'b0;     // 默认输出 0
    end
end

endmodule
