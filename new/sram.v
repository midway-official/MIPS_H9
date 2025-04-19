module sram_wrapper (
    input  wire        clka,    // ʱ���ź�
    input  wire        rstb,    // ��λ�ź�
    input  wire        wea,     // дʹ�ܣ�1 λ��
    input  wire [31:0] waddr,   // **д���ַ**
    input  wire [31:0] dina,    // д������
    input  wire [31:0] addra,   // **��ȡ��ַ**
    output wire [31:0] douta    // ��ȡ����
);

    // SRAM IP �˵�ʵ����
    SRAM blk_mem_inst (
        .clka(clka),     // ʱ��
        .rstb(rstb),     // ��λ
        .ena(1),         // ʹ���ź�����Ϊ 1
        .wea({4{wea}}),  // ��չ 1 λдʹ��Ϊ 4 λ
        .addra(waddr),   // **д���ַ**
        .dina(dina),     // **д������**
        .addrb(addra),   // **��ȡ��ַ**
        .doutb(douta)    // **��ȡ����**
    );

endmodule
