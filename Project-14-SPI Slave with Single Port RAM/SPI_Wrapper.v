module SPI_Wrapper (
    input MOSI,SS_n,clk,rst_n,
    output MISO
);
wire [9:0] rx_data;
wire [7:0] tx_data;
wire rx_valid,tx_valid;

SPI SPI_Slave (MOSI,SS_n,clk,rst_n,tx_valid,tx_data,MISO,rx_valid,rx_data);
RAM #(256,8) SPI_RAM (rx_data,clk,rst_n,rx_valid,tx_data,tx_valid);
endmodule //SPI_Wrapper