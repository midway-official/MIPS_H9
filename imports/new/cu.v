module CU (
    input wire [5:0] op,        // 操作码
    input wire [4:0] rs,        // 源寄存器
    input wire [4:0] rt,        // 目标寄存器
    input wire [4:0] rd,        // 结果寄存器
    input wire [5:0] func,      // 功能码
   
    /////////////////////////////////////////////
    
    
    output reg branch,          // 是否是分支指令
    output reg j0,               //alu输出跳转        
    output reg j1,               //跳转   
    
    output reg data_mem_en,     // 数据存储器使能
    output reg data_mem_wen,    // 数据存储器写使能
    
    
    output reg reg_wen,         // 寄存器写使能w
    output reg [4:0] r1,        // r1寄存器
    output reg [4:0] r2,        // r2寄存器
    output reg [4:0] w,        // w寄存器
    
    output reg [4:0] ALUop,     // ALU 操作类型
    output reg shift,            // 是否进行固定移位 偏移量通过A送入
    output reg ALUimm,            //是否立即数 使用B立即数送入
    output reg mul_en, //启用乘法
    output reg byte_en //字节读取或写入
);

always @(*) begin
    // 默认值（避免综合出 latch）
    branch = 0;
    j0 = 0;
    j1 = 0;
    data_mem_en = 0;
    data_mem_wen = 0;
    reg_wen = 0;
    ALUop = 5'b00000;
    shift = 0;
    ALUimm = 0;
    r1 = 0;
    r2 = 0;
    w = 0;
  mul_en=0;
   byte_en=0;
    case (op)
        6'b000000: begin // R 型指令
            
            data_mem_en = 0;
            data_mem_wen = 0;
            reg_wen = 1; // R 型指令写回寄存器
            r1=rs;
            r2=rt;
            w= rd;
            
            case (func)
                6'b100000: ALUop = 5'd1;  // ADD
                6'b100001: ALUop = 5'd2;  // ADDU
                6'b100010: ALUop = 5'd3;  // SUB
                6'b100011: ALUop = 5'd4;  // SUBU
                6'b100100: ALUop = 5'd5;  // AND
                6'b100101: ALUop = 5'd6;  // OR
                6'b100110: ALUop = 5'd7;  // XOR
                6'b100111: ALUop = 5'd8;  // NOR
                6'b101010: ALUop = 5'd9;  // SLT
                6'b101011: ALUop = 5'd10; // SLTU
                
                 // 固定移位（shamt 控制）
                  6'b000000: begin 
                 ALUop = 5'd11; // sll
                 shift = 1;
                 end
                 
               6'b000010: begin 
                  ALUop = 5'd12; // srl
                  shift = 1;
                  end
                6'b000011: begin 
                  ALUop = 5'd13; // sra
                  shift = 1;
                end
                
                // 变量移位（rs 控制）
                6'b000100: ALUop = 5'd11; // sllv (变量左移)
                6'b000110: ALUop = 5'd12; // srlv (变量逻辑右移)
                6'b000111: ALUop = 5'd13; // srav (变量算术右移）
                //jr跳转指令
                6'b000111:begin  branch=1;
                                 ALUop = 5'd14;//输出A信号
                                 j0=0;//alu跳转
                                 j1=0;//非地址跳转
                           end 
                default:   ALUop = 5'd0;  // 默认
            endcase
        end
        
         6'b011100: begin  // mul
            data_mem_en = 0;
            data_mem_wen = 0;
            mul_en=1;
            reg_wen = 1; // R 型指令写回寄存器
            r1=rs;
            r2=rt;
            w= rd;
            
           
        end
        //I型指令  
        6'b001000: begin  // addi
             r1=rs;
             r2 = 0;
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd1;  // 有符号加法
            ALUimm = 1;   // 使用立即数
        end

        6'b001001: begin  // addiu
             r1=rs;
             r2 = 0;
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd2;  // 无符号加法
            ALUimm = 1; // 使用立即数
        end

        6'b001100: begin  // andi
              r1=rs;
              r2 = 0;
              w = rt;  
             reg_wen = 1;
            ALUop = 5'd5;  // 按位与
            ALUimm = 1; // 使用立即数
        end

        6'b001101: begin  // ori
             r1=rs;
             r2 = 0;
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd6;  // 按位或
            ALUimm = 1; // 使用立即数
        end

        6'b001110: begin  // xori
             r1=rs;
             w = rt; 
             r2 = 0; 
            reg_wen = 1;
            ALUop = 5'd7;  // 按位异或
            ALUimm = 1; // 使用立即数
        end
        
        6'b001111: begin  // lui
             
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd16;  // 按位异或
            ALUimm = 1; // 使用立即数
        end
        
         6'b100011: begin // lw
            data_mem_en = 1;      // 启用数据存储器
            data_mem_wen = 0;     // 读取数据
            reg_wen = 1;          // 需要写回寄存器
            r1 = rs;              // 基址寄存器
            w = rt;               // 目标寄存器
            ALUop = 5'd1;         // 地址计算：rs + sign-extend(immediate)
            ALUimm = 1;           // 使用立即数作为 ALU 输入
        end
        6'b100000: begin // lb
            data_mem_en = 1;      // 启用数据存储器
            data_mem_wen = 0;     // 读取数据
            reg_wen = 1;          // 需要写回寄存器
            r1 = rs;              // 基址寄存器
            w = rt;               // 目标寄存器
            ALUop = 5'd1;         // 地址计算：rs + sign-extend(immediate)
            ALUimm = 1;           // 使用立即数作为 ALU 输入
            byte_en=1;
        end

        6'b101011: begin // sw
            data_mem_en = 1;      // 启用数据存储器
            data_mem_wen = 1;     // 写入数据
            reg_wen = 0;          // 不写入寄存器
            r1 = rs;              // 基址寄存器
            r2 = rt;              // 需要存储的数据
            ALUop = 5'd1;         // 地址计算：rs + sign-extend(immediate)
            ALUimm = 1;           // 使用立即数作为 ALU 输入
        end
        
         6'b101000: begin // sb
            data_mem_en = 1;      // 启用数据存储器
            data_mem_wen = 1;     // 写入数据
            reg_wen = 0;          // 不写入寄存器
            r1 = rs;              // 基址寄存器
            r2 = rt;              // 需要存储的数据
            ALUop = 5'd1;         // 地址计算：rs + sign-extend(immediate)
            ALUimm = 1;           // 使用立即数作为 ALU 输入
            byte_en=1;
        end
        
        
         6'b000100: begin // beq 指令
            branch = 1;          // 需要分支
            j0=1;
            j1=0;
            ALUop = 5'd17;       // 进行相等比较
            r1 = rs;             // 读取 rs
            r2 = rt;             // 读取 rt
        end
         6'b000111: begin // bgtz 指令
            branch = 1;          // 需要分支
            j0=1;
            j1=0;
            ALUop = 5'd17;       // 进行相等比较
            r1 = rs;             // 读取 rs
            r2 = rt;             // 读取 rt
        end
        6'b000101: begin // bne 指令
            branch = 1;          // 需要分支
            j0=1;
            j1=0;
            ALUop = 5'd18;       // 进行不等比较
            r1 = rs;             // 读取 rs
            r2 = rt;             // 读取 rt
        end

        6'b001010: begin // slti 指令
            reg_wen = 1;         // 需要写回寄存器
            ALUop = 5'd9;       // 有符号小于比较
            r1 = rs;             // 读取 rs
            w = rt;              // 目标寄存器
            ALUimm = 1;          // 立即数输入
        end

        6'b001011: begin // sltiu 指令
            reg_wen = 1;         // 需要写回寄存器
            ALUop = 5'd10;       // 无符号小于比较
            r1 = rs;             // 读取 rs
            w = rt;              // 目标寄存器
            ALUimm = 1;          // 立即数输入
        end
       
       
       6'b000010: begin // j 指令
            // `j` 指令：跳转地址 = {address, 2'b00}
            branch = 1;      // 非分支指令
            j0=1;
            j1=1;
            reg_wen = 0;      // 不需要写寄存器
            w = 0;            // 不涉及寄存器写入
        end

        6'b000011: begin // jal 指令
            // `jal` 指令：跳转地址 = {address, 2'b00}, 返回地址保存到 $31 寄存器
            branch = 1;      // 非分支指令
            j0=1;
            j1=1;
            reg_wen = 1;      // 需要写回寄存器
            w = 5'b11111;     // 写入 $31 寄存器 (返回地址)
            r1 = 0;           // 无需读取寄存器
            r2 = 0;           // 无需读取寄存器
        end
        default: begin
            // 默认情况下，不使能任何控制信号
        end
    endcase
end

endmodule
