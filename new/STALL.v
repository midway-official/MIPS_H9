module StallController (
    input wire        clk,        // 时钟信号
    input wire        rst,        // 复位信号
    input wire [31:0] instr,      // 当前译码阶段的指令
    output reg        stall       // 是否暂停流水线
);

    // 指令操作码
    localparam BEQ_OP  = 6'b000100;  // BEQ 操作码
    localparam BNE_OP  = 6'b000101;  // BNE 操作码
    localparam J_OP    = 6'b000010;  // J 操作码
    localparam JAL_OP  = 6'b000011;  // JAL 操作码
    localparam JR_OP   = 6'b000000;  // JR 操作码（需要检查 funct 字段）

    // 解析指令字段
    wire [5:0] opcode  = instr[31:26];  // 指令的操作码
    wire [5:0] funct   = instr[5:0];    // 功能码（用于区分 JR 指令）

    // 检测不同类型的跳转和分支指令
    wire is_beq   = (opcode == BEQ_OP);
    wire is_bne   = (opcode == BNE_OP);
    wire is_j     = (opcode == J_OP);
    wire is_jal   = (opcode == JAL_OP);
    wire is_jr    = (opcode == JR_OP) && (funct == 6'b001000);  // 检查 funct 字段

    wire is_jump  = is_j || is_jal || is_jr;   // 所有跳转指令
    wire is_branch = is_beq || is_bne;         // 条件分支指令
    
    // 记录是否在暂停周期内
    reg stall_cycle;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stall <= 0;              // 复位时，stall 为 0
            stall_cycle <= 0;        // 暂停计时器清零
        end else if (stall_cycle) begin
            stall <= 0;              // 暂停一个周期后恢复正常
            stall_cycle <= 0;        // 清除暂停标志
        end else if (is_jump || is_branch) begin
            stall <= 1;              // 检测到跳转或分支指令，暂停一个周期
            stall_cycle <= 1;        // 设置暂停标志，确保暂停一个周期
        end else begin
            stall <= 0;              // 正常情况下，无暂停
        end
    end

endmodule
