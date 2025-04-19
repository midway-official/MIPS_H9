module EX_MEM (
    input wire clk,                    // 时钟信号
    input wire rsta,                   // 复位信号

    // 握手信号
    input wire valid_in,               // EX阶段送来的valid
    input wire allow_in,               // MEM阶段是否允许写入
    output reg valid_out,              // 传递给MEM阶段的valid

    // 数据信号
    input wire [31:0] ALU_result_in,    
    input wire [4:0]  w_in,             
    input wire        data_mem_en_in,   
    input wire        data_mem_wen_in,  
    input wire        reg_wen_in,       
    input wire [31:0] MEM_wdat_in,      
    input wire        mul_en_in,        
    input wire        byte_en_in,       

    output reg [31:0] ALU_result_out,   
    output reg [4:0]  w_out,            
    output reg        data_mem_en_out,  
    output reg        data_mem_wen_out, 
    output reg        reg_wen_out,      
    output reg [31:0] MEM_wdat_out,     
    output reg        mul_en,           
    output reg        byte_en           
);

    // 固定 ready_go=1，表示随时 ready
    wire ready_go;
    assign ready_go = 1'b1;

    // 本阶段能否接收新数据
    wire allowin_local;
    assign allowin_local = !valid_out || (ready_go && allow_in);

    // 是否向下传递 valid
    wire to_mem_valid;
    assign to_mem_valid = valid_out && ready_go;

    always @(posedge clk or posedge rsta) begin
        if (rsta) begin
            valid_out        <= 1'b0;
            ALU_result_out   <= 32'b0;
            w_out            <= 5'b0;
            data_mem_en_out  <= 0;
            data_mem_wen_out <= 0;
            reg_wen_out      <= 0;
            MEM_wdat_out     <= 32'b0;
            mul_en           <= 0;
            byte_en          <= 0;
        end else if (1) begin
            valid_out        <= valid_in;
            ALU_result_out   <= ALU_result_in;
            w_out            <= w_in;
            data_mem_en_out  <= data_mem_en_in;
            data_mem_wen_out <= data_mem_wen_in;
            reg_wen_out      <= reg_wen_in;
            MEM_wdat_out     <= MEM_wdat_in;
            mul_en           <= mul_en_in;
            byte_en          <= byte_en_in;
        end
    end

endmodule
