module shift_mux (
    input wire [31:0] data_in,  // 32 λ��������
    input wire [4:0] shamt,     // 5 λ��λ��
    input wire shift,           // 0: ֱ�Ӵ��� data_in, 1: ���Ϊ shamt
    output wire [31:0] data_out // 32 λ���
);

// �� shamt ��չΪ 32 λ������չ��
wire [31:0] zero_extended_shamt = {27'b0, shamt};

// ��·ѡ����
assign data_out = shift ? zero_extended_shamt : data_in;

endmodule