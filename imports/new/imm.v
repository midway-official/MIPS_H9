module imm_mux (
    input wire [15:0] immediate,  // 16位立即数
    input wire [31:0] rs,         // 32位寄存器值
    input wire ALUimm,            // 控制信号，选择立即数还是寄存器值
    output wire [31:0] imm        // 32位输出
);

// 立即数扩展到32位（符号扩展）
wire [31:0] sign_extended_imm = {{16{immediate[15]}}, immediate};

// 多路选择器
assign imm = ALUimm ? sign_extended_imm : rs;

endmodule