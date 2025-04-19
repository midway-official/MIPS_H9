module alu_mux (
    input wire [31:0] mul_result,  // 乘法结果
    input wire [31:0] alu_result,         // alu结果
    input wire mul_en,            // 控制信号 mul选择
    output wire [31:0] alu_out        // 32位输出
);

assign  alu_out =mul_en?  mul_result:alu_result;
endmodule
