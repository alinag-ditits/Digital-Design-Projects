module tb_DSP_Block(); 
  reg clk, rst_n; 
  reg [17:0] A, B, D; 
  reg [47:0] C; 
  wire [47:0] P; 
 
  DSP_Block #( "ADD" ) DUT ( 
    .clk(clk), .rst_n(rst_n), .A(A), .B(B), .C(C), .D(D), .P(P) 
  ); 
 
  initial begin clk = 0; forever #1 clk = ~clk; end 
 
  initial begin 
 
    rst_n = 0; 
    A =18'd0; B = 18'd0; C = 48'd0; D = 18'd0; 
     @(negedge clk); 
    rst_n = 1; 
    A = 18'd5; B = 18'd6; C = 48'd1; D = 18'd2 ;  
    @(negedge clk); @(negedge clk); 
    A = 18'd3; B = 18'd4; C = 48'd1; D = 18'd4 ; 
    @(negedge clk); @(negedge clk); 
    A = 18'd4; B = 18'd4; C = 48'd2; D = 18'd4 ; 
    @(negedge clk); @(negedge clk); 
 
    $display("[INFO] Please re-run simulation with parameter \"SUBTRACT\" to test SUBTRACT path."); 
    $stop; 
  end 
  initial begin 
        $monitor("[ OP=ADD | A=%0d | B=%0d | C=%0d | D = %0d | P=%0d", A, B, C , D, P); 
 
  end 
endmodule
