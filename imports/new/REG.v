module REGISTER (
    input clk,                  // ʱ���ź�
    input rst,                  // �첽��λ�ź� (�ߵ�ƽ��Ч)
    input [4:0] R1,             // ����ַ1 (5λ��ַ)
    input [4:0] R2,             // ����ַ2 (5λ��ַ)
    input [4:0] R3,              //����ַ3
    input [4:0] R4,             //����ַ4
    input [4:0] W,              // д��ַ (5λ��ַ)
    input [31:0] WD,            // д���� (32λ)
    input WE,                   // дʹ���ź� (1λ)
    output reg [31:0] R1_data,  // ����ַ1��Ӧ������ (32λ)
    output reg [31:0] R2_data,   // ����ַ2��Ӧ������ (32λ)
    output reg [31:0] R3_data,  // ����ַ1��Ӧ������ (32λ)
    output reg [31:0] R4_data   // ����ַ2��Ӧ������ (32λ)
);

    // 32��32λ��ļĴ����� (32���Ĵ�����ÿ���Ĵ���32λ)
    reg [31:0] registers [31:0];  // 32��32λ�Ĵ���

    // д�����ݺ͸�λ���� (ʱ�������ش��������첽��λ)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // ��λʱ������мĴ���
            registers[0] <= 32'b0;
            registers[1] <= 32'b0;
            registers[2] <= 32'b0;
            registers[3] <= 32'b0;
            registers[4] <= 32'b0;
            registers[5] <= 32'b0;
            registers[6] <= 32'b0;
            registers[7] <= 32'b0;
            registers[8] <= 32'b0;
            registers[9] <= 32'b0;
            registers[10] <= 32'b0;
            registers[11] <= 32'b0;
            registers[12] <= 32'b0;
            registers[13] <= 32'b0;
            registers[14] <= 32'b0;
            registers[15] <= 32'b0;
            registers[16] <= 32'b0;
            registers[17] <= 32'b0;
            registers[18] <= 32'b0;
            registers[19] <= 32'b0;
            registers[20] <= 32'b0;
            registers[21] <= 32'b0;
            registers[22] <= 32'b0;
            registers[23] <= 32'b0;
            registers[24] <= 32'b0;
            registers[25] <= 32'b0;
            registers[26] <= 32'b0;
            registers[27] <= 32'b0;
            registers[28] <= 32'b0;
            registers[29] <= 32'b0;
            registers[30] <= 32'b0;
            registers[31] <= 32'b0;
        end else if (WE && W != 5'b00000) begin
            // ���дʹ����Ч��д��ַ��Ϊ0����ִ��д�����
            registers[W] <= WD;
        end
    end

    // ��ȡ���� (����߼�)
    always @(*) begin
        // ����������д��ַ�Ͷ���ַ��ͬ��дʹ����Ч�����ƹ�����ð�գ�ֱ�ӷ���д������
        if (R1 == W && WE) begin
            R1_data = WD;
        end else if (R1 == 5'b00000) begin
            R1_data = 32'b0;  // R1Ϊ0ʱ������32λ0
        end else begin
            R1_data = registers[R1];  // ���򣬶�ȡ��Ӧ�ļĴ���
        end

        if (R2 == W && WE) begin
            R2_data = WD;
        end else if (R2 == 5'b00000) begin
            R2_data = 32'b0;  // R2Ϊ0ʱ������32λ0
        end else begin
            R2_data = registers[R2];  // ���򣬶�ȡ��Ӧ�ļĴ���
        end
        
        if (R3 == W && WE) begin
            R3_data = WD;
        end else if (R3 == 5'b00000) begin
            R3_data = 32'b0;  // R3Ϊ0ʱ������32λ0
        end else begin
            R3_data = registers[R3];  // ���򣬶�ȡ��Ӧ�ļĴ���
        end

        if (R4 == W && WE) begin
            R4_data = WD;
        end else if (R4 == 5'b00000) begin
            R4_data = 32'b0;  // R2Ϊ0ʱ������32λ0
        end else begin
            R4_data = registers[R4];  // ���򣬶�ȡ��Ӧ�ļĴ���
        end
        
        
    end

endmodule
