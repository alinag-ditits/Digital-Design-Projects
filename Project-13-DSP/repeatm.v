module repeatm #(
parameter RSTTYPE = "SYNC",
parameter REG_EN = 1 ,
parameter WIDTH = 18 ,
parameter OWIDTH = 18
)
(
input [WIDTH-1:0] IN ,
input clk , rst , en ,
output [OWIDTH-1:0] out
);
reg [WIDTH-1:0] IN_REG ;
generate
if (RSTTYPE == "SYNC") begin
always @(posedge clk) begin
if (rst) begin
IN_REG <= 0;
end
else begin
if(en)
IN_REG <= IN;
end
end
end
else if (RSTTYPE == "ASYNC") begin
always @(posedge clk or posedge rst) begin
if (rst) begin
IN_REG <= 0;
end
else begin
if(en)
IN_REG <= IN;
end
end
end
endgenerate
assign out = (REG_EN)? IN_REG : IN;

endmodule
