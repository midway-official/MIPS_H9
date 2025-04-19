module shift_mux (
    input wire [31:0] data_in,  // 32 位输入数据
    input wire [4:0] shamt,     // 5 位移位量
    input wire shift,           // 0: 直接传输 data_in, 1: 输出为 shamt
    output wire [31:0] data_out // 32 位输出
);

// 将 shamt 扩展为 32 位（零扩展）
wire [31:0] zero_extended_shamt = {27'b0, shamt};

// 多路选择器
assign data_out = shift ? zero_extended_shamt : data_in;

endmodule