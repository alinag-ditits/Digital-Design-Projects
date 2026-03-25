module SLE (D , CLK , EN , ALn , ADn , SLn , SD , LAT , Q);

input D , CLK , EN , ALn , ADn , SLn , SD , LAT;
output reg Q;

always @(posedge CLK or negedge ALn) begin
    if (!ALn) begin
        if (ADn == 1)
            Q <= 1'b0;
        else
            Q <= 1'b1;
    end
    else if (LAT) begin
        if (EN) begin
            if (SLn)
                Q <= SD;
            else
                Q <= D;
        end
    end
end

always @(*) begin
    if (LAT) begin
        if (EN) begin
            if (SLn)
                Q = SD;
            else
                Q = D;
        end
    end
end

endmodule
