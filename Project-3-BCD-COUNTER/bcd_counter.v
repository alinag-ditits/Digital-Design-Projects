module BCD_COUNT(clk , rst , clk_div10_out , count);

input clk , rst;
output reg clk_div10_out;
output reg [3:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        clk_div10_out <= 0;
    end
    else begin
        if (count == 9) begin
            count <= 0;
            clk_div10_out <= ~clk_div10_out;
        end
        else begin
            count = count + 1;
        end
    end
end

endmodule
