module data_mem_mux (
    input wire data_mem_en,      // 数据存储器使能信号
    input wire data_mem_wen,     // 数据存储器写使能信号
    input wire [31:0] data_mem_in, // 数据存储器输入数据
    output reg [31:0] data_mem_out // 数据存储器输出数据
);

always @(*) begin
    if (data_mem_en && data_mem_wen) begin
        data_mem_out = data_mem_in;  // 如果 data_mem_en 和 data_mem_wen 都为 1，则输出 data_mem_in
    end else begin
        data_mem_out = 32'b0;        // 否则输出 0
    end
end

endmodule
