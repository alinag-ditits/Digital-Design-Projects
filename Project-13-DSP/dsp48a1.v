module dsp48a1 #(
parameter A0REG = 0,
parameter AIREG = 1,
parameter B0REG = 0,
parameter BIREG = 1,
parameter CREG = 1,
parameter DREG = 1,
parameter MREG = 1,
parameter PREG = 1,
parameter CARRYINREG = 1,
parameter CARRYOUTREG = 1,
parameter OPMODEREG = 1,
parameter CARRYINSEL = "OPMODE5",
parameter B_INPUT = "DIRECT",
parameter RSTTYPE = "SYNC"
)(
input wire clk,
input wire [17:0] A, B, D,
input wire [47:0] C,
input wire CARRYIN,
input wire [47:0] PCIN,
input wire [17:0] BCIN,
input wire [7:0] OPMODE,

input wire CEA, CEB, CEC, CED, CEM, CEP, CECARRYIN, CEOPMODE,
input wire RSTA, RSTB, RSTC, RSTD, RSTM, RSTP, RSTCARRYIN,
RSTOPMODE,
output wire [17:0] BCOUT,
output wire [47:0] PCOUT,
output wire [35:0] M,
output wire [47:0] P,
output wire CARRYOUT,
output wire CARRYOUTF
);
wire [17:0] D_OUT ,B_IN, B0_OUT , A0_OUT , PRE_OUT,
BI_IN , BI_OUT ,A1_OUT ;
wire [47:0] C_OUT , D_A_B ,POST_OUT ;
reg [47:0] X_OUT,Z_OUT;
wire [35:0] M_IN , M_OUT ;
wire [7:0] OPMODE_REG ;
wire CIN , COUT ;
reg CS;
repeatm #(RSTTYPE,DREG,18,18)D_INS (D,clk,RSTD,CED,D_OUT);
repeatm #(RSTTYPE,B0REG,18,18)B0_INS (B_IN,clk,RSTB,CEB,B0_OUT);
repeatm #(RSTTYPE,A0REG,18,18)A0_INS (A,clk,RSTA,CEA,A0_OUT);
repeatm #(RSTTYPE,CREG,48,48)C_INS (C,clk,RSTC,CEC,C_OUT);
repeatm #(RSTTYPE,BIREG,18,18)B1_INS (BI_IN,clk,RSTB,CEB,BI_OUT);
repeatm #(RSTTYPE,AIREG,18,18)A1_INS (A0_OUT,clk,RSTA,CEA,A1_OUT);
repeatm #(RSTTYPE,MREG,36,36)M_INS (M_IN,clk,RSTM,CEM,M_OUT);
repeatm #(RSTTYPE,CARRYINREG,1,1)CYI_INS
(CS,clk,RSTCARRYIN,CECARRYIN,CIN);
repeatm #(RSTTYPE,CARRYOUTREG,1,1)CYO_INS
(COUT,clk,RSTCARRYIN,CECARRYIN,CARRYOUT);
repeatm #(RSTTYPE,PREG,48,48)P_INS (POST_OUT,clk,RSTP,CEP,P);
repeatm
#(RSTTYPE,OPMODEREG,8,8)OP(OPMODE,clk,RSTOPMODE,CEOPMODE,OPMODE_REG);
assign B_IN=(B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADE")?BCIN:0;
always @(*) begin

case (CARRYINSEL)

"OPMODES":CS=OPMODE_REG[5];
"CARRYIN":CS=CARRYIN;
default :CS=1'b0;

endcase

end
assign PRE_OUT = (OPMODE_REG[6])? D_OUT-B0_OUT :D_OUT+B0_OUT;
assign BI_IN = (OPMODE_REG[4])?PRE_OUT:B0_OUT;
assign BCOUT = BI_OUT;
assign M_IN = BI_OUT*A1_OUT;
assign PCOUT = P;
assign CARRYOUTF = CARRYOUT;
assign D_A_B = {D[11:0],A1_OUT,BI_OUT};
always @(*) begin
case (OPMODE_REG[1:0])
2'b00: X_OUT=48'b0;
2'b01: X_OUT=M_OUT;
2'b10: X_OUT=PCOUT;
2'b11: X_OUT=D_A_B;
endcase
end
always @(*) begin
case (OPMODE_REG[3:2])
2'b00: Z_OUT=48'b0;
2'b01: Z_OUT=PCIN;
2'b10: Z_OUT=P;
2'b11: Z_OUT=C_OUT;
endcase
end
assign M = M_OUT;
assign {COUT,POST_OUT} = (OPMODE_REG[7])?Z_OUT-
(X_OUT+CIN):X_OUT+Z_OUT+CIN;
endmodule
