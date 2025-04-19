module ID_EX (
    input wire clk,                  // 时钟信号
    input wire rsta,                 // 复位信号

    // 握手相关信号
    input wire valid_in,             // ID阶段送来的valid
    input wire allow_in,             // EX阶段是否允许写入
    output reg valid_out,            // 传递给EX阶段的valid

    // 控制信号与数据
    input wire data_mem_en_in,       
    input wire data_mem_wen_in,      
    input wire reg_wen_in,           
    input wire [4:0] r1_in,          
    input wire [4:0] r2_in,          
    input wire [4:0] w_in,           
    input wire [4:0] ALUop_in,       
    input wire shift_in,             
    input wire ALUimm_in,            
    input wire [4:0] shamt_in,       
    input wire [15:0] immediate_in,  
    input wire mul_en_in,            
    input wire byte_en_in,           

    output reg data_mem_en,          
    output reg data_mem_wen,         
    output reg reg_wen,              
    output reg [4:0] r1,             
    output reg [4:0] r2,             
    output reg [4:0] w,              
    output reg [4:0] ALUop,          
    output reg shift,                
    output reg ALUimm,               
    output reg [4:0] shamt,          
    output reg [15:0] immediate,     
    output reg mul_en,               
    output reg byte_en               
);

    // 固定 ready_go=1，表示本级随时准备好
    wire ready_go;
    assign ready_go = 1'b1;

    // 计算 allowin 和 to_ex_valid
    wire allowin_local;
    assign allowin_local = !valid_out || (ready_go && allow_in);
    wire to_ex_valid;
    assign to_ex_valid = valid_out && ready_go;

    always @(posedge clk or posedge rsta) begin
        if (rsta) begin
            valid_out <= 1'b0;
            data_mem_en <= 0;
            data_mem_wen <= 0;
            reg_wen <= 0;
            r1 <= 0;
            r2 <= 0;
            w <= 0;
            ALUop <= 0;
            shift <= 0;
            ALUimm <= 0;
            shamt <= 0;
            immediate <= 0;
            mul_en <= 0;
            byte_en <= 0;
        end else if (1) begin
            valid_out <= valid_in;
            data_mem_en <= data_mem_en_in;
            data_mem_wen <= data_mem_wen_in;
            reg_wen <= reg_wen_in;
            r1 <= r1_in;
            r2 <= r2_in;
            w <= w_in;
            ALUop <= ALUop_in;
            shift <= shift_in;
            ALUimm <= ALUimm_in;
            shamt <= shamt_in;
            immediate <= immediate_in;
            mul_en <= mul_en_in;
            byte_en <= byte_en_in;
        end
    end

endmodule
