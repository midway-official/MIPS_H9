module ALU (
    input [31:0] A,         // 输入A
    input [31:0] B,         // 输入B
    input [4:0] ALUOp,      // 操作码
    output reg [31:0] Result // 输出结果
    
);

 
always @(*) begin
    case (ALUOp)
        5'd1: // add (有符号加法)
            Result = A + B;
        
        5'd2: // addu (无符号加法)
            Result = A + B;
        
        5'd3: // sub (有符号减法)
            Result = A - B;
        
        5'd4: // subu (无符号减法)
            Result = A - B;
        
        5'd5: // and (按位与)
            Result = A & B;
        
        5'd6: // or (按位或)
            Result = A | B;
        
        5'd7: // xor (按位异或)
            Result = A ^ B;
        
        5'd8: // nor (按位非或)
            Result = ~(A | B);
        
        5'd9: // slt (小于比较，符号比较)
            Result = (A < B) ? 32'b1 : 32'b0;
        
        5'd10: // sltu (小于比较，无符号比较)
            Result = (A < B) ? 32'b1 : 32'b0;
        
        // 变量移位和固定移位：rs 控制 通过数据选择器控制进入的是rt还是shamt
        5'd11:  Result = B << A[4:0]; // ssl sllv (变量左移)
        5'd12:  Result = B >> A[4:0]; // srl srlv (变量逻辑右移)
        5'd13:  Result = $signed(B) >>> A[4:0]; //sra srav (变量算术右移)
        
        //输出A或B
        5'd14:  Result = A;
        5'd15:  Result = B;
        
        //lui 低16位放到高16位
        5'd16:   
             Result   =  B << 16;
             
             
        //相等比较
        5'd17:
            Result = (A == B) ? 32'b1 : 32'b0;
        //不相等比较
        5'd18:
            Result = (A != B) ? 32'b1 : 32'b0;
        
           
       //操作码0输出0
        5'd0:   //输出0
             Result   = 32'b0;
             
             
        
        default:   // 默认行为：输出 0
            Result = 32'b0;
    endcase

   
end

endmodule
