module tb_ALU_add();

parameter N = 4;

reg  [N-1:0] in0, in1, out_expected;
wire [N-1:0] out;

ALU #(N,0) DUT (in0, in1, out);

initial begin
    repeat (100) begin
        in0 = $random;
        in1 = $random;
        out_expected = in0 + in1;
        #10;
        
        if (out != out_expected) begin
            $display("Error in ALU Output is no correct");
        end
    end
    $stop;
end

initial begin
    $monitor("in0 = %b , in1 = %b , result= %b", in0, in1, out);
end

endmodule
