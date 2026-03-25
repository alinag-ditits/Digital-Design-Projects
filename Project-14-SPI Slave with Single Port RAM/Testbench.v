module Testbench ();
//stimulus
reg clk , rst_n , MOSI , SS_n;
wire MISO;
reg [7:0] wr_add, rd_add; 
reg [7:0] wr_data, rd_data;
reg read_sequence;
//dut
SPI_Wrapper DUT (MOSI,SS_n,clk,rst_n,MISO);
//clock generator
initial begin
    clk = 0;
    forever
        #5 clk = ~clk; 
end
//test 
initial begin
    $readmemb ("mem.txt",DUT.SPI_RAM.mem);
    rst_n = 0;
    {wr_add,rd_add,wr_data,rd_data} = 4'b0000;
    repeat(5) begin
        MOSI = $random;
        SS_n = $random;
        @(negedge clk);
    end
    rst_n = 1;
    read_sequence = 1; 
    repeat(4) begin
        SS_n = 0; 
        MOSI = $random; 
        @(negedge clk);
        MOSI = 1; 
        read_sequence = ~read_sequence;
        @(negedge clk); 
        @(negedge clk); 
        MOSI = read_sequence; 
        repeat(10) begin
            @(negedge clk);
            MOSI = $random;
        end
        if (~read_sequence)
            SS_n = 1; 
        else begin 
            repeat(8) @(negedge clk);
        end
        SS_n = 1;
        repeat(3) @(negedge clk);
    end
    repeat(4) begin
        SS_n = 0;
        MOSI = $random;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk); 
        @(negedge clk);
        MOSI = $random;
        repeat(10) begin 
            @(negedge clk);
            MOSI = $random;
        end
        SS_n = 1;
        repeat(3) @(negedge clk);
    end
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;
    repeat(3) @(negedge clk);
    repeat (8) begin
        MOSI = $random;
        wr_add = {wr_add[6:0],MOSI};
        @(negedge clk);  
    end
    SS_n = 1;
    @(negedge clk);
    @(negedge clk);
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;
    repeat(2) @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    repeat(8) begin
        MOSI = $random;
        wr_data = {wr_data[6:0],MOSI};
        @(negedge clk);
    end
    SS_n = 1;
    @(negedge clk);
    
    @(negedge clk);
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    repeat(2) @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    repeat(8) begin
        MOSI = $random;
        rd_add = {rd_add[6:0],MOSI};
        @(negedge clk);
    end
    SS_n = 1;
    @(negedge clk);
    @(negedge clk);
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    repeat(3) @(negedge clk);
    repeat(8) begin
        MOSI = $random; 
        @(negedge clk);
    end
    @(negedge clk);
    repeat(8) begin
        @(negedge clk);
        rd_data = {rd_data[6:0],MISO};    
    end
    SS_n = 1;
    @(negedge clk);
    repeat(2) @(negedge clk);
    $stop;
end
initial
$monitor("MOSI = %b, MISO = %b, SS_n = %b, clk = %b, rst_n = %b, rx_data = %d, rx_valid = %b, tx_data = %d, tx_valid = %b"
,MOSI,MISO,SS_n,clk,rst_n,DUT.rx_data,DUT.rx_valid,DUT.tx_data,DUT.tx_valid);
endmodule //Testbench