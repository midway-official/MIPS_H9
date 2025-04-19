module data_selector (
    input  wire [31:0] addr,          // 32位地址输入
    input  wire [31:0] data_in,       // 32位写入数据
    input  wire        mem_data_wen,  // 写使能信号
    output reg         pc_wen,        // 指令存储器写使能
    output reg [31:0]  pc_mem_wdata,  // 指令存储器写入数据
    output reg         data_mem_wen,  // 数据存储器写使能
    output reg [31:0]  data_mem_wdata // 数据存储器写入数据
);

    // 32KB（1024 * 32）阈值
    localparam ADDR_THRESHOLD = 32'h007FFFFF;  // 32KB = 0x8000

    always @(*) begin
        if (addr < ADDR_THRESHOLD) begin
            // 地址属于指令存储范围
            pc_wen        = mem_data_wen;
            pc_mem_wdata  = mem_data_wen ? data_in : 32'b0;
            data_mem_wen  = 1'b0;
            data_mem_wdata = 32'b0;
        end else begin
            // 地址属于数据存储范围
            pc_wen        = 1'b0;
            pc_mem_wdata  = 32'b0;
            data_mem_wen  = mem_data_wen;
            data_mem_wdata = mem_data_wen ? data_in : 32'b0;
        end
    end

endmodule
