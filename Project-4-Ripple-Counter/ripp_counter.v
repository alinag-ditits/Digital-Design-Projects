module ripp_counter(clk , rstn , out);

input clk , rstn;
output [3:0] out;

wire q0 , q1 , q2 , q3;
wire qb0 , qb1 , qb2 , qb3;

D_FF ff0(~q0, rstn, clk, q0, qb0);
D_FF ff1(~q1, rstn, q0, q1, qb1);
D_FF ff2(~q2, rstn, q1, q2, qb2);
D_FF ff3(~q3, rstn, q2, q3, qb3);

assign out = {q3 , q2 , q1 , q0};

endmodule
