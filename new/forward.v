module forward(
    input  [4:0]  R1,        // R1 寄存器地址
    input  [4:0]  R2,        // R2 寄存器地址
    input  [31:0] R1D,       // R1 原始数据
    input  [31:0] R2D,       // R2 原始数据
    input  [4:0]  W,         // MEM阶段写回寄存器地址
    input  [31:0] final_data, // MEM阶段最终写回数据
   
    output [31:0] R1D_out,   // R1 经过旁路的数据
    output [31:0] R2D_out    // R2 经过旁路的数据
);
    
    // 如果 R1 == W 或 R1 == W1，发生数据冒险，使用最终数据替代 R1D
    assign R1D_out = (R1 == W ) ? final_data : R1D;
    
    // 如果 R2 == W 或 R2 == W1，发生数据冒险，使用最终数据替代 R2D
    assign R2D_out = (R2 == W) ? final_data :R2D;
    
endmodule
