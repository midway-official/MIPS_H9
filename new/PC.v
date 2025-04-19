module PC (
  input wire clka,               // 时钟信号
  input wire rsta,               // 复位信号
  input wire stall,              // 暂停信号，激活时保持无害指令值
  input wire branch,             // 分支信号，指示是否发生分支
  input wire [31:0] branchaddr,  // 分支目标地址
  output reg [31:0] pc           // 程序计数器（PC）值
);

  reg [31:0] pc_next;            // 下一个 PC 值，可能是分支地址或 PC+4

  // 计算下一个 PC 的值
  always @(*) begin
    if (stall) begin
      pc_next = 32'hFFFFFFFFFFFFFFFFFFFFF;  // Stall 时输出无害指令值
    end else begin
      pc_next = (branch) ? branchaddr : pc + 4;  // 发生分支则跳转，否则 PC+4
    end
  end

  // 更新 PC 值
  always @(posedge clka or posedge rsta) begin
    if (rsta) begin
      pc <= 32'h80000000;  // 复位时，PC 初始化为 0x80000000
      
    end else begin
      pc <= pc_next;  // 正常更新 PC 值或暂停时输出无害值
    end
  end

endmodule
