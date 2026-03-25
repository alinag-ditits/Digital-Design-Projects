module tb_shift_reg();

localparam SHIFT_WIDTH = 8;
localparam SHIFT_DIRECTION = "LEFT";
localparam LOAD_AVALUE = 2;
localparam LOAD_SVALUE = 4;

reg clk, aclr, aset, sclr, sset, load, enable, shiftin;
reg [SHIFT_WIDTH-1:0] data;
wire [SHIFT_WIDTH-1:0] q;
wire shiftout;

reg [SHIFT_WIDTH-1:0] expected_q;

param_shift_reg #(SHIFT_WIDTH, SHIFT_DIRECTION, LOAD_AVALUE, LOAD_SVALUE)
DUT (sclr, sset, shiftin, load, data, clk, enable, aclr, aset, shiftout, q);

initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    sclr=0; sset=0; shiftin=0; load=0; enable=0; aclr=0; aset=0;
    data=0;

    @(negedge clk);
    aclr = 1;
    aset = 0;

    repeat(10) begin
        data = $random;
        shiftin = $random;
        load = $random;
        enable = $random;

        @(negedge clk);
        expected_q = LOAD_SVALUE;

        if (q != expected_q)
            $display("ERROR!!! q = %b || expected_q = %b", q , expected_q);
        else
            $display("q = %b || expected_q = %b", q , expected_q);
    end

    aclr = 0; sclr = 0;

    repeat(10) begin
        data = $random;
        shiftin = $random;
        load = $random;

        @(negedge clk);
        expected_q = LOAD_SVALUE;

        if (q != expected_q)
            $display("ERROR!!! q = %b || expected_q = %b", q , expected_q);
        else
            $display("q = %b || expected_q = %b", q , expected_q);
    end

    sset = 0; load = 1;

    repeat(10) begin
        data = $random;
        shiftin = $random;
        load = $random;

        @(negedge clk);
        expected_q = data;

        if (q != expected_q)
            $display("ERROR!!! q = %b || expected_q = %b", q , expected_q);
        else
            $display("q = %b || expected_q = %b", q , expected_q);
    end

    expected_q = 8'b10101010;
    load = 1;
    data = expected_q;

    @(negedge clk);
    load = 0;

    repeat(10) begin
        shiftin = $random % 2;
        expected_q = {expected_q[6:0], shiftin};

        @(negedge clk);

        if (q != expected_q)
            $display("Shift Failed: q = %b, expected = %b", q , expected_q);
        else
            $display("Shift Passed: q = %b, shiftin = %b", q , shiftin);
    end

    $stop;
end

endmodule
