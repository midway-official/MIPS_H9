module jump_controller (
    input wire [31:0] ALU_out,    // 32 位 ALU 计算结果
    input wire j0,                // 跳转控制信号 0
    input wire j1,                // 跳转控制信号 1
    input wire [31:0] pcp4,       // PC+4, 用于计算相对跳转
    input wire [15:0] immediate,  // 16 位立即数
    input wire [25:0] address,    // 26 位 J 型指令地址
    output reg [31:0] branch_address // 跳转地址输出
);

always @(*) begin
    case ({j1, j0})
        2'b00: branch_address = ALU_out;  // 普通 ALU 计算结果
        2'b01: begin
            // 只有当 ALU_out 不为 0 时，才计算跳转地址，否则跳转量为 0
            if (ALU_out != 32'b0) 
                branch_address = pcp4 + {{14{immediate[15]}}, immediate, 2'b00}; // PC + 4 + (sign-extend)immediate<<2
            else 
                branch_address = pcp4; // 否则，跳转量为 0，保持 pcp4
        end
      
        2'b11: branch_address = {pcp4[31:28], address, 2'b00}; // J 型跳转指令，PC 高 4 位拼接地址
        default: branch_address = pcp4; // 默认情况
    endcase
end

endmodule
