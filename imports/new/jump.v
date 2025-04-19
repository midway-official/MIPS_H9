module jump_controller (
    input wire [31:0] ALU_out,    // 32 λ ALU ������
    input wire j0,                // ��ת�����ź� 0
    input wire j1,                // ��ת�����ź� 1
    input wire [31:0] pcp4,       // PC+4, ���ڼ��������ת
    input wire [15:0] immediate,  // 16 λ������
    input wire [25:0] address,    // 26 λ J ��ָ���ַ
    output reg [31:0] branch_address // ��ת��ַ���
);

always @(*) begin
    case ({j1, j0})
        2'b00: branch_address = ALU_out;  // ��ͨ ALU ������
        2'b01: begin
            // ֻ�е� ALU_out ��Ϊ 0 ʱ���ż�����ת��ַ��������ת��Ϊ 0
            if (ALU_out != 32'b0) 
                branch_address = pcp4 + {{14{immediate[15]}}, immediate, 2'b00}; // PC + 4 + (sign-extend)immediate<<2
            else 
                branch_address = pcp4; // ������ת��Ϊ 0������ pcp4
        end
      
        2'b11: branch_address = {pcp4[31:28], address, 2'b00}; // J ����תָ�PC �� 4 λƴ�ӵ�ַ
        default: branch_address = pcp4; // Ĭ�����
    endcase
end

endmodule
