module ALU #(parameter N = 4, parameter OPCODE = 0) (in0, in1, out);
input [N-1:0] in0, in1;
output reg [N-1:0] out;
  
always @(*) begin
    case (OPCODE)
        0: out = in0 + in1;
        1: out = in0 | in1;
        2: out = in0 - in1;
        3: out = in0 ^ in1;
    endcase
end
  
endmodule
