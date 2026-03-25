input [1:0] in0 , in1 , in2 , in3; 
input clk , rst ; 
output reg [1:0] out; 
reg [1:0]counter ;  
always @(posedge clk or posedge rst ) begin 
if (rst) begin 
    counter <= 2'b00 ;  
end     
else begin 
    if(counter==2'b11) 
    counter<=0 ;  
    else begin 
    counter <= counter + 1 ;  
end  
end 
 
end 
always @(*) begin 
case (counter) 
0 : out = in0 ;  
1 : out = in1 ;  
2 : out = in2 ;  
3 : out = in3 ;  
endcase     
end 
 
endmodule 
