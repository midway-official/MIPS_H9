module PC (
  input wire clka,               // ʱ���ź�
  input wire rsta,               // ��λ�ź�
  input wire stall,              // ��ͣ�źţ�����ʱ�����޺�ָ��ֵ
  input wire branch,             // ��֧�źţ�ָʾ�Ƿ�����֧
  input wire [31:0] branchaddr,  // ��֧Ŀ���ַ
  output reg [31:0] pc           // �����������PC��ֵ
);

  reg [31:0] pc_next;            // ��һ�� PC ֵ�������Ƿ�֧��ַ�� PC+4

  // ������һ�� PC ��ֵ
  always @(*) begin
    if (stall) begin
      pc_next = 32'hFFFFFFFFFFFFFFFFFFFFF;  // Stall ʱ����޺�ָ��ֵ
    end else begin
      pc_next = (branch) ? branchaddr : pc + 4;  // ������֧����ת������ PC+4
    end
  end

  // ���� PC ֵ
  always @(posedge clka or posedge rsta) begin
    if (rsta) begin
      pc <= 32'h80000000;  // ��λʱ��PC ��ʼ��Ϊ 0x80000000
      
    end else begin
      pc <= pc_next;  // �������� PC ֵ����ͣʱ����޺�ֵ
    end
  end

endmodule
