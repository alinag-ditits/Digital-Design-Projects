module SPI #(
parameter IDLE=3'b000,
parameter CHK_CMD=3'b001,
parameter WRITE=3'b010,
parameter READ_ADD=3'b011,
parameter READ_DATA=3'b100
)
(
    input MOSI,SS_n,clk,rst_n,tx_valid,
    input [7:0] tx_data, 
    output reg MISO,rx_valid ,
    output reg [9:0] rx_data
);
//FSM Encoding Method
(* fsm_encoding = "sequential"*)
reg [2:0] cs,ns;
reg [3:0] counter;
reg read_addr_rec;
//next state logic
always @(*) begin
    case (cs)
    IDLE:if(SS_n)
            ns=IDLE;
        else
            ns=CHK_CMD;
    CHK_CMD:if (SS_n)
            ns=IDLE;
    else begin 
        if(MOSI)begin
            if (read_addr_rec) 
                ns=READ_DATA;
            else begin
                ns=READ_ADD;
            end
            end
        else begin
             ns=WRITE;
        end
    
    end
    WRITE:if(SS_n)
            ns=IDLE;
        else 
            ns=WRITE;
    READ_ADD:if(SS_n)
            ns=IDLE;
        else 
            ns=READ_ADD;
    READ_DATA:if(SS_n)
            ns=IDLE;
        else
            ns=READ_DATA;
    default : ns=IDLE;
    endcase
end
//state memory
always @(posedge clk) begin
    if (~rst_n) begin
        cs<=IDLE;
    end
    else begin
        cs<=ns;
    end
end
//output seq
always @(posedge clk) begin
   if(~rst_n)begin
    MISO<=0;
    rx_data<=0;
    rx_valid<=0;
    read_addr_rec<=0;
    counter<=0;
   end
   else begin
    case (cs)
    IDLE:begin rx_valid<=0;
          MISO<=0;
          counter<=0;
    end
    CHK_CMD:begin rx_valid<=0;
            counter<=0;
    end
    WRITE: if(counter==10)begin
           rx_valid<=1;
           counter<=0;
            end
            else  begin
            counter<=counter+1;
            rx_valid<=0;
            rx_data<={rx_data[8:0],MOSI}; 
            end
    READ_ADD:if(counter==10)begin
                rx_valid<=1;
                read_addr_rec<=1;
                counter<=0;
            end
            else  begin
            counter<=counter+1;
            rx_valid<=0;
            rx_data<={rx_data[8:0],MOSI}; 
            end
    READ_DATA:if (tx_valid&&counter<8) begin
                MISO<=tx_data[7-counter];
                counter<=counter+1;
            end 
             else if(counter==10)begin
                 rx_valid<=1;
                 read_addr_rec<=0;
                 counter<=0;
            end
            else  begin
            counter<=counter+1;
            rx_valid<=0;
            rx_data<={rx_data[8:0],MOSI}; 
            end
    endcase
   end
end
endmodule //SPI