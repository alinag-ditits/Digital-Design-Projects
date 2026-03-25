module tb_ALSU(); 
  parameter WIDTH = 8; 
  reg clk, rst; 
  reg [2:0] opcode; 
  reg [WIDTH-1:0] A, B; 
  reg cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in; 
  wire [WIDTH-1:0] out; 
  wire [15:0] leds; 
 
  ALSU #(WIDTH) DUT ( 
    .clk(clk), .rst(rst), .opcode(opcode), .A(A), .B(B), 
    .cin(cin), .red_op_A(red_op_A), .red_op_B(red_op_B), 
    .bypass_A(bypass_A), .bypass_B(bypass_B), 
    .direction(direction), .serial_in(serial_in), 
  .out(out), .leds(leds) 
  ); 
 
  initial begin 
     clk = 0;  
     forever 
      #1 clk = ~clk; 
       end 
  initial begin 
    rst = 1 ;  
    opcode = 3'b000 ; A = 2'b00 ; B = 2'b00 ; cin=0; red_op_A = 0 ; 
red_op_B = 0 ; bypass_A = 0 ; bypass_B=0 ; direction = 0 ; serial_in =0 ;  
    @(negedge clk); 
    rst = 0 ;  
    bypass_A = 1 ; bypass_B = 1 ;  
    repeat(5) begin 
     A=$random ;  
    B = $random ;  
    opcode = $urandom_range(0,5) ;  
    @(negedge clk); 
    @(negedge clk); 
      if (out !== A) $display("Bypass failed"); 
    end 
        bypass_A = 0 ; bypass_B = 0 ; opcode = 3'b000 ; 
        repeat(5)begin 
            A=$random ;  
    B = $random ;  
    red_op_A = $random ;  
    red_op_B = $random ;  
    @(negedge clk); 
        @(negedge clk); 
if (red_op_A) 
        if (out !== (A & B)) $display("[ERROR] Opcode 0 AND failed"); 
        else; 
      else 
        if (out !== (A ^ B)) $display("[ERROR] Opcode 0 XOR failed"); 
    end 
     opcode = 3'b001; 
    repeat(5) begin 
      A = $random;  
      B = $random;  
      red_op_A = $random;  
      red_op_B = $random;  
      @(negedge clk); 
      @(negedge clk); 
      if (red_op_B) 
        if (out !== ~(A ^ B)) $display("[ERROR] Opcode 1 XNOR failed"); 
        else; 
      else 
        if (out !== (A | B)) $display("[ERROR] Opcode 1 OR failed"); 
    end  
 
    opcode = 3'b010; 
    red_op_A = 0; red_op_B = 0; 
    repeat(5) begin 
      A = $random;  
      B = $random;  
      cin = $random;  
      @(negedge clk); 
      @(negedge clk); 
      if (out !== (A + B + cin)) $display("[ERROR] Opcode 2 ADD failed"); 
    end 
    opcode = 3'b011; 
    repeat(5) begin 
      A = $random;  
      B = $random;  
      @(negedge clk); 
      @(negedge clk); 
      if (out !== (A - B)) $display("[ERROR] Opcode 3 SUB failed"); 
    end  
    opcode = 3'b100; 
    repeat(5) begin 
      A = $random;  
      B = $random;  
      direction = $random; 
      serial_in = $random; 
      @(negedge clk); 
      @(negedge clk); 
      if (direction) 
        if (out !== ((A << 1) | serial_in)) $display("[ERROR] Opcode 4 LEFT shift failed"); 
      else 
        if (out !== (A >> 1)) $display("[ERROR] Opcode 4 RIGHT shift failed"); 
    end 
    opcode = 3'b101; 
    repeat(5) begin 
      A = $random;  
      B = $random;  
      direction = $random; 
      serial_in = $random; 
      @(negedge clk); 
      @(negedge clk); 
      if (direction) 
        if (out !== {A[WIDTH-2:0], A[WIDTH-1]}) $display("[ERROR] Opcode 5 LEFT rotate failed"); 
      else 
        if (out !== {A[0], A[WIDTH-1:1]}) $display("[ERROR] Opcode 5 RIGHT rotate failed"); 
    end     
  end 
  initial begin 
    $monitor(" opcode=%b | A=%0d | B=%0d | cin=%b | red_op_A=%b | 
red_op_B=%b | bypass_A=%b | bypass_B=%b | dir=%b | serial_in=%b | 
out=%0d | leds=%b", 
              opcode, A, B, cin, red_op_A, red_op_B, bypass_A, 
bypass_B, direction, serial_in, out, leds); 
 
    end 
