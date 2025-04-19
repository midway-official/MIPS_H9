module JUMP_REG (
    input  clk,
    input  rsta,
    input  branch,
    input  [31:0] branch_address,
    output reg [31:0] jump_pc,
    output reg  branch_out
);



    always @(posedge clk  or posedge rsta) begin
        if (rsta) begin
            jump_pc <= 32'b0;
            branch_out<=0;
        end else begin
            jump_pc <= branch_address; // ´æ´¢Ìø×ªµØÖ·
             branch_out<= branch;
        end
    end


endmodule