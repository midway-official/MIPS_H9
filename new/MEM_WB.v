module MEM_WB (
    input wire clk,                    // 时钟信号
    input wire rsta,                   // 复位信号

    // 握手信号
    input wire valid_in,               // MEM阶段来的valid
    input wire allow_in,               // WB阶段是否允许写入
    output reg valid_out,              // 传递给WB阶段的valid（一般WB后就无用了，但规范保留）

    // 数据信号
    input wire [31:0] reg_w_data,      
    input wire [4:0]  w_in,            
    input wire        reg_wen_in,      
    input wire        mul_en_in,       

    output reg [31:0] reg_w_data_out,  
    output reg [4:0]  w_out,           
    output reg        reg_wen_out,     
    output reg        mul_en           
);

    // 固定 ready_go=1
    wire ready_go;
    assign ready_go = 1'b1;

    // 本阶段能否接收新数据
    wire allowin_local;
    assign allowin_local = !valid_out || (ready_go && allow_in);

    // 是否向下传递 valid（WB一般是最后一级，后面不用了，保留规范）
    wire to_wb_valid;
    assign to_wb_valid = valid_out && ready_go;

    always @(posedge clk or posedge rsta) begin
        if (rsta) begin
            valid_out        <= 1'b0;
            reg_w_data_out   <= 32'b0;
            w_out            <= 5'b0;
            reg_wen_out      <= 0;
            mul_en           <= 0;
        end else if (1) begin
            valid_out        <= valid_in;
            reg_w_data_out   <= reg_w_data;
            w_out            <= w_in;
            reg_wen_out      <= reg_wen_in;
            mul_en           <= mul_en_in;
        end
    end

endmodule