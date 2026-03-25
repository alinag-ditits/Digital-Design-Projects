module DSP_Block #( 
  parameter OPERATION = "ADD" 
)( 
  input clk, 
  input rst_n, 
  input [17:0] A, 
  input [17:0] B, 
  input [47:0] C, 
  input [17:0] D, 
  output reg [47:0] P 
); 
 
  reg [17:0] A_reg , A_reg2 , B_reg , D_reg ;  
  reg [47:0] C_reg  ;  
  reg [18 : 0 ] DB_out ; 
  reg  [36:0] multip_out ;  
 
  always @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        A_reg <= 0 ;  
        A_reg2 <=  0 ;  
        B_reg <= 0 ;  
        D_reg <=0 ;  
        C_reg <= 0 ;  
    end else begin 
         A_reg <= A ;  
        A_reg2 <=  A_reg2 ;  
        B_reg <= B ;  
        D_reg <=D;  
        C_reg <= C ;  
    end 
  end 
  always @(posedge clk or negedge rst_n) begin 
    if (! rst_n) begin 
        P<= 0 ;  
    end 
    else begin 
        case (OPERATION) 
        "ADD" : DB_out <= D_reg + B_reg ; 
        "SUB" : DB_out <= D_reg - B_reg ;  
             
        endcase 
        multip_out <= DB_out * A_reg2 ;  
        case (OPERATION) 
        "ADD" : P <= multip_out + C_reg ;  
        "SUB" : P <= multip_out - C_reg ;  
        endcase 
    end 
  end 
endmodule
