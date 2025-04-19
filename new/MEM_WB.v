module MEM_WB (
    input wire clk,                    // ʱ���ź�
    input wire rsta,                   // ��λ�ź�

    // �����ź�
    input wire valid_in,               // MEM�׶�����valid
    input wire allow_in,               // WB�׶��Ƿ�����д��
    output reg valid_out,              // ���ݸ�WB�׶ε�valid��һ��WB��������ˣ����淶������

    // �����ź�
    input wire [31:0] reg_w_data,      
    input wire [4:0]  w_in,            
    input wire        reg_wen_in,      
    input wire        mul_en_in,       

    output reg [31:0] reg_w_data_out,  
    output reg [4:0]  w_out,           
    output reg        reg_wen_out,     
    output reg        mul_en           
);

    // �̶� ready_go=1
    wire ready_go;
    assign ready_go = 1'b1;

    // ���׶��ܷ����������
    wire allowin_local;
    assign allowin_local = !valid_out || (ready_go && allow_in);

    // �Ƿ����´��� valid��WBһ�������һ�������治���ˣ������淶��
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