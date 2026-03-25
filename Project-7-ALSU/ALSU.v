odule ALSU #( 
  parameter WIDTH = 8, 
  parameter INPUT_PRIORITY = "A" 
)( 
  input clk, 
  input rst, 
  input [2:0] opcode, 
  input [WIDTH-1:0] A, 
  input [WIDTH-1:0] B, 
  input cin, 
  input red_op_A, 
  input red_op_B, 
  input bypass_A, 
  input bypass_B, 
  input direction, 
  input serial_in, 
  output reg [WIDTH-1:0] out, 
  output reg [15:0] leds 
); 
 
  reg [WIDTH-1:0] A_reg, B_reg; 
  reg [2:0] opcode_reg; 
  reg cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg; 
  reg direction_reg, serial_in_reg; 
 
  always @(posedge clk or posedge rst) begin 
    if (rst) begin 
      A_reg <= 0; B_reg <= 0; opcode_reg <= 0; cin_reg <= 0; 
      red_op_A_reg <= 0; red_op_B_reg <= 0; bypass_A_reg <= 0; 
      bypass_B_reg <= 0; 
      direction_reg <= 0; serial_in_reg <= 0; 
    end else begin 
      A_reg <= A; B_reg <= B; opcode_reg <= opcode; cin_reg <= cin; 
      red_op_A_reg <= red_op_A; red_op_B_reg <= red_op_B; 
      bypass_A_reg <= bypass_A; bypass_B_reg <= bypass_B; 
      direction_reg <= direction; serial_in_reg <= serial_in; 
    end 
  end 
 
  always @(posedge clk or posedge rst) begin 
    if (rst) begin 
      out <= 0; 
      leds <= 16'b0000000000000000; 
    end else begin 
      case (opcode_reg) 
        3'd0: begin 
          out <= red_op_A_reg ? (A_reg & B_reg) : (A_reg ^ B_reg); 
          leds <= 16'b0000000000000001; 
        end 
        3'd1: begin 
          out <= red_op_B_reg ? ~(A_reg ^ B_reg) : (A_reg | B_reg); 
          leds <= 16'b0000000000000010; 
        end 
        3'd2: begin 
          out <= A_reg + B_reg + cin_reg; 
          leds <= 16'b0000000000000100; 
        end 
        3'd3: begin 
          out <= A_reg - B_reg; 
          leds <= 16'b0000000000001000; 
        end 
        3'd4: begin 
          out <= direction_reg ? (A_reg << 1) | serial_in_reg : (A_reg >> 1); 
          leds <= 16'b0000000000010000; 
        end 
        3'd5: begin 
          out <= direction_reg ? {A_reg[WIDTH-2:0], A_reg[WIDTH-1]} : {A_reg[0], A_reg[WIDTH-1:1]}; 
          leds <= 16'b0000000000100000; 
        end 
        default: begin 
          if (bypass_A_reg && !bypass_B_reg) 
            out <= A_reg; 
          else if (!bypass_A_reg && bypass_B_reg) 
            out <= B_reg; 
          else if (bypass_A_reg && bypass_B_reg) 
            out <= (INPUT_PRIORITY == "A") ? A_reg : B_reg; 
          else 
            out <= 0; 
          leds <= 16'b1111111111111111;  
        end 
      endcase 
    end 
  end 
endmodule 
