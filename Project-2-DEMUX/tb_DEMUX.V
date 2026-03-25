module tb_Demux();

reg [1:0] S;
reg D;
wire [3:0] Y;
reg [3:0] Y_EXPECTED;

Demux DUT (D, S, Y);

integer i, j;

initial begin
    $display("Testing 1-to-4 Demux with Self-Check");
    
    for (i = 0; i <= 3; i = i + 1) begin
        S = i;
        
        for (j = 0; j <= 1; j = j + 1) begin
            D = j;
            Y_EXPECTED = 4'b0000;
            Y_EXPECTED[S] = D;
            
            #10;
            
            if (Y != Y_EXPECTED)
                $display("Error");
            else
                $display(" Correct: D = %b, S = %b => Y = %b , Y_EXPECTED = %b", D, S, Y, Y_EXPECTED);
        end
    end
    
    $stop;
end

endmodule
