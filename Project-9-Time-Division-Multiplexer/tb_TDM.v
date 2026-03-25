module tb_TDM(); 
reg clk , rst ;  
reg  [1:0] in0 , in1 , in2 , in3 , out_expected ;  
wire[1:0] out ; 
integer counter ; 
TDM DUT(clk , rst , in0 , in1 , in2 , in3 , out ) ;  
initial begin 
    clk=0 ; 
    forever begin 
     #1 clk = ~clk ;     
    end 
 
end  
initial begin 
    rst = 1 ; 
    in0 = 0 ; in1 = 0 ; in2=0; in3=0; counter = 0 ; out_expected=0 ;   
    @(negedge clk ) ;  
    rst = 0 ; 
    repeat(15) begin 
        in0 = $urandom_range(0,3) ;  
        in1 = $urandom_range(0,3) ; 
        in2 = $urandom_range(0,3) ; 
        in3 = $urandom_range(0,3) ; 
        case (counter) 
        0 : out_expected = in0 ;  
        1 : out_expected = in1 ;  
        2 : out_expected = in2 ;  
        3 : out_expected = in3 ;  
                     
        endcase 
     if (counter==3) counter = 0 ;  
     else counter = counter +1 ;  
     @(negedge clk); 
     if (out != out_expected) begin 
        $display("EEEEEEEEEEEEERRRRRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOR") ;  
     end 
         
    end  
         $stop ;  
 
end 
initial begin 
$monitor("in0=%d |||| in1= %d ||| in2=%d |||| in3=%d |||| coounter = %d ||| out=%d ||| , out_expected=%d",in0 , in1 , in2 , in3 , counter , out , out_expected); 
end 
endmodule 


