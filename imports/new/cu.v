module CU (
    input wire [5:0] op,        // ������
    input wire [4:0] rs,        // Դ�Ĵ���
    input wire [4:0] rt,        // Ŀ��Ĵ���
    input wire [4:0] rd,        // ����Ĵ���
    input wire [5:0] func,      // ������
   
    /////////////////////////////////////////////
    
    
    output reg branch,          // �Ƿ��Ƿ�ָ֧��
    output reg j0,               //alu�����ת        
    output reg j1,               //��ת   
    
    output reg data_mem_en,     // ���ݴ洢��ʹ��
    output reg data_mem_wen,    // ���ݴ洢��дʹ��
    
    
    output reg reg_wen,         // �Ĵ���дʹ��w
    output reg [4:0] r1,        // r1�Ĵ���
    output reg [4:0] r2,        // r2�Ĵ���
    output reg [4:0] w,        // w�Ĵ���
    
    output reg [4:0] ALUop,     // ALU ��������
    output reg shift,            // �Ƿ���й̶���λ ƫ����ͨ��A����
    output reg ALUimm,            //�Ƿ������� ʹ��B����������
    output reg mul_en, //���ó˷�
    output reg byte_en //�ֽڶ�ȡ��д��
);

always @(*) begin
    // Ĭ��ֵ�������ۺϳ� latch��
    branch = 0;
    j0 = 0;
    j1 = 0;
    data_mem_en = 0;
    data_mem_wen = 0;
    reg_wen = 0;
    ALUop = 5'b00000;
    shift = 0;
    ALUimm = 0;
    r1 = 0;
    r2 = 0;
    w = 0;
  mul_en=0;
   byte_en=0;
    case (op)
        6'b000000: begin // R ��ָ��
            
            data_mem_en = 0;
            data_mem_wen = 0;
            reg_wen = 1; // R ��ָ��д�ؼĴ���
            r1=rs;
            r2=rt;
            w= rd;
            
            case (func)
                6'b100000: ALUop = 5'd1;  // ADD
                6'b100001: ALUop = 5'd2;  // ADDU
                6'b100010: ALUop = 5'd3;  // SUB
                6'b100011: ALUop = 5'd4;  // SUBU
                6'b100100: ALUop = 5'd5;  // AND
                6'b100101: ALUop = 5'd6;  // OR
                6'b100110: ALUop = 5'd7;  // XOR
                6'b100111: ALUop = 5'd8;  // NOR
                6'b101010: ALUop = 5'd9;  // SLT
                6'b101011: ALUop = 5'd10; // SLTU
                
                 // �̶���λ��shamt ���ƣ�
                  6'b000000: begin 
                 ALUop = 5'd11; // sll
                 shift = 1;
                 end
                 
               6'b000010: begin 
                  ALUop = 5'd12; // srl
                  shift = 1;
                  end
                6'b000011: begin 
                  ALUop = 5'd13; // sra
                  shift = 1;
                end
                
                // ������λ��rs ���ƣ�
                6'b000100: ALUop = 5'd11; // sllv (��������)
                6'b000110: ALUop = 5'd12; // srlv (�����߼�����)
                6'b000111: ALUop = 5'd13; // srav (�����������ƣ�
                //jr��תָ��
                6'b000111:begin  branch=1;
                                 ALUop = 5'd14;//���A�ź�
                                 j0=0;//alu��ת
                                 j1=0;//�ǵ�ַ��ת
                           end 
                default:   ALUop = 5'd0;  // Ĭ��
            endcase
        end
        
         6'b011100: begin  // mul
            data_mem_en = 0;
            data_mem_wen = 0;
            mul_en=1;
            reg_wen = 1; // R ��ָ��д�ؼĴ���
            r1=rs;
            r2=rt;
            w= rd;
            
           
        end
        //I��ָ��  
        6'b001000: begin  // addi
             r1=rs;
             r2 = 0;
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd1;  // �з��żӷ�
            ALUimm = 1;   // ʹ��������
        end

        6'b001001: begin  // addiu
             r1=rs;
             r2 = 0;
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd2;  // �޷��żӷ�
            ALUimm = 1; // ʹ��������
        end

        6'b001100: begin  // andi
              r1=rs;
              r2 = 0;
              w = rt;  
             reg_wen = 1;
            ALUop = 5'd5;  // ��λ��
            ALUimm = 1; // ʹ��������
        end

        6'b001101: begin  // ori
             r1=rs;
             r2 = 0;
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd6;  // ��λ��
            ALUimm = 1; // ʹ��������
        end

        6'b001110: begin  // xori
             r1=rs;
             w = rt; 
             r2 = 0; 
            reg_wen = 1;
            ALUop = 5'd7;  // ��λ���
            ALUimm = 1; // ʹ��������
        end
        
        6'b001111: begin  // lui
             
             w = rt;  
            reg_wen = 1;
            ALUop = 5'd16;  // ��λ���
            ALUimm = 1; // ʹ��������
        end
        
         6'b100011: begin // lw
            data_mem_en = 1;      // �������ݴ洢��
            data_mem_wen = 0;     // ��ȡ����
            reg_wen = 1;          // ��Ҫд�ؼĴ���
            r1 = rs;              // ��ַ�Ĵ���
            w = rt;               // Ŀ��Ĵ���
            ALUop = 5'd1;         // ��ַ���㣺rs + sign-extend(immediate)
            ALUimm = 1;           // ʹ����������Ϊ ALU ����
        end
        6'b100000: begin // lb
            data_mem_en = 1;      // �������ݴ洢��
            data_mem_wen = 0;     // ��ȡ����
            reg_wen = 1;          // ��Ҫд�ؼĴ���
            r1 = rs;              // ��ַ�Ĵ���
            w = rt;               // Ŀ��Ĵ���
            ALUop = 5'd1;         // ��ַ���㣺rs + sign-extend(immediate)
            ALUimm = 1;           // ʹ����������Ϊ ALU ����
            byte_en=1;
        end

        6'b101011: begin // sw
            data_mem_en = 1;      // �������ݴ洢��
            data_mem_wen = 1;     // д������
            reg_wen = 0;          // ��д��Ĵ���
            r1 = rs;              // ��ַ�Ĵ���
            r2 = rt;              // ��Ҫ�洢������
            ALUop = 5'd1;         // ��ַ���㣺rs + sign-extend(immediate)
            ALUimm = 1;           // ʹ����������Ϊ ALU ����
        end
        
         6'b101000: begin // sb
            data_mem_en = 1;      // �������ݴ洢��
            data_mem_wen = 1;     // д������
            reg_wen = 0;          // ��д��Ĵ���
            r1 = rs;              // ��ַ�Ĵ���
            r2 = rt;              // ��Ҫ�洢������
            ALUop = 5'd1;         // ��ַ���㣺rs + sign-extend(immediate)
            ALUimm = 1;           // ʹ����������Ϊ ALU ����
            byte_en=1;
        end
        
        
         6'b000100: begin // beq ָ��
            branch = 1;          // ��Ҫ��֧
            j0=1;
            j1=0;
            ALUop = 5'd17;       // ������ȱȽ�
            r1 = rs;             // ��ȡ rs
            r2 = rt;             // ��ȡ rt
        end
         6'b000111: begin // bgtz ָ��
            branch = 1;          // ��Ҫ��֧
            j0=1;
            j1=0;
            ALUop = 5'd17;       // ������ȱȽ�
            r1 = rs;             // ��ȡ rs
            r2 = rt;             // ��ȡ rt
        end
        6'b000101: begin // bne ָ��
            branch = 1;          // ��Ҫ��֧
            j0=1;
            j1=0;
            ALUop = 5'd18;       // ���в��ȱȽ�
            r1 = rs;             // ��ȡ rs
            r2 = rt;             // ��ȡ rt
        end

        6'b001010: begin // slti ָ��
            reg_wen = 1;         // ��Ҫд�ؼĴ���
            ALUop = 5'd9;       // �з���С�ڱȽ�
            r1 = rs;             // ��ȡ rs
            w = rt;              // Ŀ��Ĵ���
            ALUimm = 1;          // ����������
        end

        6'b001011: begin // sltiu ָ��
            reg_wen = 1;         // ��Ҫд�ؼĴ���
            ALUop = 5'd10;       // �޷���С�ڱȽ�
            r1 = rs;             // ��ȡ rs
            w = rt;              // Ŀ��Ĵ���
            ALUimm = 1;          // ����������
        end
       
       
       6'b000010: begin // j ָ��
            // `j` ָ���ת��ַ = {address, 2'b00}
            branch = 1;      // �Ƿ�ָ֧��
            j0=1;
            j1=1;
            reg_wen = 0;      // ����Ҫд�Ĵ���
            w = 0;            // ���漰�Ĵ���д��
        end

        6'b000011: begin // jal ָ��
            // `jal` ָ���ת��ַ = {address, 2'b00}, ���ص�ַ���浽 $31 �Ĵ���
            branch = 1;      // �Ƿ�ָ֧��
            j0=1;
            j1=1;
            reg_wen = 1;      // ��Ҫд�ؼĴ���
            w = 5'b11111;     // д�� $31 �Ĵ��� (���ص�ַ)
            r1 = 0;           // �����ȡ�Ĵ���
            r2 = 0;           // �����ȡ�Ĵ���
        end
        default: begin
            // Ĭ������£���ʹ���κο����ź�
        end
    endcase
end

endmodule
