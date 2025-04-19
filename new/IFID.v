module IF_ID (
    input wire        clk,         // ʱ��
    input wire        rsta,        // ��λ�ź�

    // �������
    input wire        valid_in,    // IF �׶������� valid
    input wire        allow_in,    // ID �׶��Ƿ�����д��
    output reg        valid_out,   // ���ݸ� ID �׶ε� valid

    // ���ݲ���
    input wire [31:0] pc_in,       // ȡָ�׶ε� PC
    input wire [31:0] instr_in,    // ȡָ�׶ε�ָ��
    output reg [31:0] pc_out,      // ����׶ε� PC
    output reg [31:0] instr_out    // ����׶ε�ָ��
);

    // �̶� ready_go=1����ʾ������ʱ׼����
    wire ready_go;
    assign ready_go = 1'b1;

    // ���� allowin �� to_ds_valid
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
