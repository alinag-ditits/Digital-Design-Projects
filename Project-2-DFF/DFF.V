module dff(E , D , Q , CLK , PRE);

input E , D , CLK , PRE;
output reg Q;

always @(posedge CLK or negedge PRE) begin
    if (!PRE) begin
        Q <= 1'b1;
    end
    else if (E) begin
        Q <= D;
    end
end

endmodule
