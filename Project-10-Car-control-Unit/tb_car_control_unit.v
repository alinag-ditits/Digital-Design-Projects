module tb_car_control_unit;
reg clk, rst;
reg [7:0] speed_limit;
reg [7:0] car_speed;
reg [6:0] leading_distance;
wire unlock_doors;
wire accelerate_car;
car_control_unit dut (
.speed_limit(speed_limit),
.car_speed(car_speed),
.leading_distance(leading_distance),

.clk(clk),
.rst(rst),
.unlock_doors(unlock_doors),
.accelerate_car(accelerate_car)
);
initial begin
clk = 1;
forever #1 clk = ~clk;
end
initial begin
$monitor(" rst=%0b | speed_limit=%0d | car_speed=%0d |

dist=%0d | unlock=%0b | accel=%0b",

rst, speed_limit, car_speed, leading_distance,

unlock_doors, accelerate_car);
end
initial begin
rst = 1;
speed_limit = 100;
car_speed = 0;
leading_distance = 50;
@(negedge clk);
rst = 0;
@(negedge clk);
if (!(unlock_doors && !accelerate_car))
$display("Test 1 Failed: Not in STOP state");

car_speed = 80;
leading_distance = 60;
@(negedge clk);
if (!(!unlock_doors && accelerate_car))
$display("Test 2 Failed: Not in ACCELERATE state");
car_speed = 110;

@(negedge clk);
if (!(!unlock_doors && !accelerate_car))
$display("Test 3 Failed: Not in DECELERATE state");
car_speed = 0;
@(negedge clk);
if (!(unlock_doors && !accelerate_car))
$display("Test 4 Failed: Not in STOP state");
car_speed = 60;
leading_distance = 45;
@(negedge clk);
if (!(!unlock_doors && accelerate_car))
$display("Test 5 Failed: Not in ACCELERATE state");
$stop;
end
endmodule
