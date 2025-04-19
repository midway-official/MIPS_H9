module Comparator (
    input  wire        mem_wen,    // 内存写使能 (1 = 写, 0 = 读)
    input  wire        mem_en,     // 内存使能 (1 = 访问内存, 0 = 不访问)
    input  wire [31:0] ALUresult,  // ALU 计算结果
    input  wire [31:0] mem_out,    // 内存读取的数据
    output wire [31:0] final_result // 最终输出
);

    // 判断逻辑：
    // 如果 mem_en 为 1 且 mem_wen 为 0，则选择 mem_out（从内存读取的数据）
    // 否则，选择 ALUresult（默认情况）
    assign final_result = (mem_en && ~mem_wen) ? mem_out : ALUresult;

endmodule
