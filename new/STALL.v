module StallController (
    input wire        clk,        // ʱ���ź�
    input wire        rst,        // ��λ�ź�
    input wire [31:0] instr,      // ��ǰ����׶ε�ָ��
    output reg        stall       // �Ƿ���ͣ��ˮ��
);

    // ָ�������
    localparam BEQ_OP  = 6'b000100;  // BEQ ������
    localparam BNE_OP  = 6'b000101;  // BNE ������
    localparam J_OP    = 6'b000010;  // J ������
    localparam JAL_OP  = 6'b000011;  // JAL ������
    localparam JR_OP   = 6'b000000;  // JR �����루��Ҫ��� funct �ֶΣ�

    // ����ָ���ֶ�
    wire [5:0] opcode  = instr[31:26];  // ָ��Ĳ�����
    wire [5:0] funct   = instr[5:0];    // �����루�������� JR ָ�

    // ��ⲻͬ���͵���ת�ͷ�ָ֧��
    wire is_beq   = (opcode == BEQ_OP);
    wire is_bne   = (opcode == BNE_OP);
    wire is_j     = (opcode == J_OP);
    wire is_jal   = (opcode == JAL_OP);
    wire is_jr    = (opcode == JR_OP) && (funct == 6'b001000);  // ��� funct �ֶ�

    wire is_jump  = is_j || is_jal || is_jr;   // ������תָ��
    wire is_branch = is_beq || is_bne;         // ������ָ֧��
    
    // ��¼�Ƿ�����ͣ������
    reg stall_cycle;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stall <= 0;              // ��λʱ��stall Ϊ 0
            stall_cycle <= 0;        // ��ͣ��ʱ������
        end else if (stall_cycle) begin
            stall <= 0;              // ��ͣһ�����ں�ָ�����
            stall_cycle <= 0;        // �����ͣ��־
        end else if (is_jump || is_branch) begin
            stall <= 1;              // ��⵽��ת���ָ֧���ͣһ������
            stall_cycle <= 1;        // ������ͣ��־��ȷ����ͣһ������
        end else begin
            stall <= 0;              // ��������£�����ͣ
        end
    end

endmodule
