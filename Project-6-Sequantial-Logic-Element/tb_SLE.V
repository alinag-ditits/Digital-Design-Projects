module tb_SLE();

reg D, CLK, EN, ALn, ADn, SLn, SD, LAT;
wire Q;

SLE DUT(D, CLK, EN, ALn, ADn, SLn, SD, LAT, Q);

initial begin
    CLK = 0;
    forever begin
        #1 CLK = ~CLK;
    end
end

initial begin
    D = 0; EN = 0; ALn = 1; ADn = 1; SLn = 1; SD = 0; LAT = 0;

    @(negedge CLK);
    ALn = 1;

    LAT = 0;

    repeat(30) begin
        D   = $random;
        EN  = $random;
        ADn = $random;
        SLn = $random;
        SD  = $random;
        @(negedge CLK);
    end

    LAT = 1;

    repeat(30) begin
        D   = $random;
        EN  = $random;
        ADn = $random;
        SLn = $random;
        SD  = $random;
        @(negedge CLK);
    end

    ALn = 0;
    LAT = 0;

    repeat(1) begin
        D   = $random;
        EN  = $random;
        ADn = $random;
        SLn = $random;
        SD  = $random;
        @(negedge CLK);
    end

    LAT = 1;

    repeat(1) begin
        D   = $random;
        EN  = $random;
        ADn = $random;
        SLn = $random;
        SD  = $random;
        @(negedge CLK);
    end

    $stop;
end

endmodule
