module write_back_cache #(
    parameter CACHE_SIZE = 4,
    parameter BLOCK_SIZE = 32,
    parameter ADDR_WIDTH = 32
)(
    input clk,
    input rst,
    input [ADDR_WIDTH-1:0] addr,
    input [BLOCK_SIZE-1:0] write_data,
    input cache_en,
    input cache_wen,
    input byte_en,
    output reg [BLOCK_SIZE-1:0] read_data,
    output reg hit,
    output reg dirty,
    output reg stall,

    output reg [ADDR_WIDTH-1:0] data_ram_addr,
    output reg [BLOCK_SIZE-1:0] ram_w_out,
    input [BLOCK_SIZE-1:0] data_ram_in,
    output reg en,
    output reg wen,
    output reg byte_en_out
);

    // ����ṹ
    reg [BLOCK_SIZE-1:0] cache [0:CACHE_SIZE-1];
    reg [ADDR_WIDTH-$clog2(CACHE_SIZE)-1:0] tag [0:CACHE_SIZE-1];
    reg valid [0:CACHE_SIZE-1];
    reg dirty_bit [0:CACHE_SIZE-1];

    // ��ַ���
    wire [$clog2(CACHE_SIZE)-1:0] index = addr[$clog2(CACHE_SIZE)+1:2];
    wire [ADDR_WIDTH-$clog2(CACHE_SIZE)-1:0] tag_in = addr[ADDR_WIDTH-1:$clog2(CACHE_SIZE)+2];

    // ״̬����
    reg [1:0] state;
    localparam IDLE      = 2'd0,
               WRITEBACK = 2'd1,
               LOAD      = 2'd2;

    // �����Ĵ���
    reg [BLOCK_SIZE-1:0] pending_write_data;
    reg pending_write;
    reg pending_byte_en;
    reg [ADDR_WIDTH-1:0] evict_addr;

    integer i;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < CACHE_SIZE; i = i + 1) begin
            valid[i] <= 0;
            dirty_bit[i] <= 0;
            cache[i] <= 0;
            tag[i] <= 0;
        end
        hit <= 0;
        dirty <= 0;
        stall <= 0;
        en <= 0;
        wen <= 0;
        byte_en_out <= 0;
        ram_w_out <= 0;
        data_ram_addr <= 0;
        read_data <= 0;
        state <= IDLE;
        pending_write <= 0;
    end else begin
        hit <= 0;
        dirty <= 0;
        stall <= 0;
        en <= 0;
        wen <= 0;

        case (state)
            IDLE: begin
                if (cache_en) begin
                    if (valid[index] && tag[index] == tag_in) begin
                        // ����
                        hit = 1;
                        dirty = dirty_bit[index];
                        if (cache_wen) begin
                            // д���� ���ͷ����
                            cache[index] = write_data;
                            dirty_bit[index] = 1;
                        end else begin
                            // ������ ��������������
                            read_data = cache[index];
                        end
                    end else begin
                        // δ����
                        if (valid[index] && dirty_bit[index]) begin
                            // ����滻����д��
                            stall <= 1;
                            en = 1;
                            wen = 1;
                            data_ram_addr = {tag[index], index, 2'b00};
                            ram_w_out = cache[index];
                            byte_en_out = 1'b1;
                            valid[index] = 0;  // ����Ϊ��Ч����ʾ�û����б��滻
                            // ���漴��д������ݣ���load��д��
                            pending_write <= cache_wen;
                            pending_write_data <= write_data;
                            pending_byte_en <= byte_en;
                            evict_addr <= {tag[index], index, 2'b00};

                            state <= WRITEBACK;
                        end else begin
                            // �ɾ�����Ч�飬ֱ�ӷ�������
                            stall <= 1;
                            en = 1;
                            wen = 0;
                            data_ram_addr = addr;
                            byte_en_out = 1'b1;

                            if (cache_wen) begin
                                pending_write <= 1;
                                pending_write_data <= write_data;
                                pending_byte_en <= byte_en;
                            end else begin
                                pending_write <= 0;
                            end

                            state <= LOAD;
                        end
                    end
                end
            end

            WRITEBACK: begin
              
                // ���д����ɣ����������
                stall <= 1;
                en <= 1;
                wen <= 0;
                data_ram_addr <= addr;
                byte_en_out = 1'b1;
                state <= LOAD;
            end

            LOAD: begin
                // �������ݵ�����
                en <= 0;
                wen <= 0;
                // ����д�뻺��
                cache[index] = data_ram_in;
                tag[index] = tag_in;
                valid[index] = 1; // ��ȷ������Ч�ź�
                dirty_bit[index] = 0;

                if (pending_write) begin
                    cache[index] = pending_write_data;
                    dirty_bit[index] = 1;
                end else begin
                    // ���̶�����������
                    read_data = data_ram_in;
                end
                state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule

