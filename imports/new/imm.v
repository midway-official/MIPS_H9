module imm_mux (
    input wire [15:0] immediate,  // 16λ������
    input wire [31:0] rs,         // 32λ�Ĵ���ֵ
    input wire ALUimm,            // �����źţ�ѡ�����������ǼĴ���ֵ
    output wire [31:0] imm        // 32λ���
);

// ��������չ��32λ��������չ��
wire [31:0] sign_extended_imm = {{16{immediate[15]}}, immediate};

// ��·ѡ����
assign imm = ALUimm ? sign_extended_imm : rs;

endmodule