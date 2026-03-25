module gray_counter (
input clk,
input rst,
output reg [1:0] y
);
parameter [1:0] A = 2'b00,
B = 2'b01,
C = 2'b10,
D = 2'b11;

reg [1:0] current_state, next_state;
always @(posedge clk or posedge rst) begin
if (rst) current_state <= A;
else current_state <= next_state;
end

always @(*) begin
case (current_state)
A: next_state = B;
B: next_state = C;

C: next_state = D;
D: next_state = A;
default: next_state = A;
endcase
end
always @(*) begin
case (current_state)
A: y = 2'b00;
B: y = 2'b01;
C: y = 2'b11;
D: y = 2'b10;
default: y = 2'b00;
endcase
end
endmodule
