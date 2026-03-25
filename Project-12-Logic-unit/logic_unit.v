module logic_unit(
input clk,
input rst,
input cin,
input serial_in,
input red_op_A,
input red_op_B,
input [2:0] opcode,
input bypass_A,
input bypass_B,
input direction,
input [2:0] A,
input [2:0] B,
output reg [15:0] leds,
output reg [5:0] out
);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
reg cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg;
reg direction_reg, serial_in_reg;
reg [2:0] opcode_reg, A_reg, B_reg;
wire invalid_red_op = (red_op_A_reg || red_op_B_reg) && (opcode_reg[1]
| opcode_reg[2]);
wire invalid_opcode = opcode_reg[1] & opcode_reg[2];
wire invalid = invalid_red_op || invalid_opcode;
always @(posedge clk or posedge rst) begin
if (rst) begin
{cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg,

bypass_B_reg} <= 0;

{direction_reg, serial_in_reg} <= 0;
opcode_reg <= 0;
A_reg <= 0;
B_reg <= 0;

end else begin
cin_reg <= cin;
red_op_A_reg <= red_op_A;
red_op_B_reg <= red_op_B;
bypass_A_reg <= bypass_A;
bypass_B_reg <= bypass_B;
direction_reg <= direction;
serial_in_reg <= serial_in;
opcode_reg <= opcode;
A_reg <= A;
B_reg <= B;
end
end
always @(posedge clk or posedge rst) begin
if (rst) begin
leds <= 0;
end else begin
leds <= invalid ? ~leds : 0;
end
end
wire [3:0] adder_out;
wire [2:0] adder_A = A_reg;
wire [2:0] adder_B = B_reg;
wire adder_cin = (FULL_ADDER == "ON") ? cin_reg : 1'b0;
generate
if (FULL_ADDER == "ON") begin
c_addsub_0 adder_inst (
.A(adder_A),
.B(adder_B),
.C_IN(adder_cin),
.S(adder_out)
);
end else begin
c_addsub_0 adder_inst (
.A(adder_A),
.B(adder_B),
.C_IN(1'b0),

.S(adder_out)
);
end
endgenerate
wire [5:0] mult_out;
mult_gen_0 mult_inst (
.A(A_reg),
.B(B_reg),
.P(mult_out)
);
always @(posedge clk or posedge rst) begin
if (rst) begin
out <= 0;
end else begin
if (invalid) begin
out <= 0;
end else if (bypass_A_reg && bypass_B_reg) begin
out <= (INPUT_PRIORITY == "A") ? A_reg : B_reg;
end else if (bypass_A_reg) begin
out <= A_reg;
end else if (bypass_B_reg) begin
out <= B_reg;
end else begin
case (opcode_reg)
3'h0: begin
if (red_op_A_reg && red_op_B_reg)
out <= (INPUT_PRIORITY == "A") ? {5'b0,

&A_reg} : {5'b0, &B_reg};

else if (red_op_A_reg)
out <= {5'b0, &A_reg};
else if (red_op_B_reg)
out <= {5'b0, &B_reg};
else
out <= A_reg & B_reg;

end

3'h1: begin
if (red_op_A_reg && red_op_B_reg)
out <= (INPUT_PRIORITY == "A") ? {5'b0,

^A_reg} : {5'b0, ^B_reg};

else if (red_op_A_reg)
out <= {5'b0, ^A_reg};
else if (red_op_B_reg)
out <= {5'b0, ^B_reg};
else
out <= A_reg ^ B_reg;

end
3'h2: out <= adder_out;
3'h3: out <= mult_out;
3'h4: begin
if (direction_reg)
out <= {out[4:0], serial_in_reg};
else
out <= {serial_in_reg, out[5:1]};

end
3'h5: begin
if (direction_reg)
out <= {out[4:0], out[5]};
else
out <= {out[0], out[5:1]};

end
default: out <= 0;
endcase
end
end
end
endmodule
