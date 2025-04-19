module IF_ID (
    input wire        clk,         // 时钟
    input wire        rsta,        // 复位信号

    // 握手相关
    input wire        valid_in,    // IF 阶段送来的 valid
    input wire        allow_in,    // ID 阶段是否允许写入
    output reg        valid_out,   // 传递给 ID 阶段的 valid

    // 数据部分
    input wire [31:0] pc_in,       // 取指阶段的 PC
    input wire [31:0] instr_in,    // 取指阶段的指令
    output reg [31:0] pc_out,      // 译码阶段的 PC
    output reg [31:0] instr_out    // 译码阶段的指令
);

    // 固定 ready_go=1，表示本级随时准备好
    wire ready_go;
    assign ready_go = 1'b1;

    // 计算 allowin 和 to_ds_valid
    wire allowin;
    assign allowin = !valid_out || (ready_go && allow_in);
    wire to_ds_valid;
    assign to_ds_valid = valid_out && ready_go;

    always @(posedge clk or posedge rsta) begin
        if (rsta) begin
            valid_out <= 1'b0;
            pc_out    <= 32'h00000000;
            instr_out <= 32'b0;
        end 
        else if (1) begin
            valid_out <= valid_in;
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end

endmodule
