module DECODER (
    input [31:0] instruction,  // 32λָ������
    output reg [5:0] op,       // 6λ������
    output reg [4:0] rs,       // 5λԴ�Ĵ���rs
    output reg [4:0] rt,       // 5λĿ��Ĵ���rt
    output reg [4:0] rd,       // 5λ����Ĵ���rd
    output reg [4:0] shamt,    // 5λ��λ��shamt
    output reg [5:0] func,     // 6λ������func
    output reg [15:0] immediate, // 16λ������
    output reg [25:0] addr     // 26λJ��ָ���ַ
);
// MIPSָ�������
    always @(*) begin
        if (instruction[31:26] == 6'b000000) begin
            // R��ָ��: ��ȡop, rs, rt, rd, shamt, func�ֶ�
            op = instruction[31:26];   // ��ȡ6λ�����루R��ָ���op�ֶ�ʼ��Ϊ000000��
            rs = instruction[25:21];   // ��ȡ5λԴ�Ĵ���rs
            rt = instruction[20:16];   // ��ȡ5λĿ��Ĵ���rt
            rd = instruction[15:11];   // ��ȡ5λ����Ĵ���rd
            shamt = instruction[10:6]; // ��ȡ5λ��λ��shamt
            func = instruction[5:0];   // ��ȡ6λ������func
            immediate = 16'b0;         // R��ָ��û��������
            addr = 26'b0;              // R��ָ��û�е�ַ
        end else if (instruction[31:26] == 6'b011100) begin
            // mulָ��: ��ȡop, rs, rt, rd, shamt, func�ֶ�
            op = instruction[31:26];   // ��ȡ6λ�����루R��ָ���op�ֶ�ʼ��Ϊ000000��
            rs = instruction[25:21];   // ��ȡ5λԴ�Ĵ���rs
            rt = instruction[20:16];   // ��ȡ5λĿ��Ĵ���rt
            rd = instruction[15:11];   // ��ȡ5λ����Ĵ���rd
            shamt = instruction[10:6]; // ��ȡ5λ��λ��shamt
            func =  6'b0;   // ��ȡ6λ������func
            immediate = 16'b0;;         // R��ָ��û��������
            addr = 26'b0;              // R��ָ��û�е�ַ
        end else if (instruction[31:28] == 4'b0000 && (instruction[27] == 1'b1 || instruction[26] == 1'b1)) begin
            // J��ָ��: ��ȡop�͵�ַ�ֶ�
            op = instruction[31:26];   // ��ȡ6λ������
            addr = instruction[25:0];  // ��ȡ26λ��ַ�ֶ�
            rs = 5'b0;                  // J��ָ��û��Դ�Ĵ���rs
            rt = 5'b0;                  // J��ָ��û��Ŀ��Ĵ���rt
            immediate = 16'b0;         // J��ָ��û��������
            shamt = 5'b0;               // J��ָ��û����λ��shamt
            func = 6'b0;                // J��ָ��û�й�����func
        end else begin
            // I��ָ��: ��ȡop, rs, rt, ���������ֶ�
            op = instruction[31:26];   // ��ȡ6λ������
            rs = instruction[25:21];   // ��ȡ5λԴ�Ĵ���rs
            rt = instruction[20:16];   // ��ȡ5λĿ��Ĵ���rt
            immediate = instruction[15:0]; // ��ȡ16λ������
            addr = 26'b0;              // I��ָ��û�е�ַ�ֶ�
            rd = 5'b0;                 // I��ָ��û�н���Ĵ���rd
            shamt = 5'b0;              // I��ָ��û����λ��shamt
            func = 6'b0;               // I��ָ��û�й�����func
        end
    end

endmodule
