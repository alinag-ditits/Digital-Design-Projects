module tb_gray_counter;
reg clk;
reg rst;
wire [1:0] y;
gray_counter dut (
.clk(clk),
.rst(rst),
.y(y)
);
initial begin
clk = 1;
forever begin
#1 clk=~clk ;
end
end

initial begin
$monitor("T=%0t | rst=%b | y=%b", $time, rst, y);
end
initial begin
rst = 1;
@(negedge clk);
rst = 0;
@(negedge clk);
@(negedge clk);
if (y !== 2'b00) $display("State A: Expected 00, got %b", y);
@(negedge clk);
if (y !== 2'b01) $display("State B: Expected 01, got %b", y);
@(negedge clk);
if (y !== 2'b11) $display("State C: Expected 11, got %b", y);
@(negedge clk);
if (y !== 2'b10) $display("State D: Expected 10, got %b", y);
@(negedge clk);
if (y !== 2'b00) $display("State A again: Expected 00, got %b",y);
$stop;
end
endmodule
