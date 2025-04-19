module ALU (
    input [31:0] A,         // ����A
    input [31:0] B,         // ����B
    input [4:0] ALUOp,      // ������
    output reg [31:0] Result // ������
    
);

 
always @(*) begin
    case (ALUOp)
        5'd1: // add (�з��żӷ�)
            Result = A + B;
        
        5'd2: // addu (�޷��żӷ�)
            Result = A + B;
        
        5'd3: // sub (�з��ż���)
            Result = A - B;
        
        5'd4: // subu (�޷��ż���)
            Result = A - B;
        
        5'd5: // and (��λ��)
            Result = A & B;
        
        5'd6: // or (��λ��)
            Result = A | B;
        
        5'd7: // xor (��λ���)
            Result = A ^ B;
        
        5'd8: // nor (��λ�ǻ�)
            Result = ~(A | B);
        
        5'd9: // slt (С�ڱȽϣ����űȽ�)
            Result = (A < B) ? 32'b1 : 32'b0;
        
        5'd10: // sltu (С�ڱȽϣ��޷��űȽ�)
            Result = (A < B) ? 32'b1 : 32'b0;
        
        // ������λ�͹̶���λ��rs ���� ͨ������ѡ�������ƽ������rt����shamt
        5'd11:  Result = B << A[4:0]; // ssl sllv (��������)
        5'd12:  Result = B >> A[4:0]; // srl srlv (�����߼�����)
        5'd13:  Result = $signed(B) >>> A[4:0]; //sra srav (������������)
        
        //���A��B
        5'd14:  Result = A;
        5'd15:  Result = B;
        
        //lui ��16λ�ŵ���16λ
        5'd16:   
             Result   =  B << 16;
             
             
        //��ȱȽ�
        5'd17:
            Result = (A == B) ? 32'b1 : 32'b0;
        //����ȱȽ�
        5'd18:
            Result = (A != B) ? 32'b1 : 32'b0;
        
           
       //������0���0
        5'd0:   //���0
             Result   = 32'b0;
             
             
        
        default:   // Ĭ����Ϊ����� 0
            Result = 32'b0;
    endcase

   
end

endmodule
