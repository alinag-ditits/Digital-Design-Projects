module tb_dff();

reg E , D , CLK , PRE;
wire Q;
reg expected_q;

dff uut(E , D , Q , CLK , PRE);

integer i;

initial begin
    CLK = 0;
    forever #1 CLK = ~CLK;
end

initial begin
    PRE = 0; E = 0;
    expected_q = 1'b1;
    @(negedge CLK);

    if (expected_q != Q)
        $display("ERROR");

    PRE = 1; E = 1;

    for (i = 0; i < 10; i = i + 1) begin
        D = $random % 2;
        expected_q = D;
        @(negedge CLK);

        if (expected_q != Q)
            $display("ERROR");
    end

    $stop;
end

endmodule
