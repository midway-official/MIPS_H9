module forward(
    input  [4:0]  R1,        // R1 �Ĵ�����ַ
    input  [4:0]  R2,        // R2 �Ĵ�����ַ
    input  [31:0] R1D,       // R1 ԭʼ����
    input  [31:0] R2D,       // R2 ԭʼ����
    input  [4:0]  W,         // MEM�׶�д�ؼĴ�����ַ
    input  [31:0] final_data, // MEM�׶�����д������
   
    output [31:0] R1D_out,   // R1 ������·������
    output [31:0] R2D_out    // R2 ������·������
);
    
    // ��� R1 == W �� R1 == W1����������ð�գ�ʹ������������� R1D
    assign R1D_out = (R1 == W ) ? final_data : R1D;
    
    // ��� R2 == W �� R2 == W1����������ð�գ�ʹ������������� R2D
    assign R2D_out = (R2 == W) ? final_data :R2D;
    
endmodule
