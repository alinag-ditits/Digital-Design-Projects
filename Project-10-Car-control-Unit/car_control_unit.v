module car_control_unit (
input [7:0] speed_limit,
input [7:0] car_speed,
input [6:0] leading_distance,
input clk,
input rst,
output reg unlock_doors,
output reg accelerate_car
);
parameter [1:0] STOP = 2'b00,
ACCELERATE = 2'b01,
DECELERATE = 2'b10;
parameter MIN_DISTANCE = 7'd40;
(* fsm_encoding = "one_hot" *)
reg [1:0] current_state, next_state;
always @(posedge clk or posedge rst) begin
if (rst) current_state <= STOP;
else current_state <= next_state;
end
always @(*) begin
case (current_state)
STOP:
next_state = (leading_distance >= MIN_DISTANCE &&

car_speed < speed_limit)

? ACCELERATE : STOP;

ACCELERATE:
next_state = (leading_distance < MIN_DISTANCE || car_speed

> speed_limit)

? DECELERATE : ACCELERATE;

DECELERATE:
next_state = (car_speed == 0) ? STOP :

(leading_distance >= MIN_DISTANCE) ?

ACCELERATE : DECELERATE;

default: next_state = STOP;
endcase
end
always @(*) begin
unlock_doors = (current_state == STOP);
accelerate_car = (current_state == ACCELERATE);
end
endmodule
