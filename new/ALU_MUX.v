module alu_mux (
    input wire [31:0] mul_result,  // �˷����
    input wire [31:0] alu_result,         // alu���
    input wire mul_en,            // �����ź� mulѡ��
    output wire [31:0] alu_out        // 32λ���
);

assign  alu_out =mul_en?  mul_result:alu_result;
endmodule
