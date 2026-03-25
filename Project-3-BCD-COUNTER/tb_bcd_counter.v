module tb_bcd();

reg clk , rst;
wire clk_div10_out;
wire [3:0] count;

BCD_COUNT DUT(clk , rst , clk_div10_out , count);

initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    rst = 1;
    @(negedge clk);
    rst = 0;

    repeat(100) @(negedge clk);

    $stop;
end

initial begin
    $monitor("count = %b ||| clk_div = %b ||| rst = %b", count , clk_div10_out , rst);
end

endmodule
