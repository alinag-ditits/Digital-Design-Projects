module tb_rippcount();

reg clk;
reg rstn;
wire [3:0] out;

ripp_counter DUT(clk , rstn , out);

initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    rstn = 0;
    @(posedge clk);
    rstn = 1;

    repeat(100) @(posedge clk);

    $stop;
end

initial begin
    $monitor(" | out = %b | rstn = %b", out, rstn);
end

endmodule
