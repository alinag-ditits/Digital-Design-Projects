module tb_dsp48a1();
reg [17:0] D,B,A,BCIN;
reg [47:0] C;
reg CARRYIN;
wire CARRYOUT_DUT,CARRYOUTF_DUT;
wire [35:0] M_DUT;
wire [47:0] P_DUT;
reg clk; reg[7:0] OPMODE;
reg CEA,CEB,CEC,CED,CEM,CEP,
CEOPMODE,CECARRYIN,RSTA,RSTB,
RSTC,RSTD,RSTM,RSTP,RSTOPMODE,RSTCARRYIN;
reg [47:0] PCIN;
wire[17:0] BCOUT_DUT;
wire[47:0] PCOUT_DUT;
dsp48a1 DUT (
.clk(clk),
.A(A), .B(B), .D(D),
.BCIN(BCIN), .C(C),
.CARRYIN(CARRYIN),
.CARRYOUT(CARRYOUT_DUT), .CARRYOUTF(CARRYOUTF_DUT),
.M(M_DUT), .P(P_DUT),
.OPMODE(OPMODE),
.CEA(CEA), .CEB(CEB), .CEC(CEC), .CED(CED), .CEM(CEM), .CEP(CEP),
.CEOPMODE(CEOPMODE), .CECARRYIN(CECARRYIN),
.RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTD(RSTD),
.RSTM(RSTM), .RSTP(RSTP), .RSTOPMODE(RSTOPMODE),
.RSTCARRYIN(RSTCARRYIN),
.PCIN(PCIN),
.BCOUT(BCOUT_DUT), .PCOUT(PCOUT_DUT)
);
initial begin
clk=1;

forever #1 clk=~clk;
end
initial begin
RSTA=1; RSTB=1; RSTC=1; RSTD=1; RSTM=1; RSTP=1; RSTOPMODE=1; R
STCARRYIN=1;
D=$random; B=$random;
A=$random; BCIN=$random; C=$random; CARRYIN=$random;
OPMODE=$random; CEA=$random; CEB=$random; CEC=$random; CED=$random
; CEM=$random;
CEP=$random;CEOPMODE=$random;CECARRYIN=$random;PCIN=$random;
@(negedge clk);
if ((P_DUT!=0) && (PCOUT_DUT!=0) && (M_DUT!=0) && (BCOUT_DUT!=0) &&
(CARRYOUT_DUT!=0) && (CARRYOUTF_DUT!=0)) begin
$display("INCORRECT OUTPUTS");
$stop;
end
RSTA=0; RSTB=0; RSTC=0; RSTD=0; RSTM=0; RSTP=0;
RSTOPMODE=0; RSTCARRYIN=0;
CEA=1; CEB=1; CEC=1; CED=1; CEM=1; CEP=1; CEOPMODE=1; CECARRY
IN=1;
OPMODE=8'b11011101; A=20; B=10; C=350; D=25; BCIN=$random; PCIN
=$random;
CARRYIN=$random;
repeat(4) @(negedge clk);
if
((P_DUT!='h32)&&(PCOUT_DUT!='h32)&&(M_DUT!='h12c)&&(BCOUT_DUT!='hf)&&(
CARRYOUT_DUT!=0)&&(CARRYOUTF_DUT!=0)) begin
$display("INCORRECT OUTPUTS");
$stop;
end
OPMODE=8'b00010000;
repeat(3) @(negedge clk);
if
((P_DUT!=0)&&(PCOUT_DUT!=0)&&(M_DUT!='h2bc)&&(BCOUT_DUT!='h23)&&(CARRY
OUT_DUT!=0)&&(CARRYOUTF_DUT!=0)) begin
$display("INCORRECT OUTPUTS");

$stop;
end
OPMODE=8'b00001010;
repeat(3) @(negedge clk);
if
((P_DUT!=0)&&(PCOUT_DUT!=0)&&(M_DUT!='hc8)&&(BCOUT_DUT!='ha)&&(CARRYOU
T_DUT!=0)&&(CARRYOUTF_DUT!=0)) begin
$display("INCORRECT OUTPUTS");
$stop;
end
OPMODE=8'b10110111;A=5;B=6;C=350;D=25;BCIN=$random;PCIN=3000;
CARRYIN=$random;
repeat(3) @(negedge clk);
if
((P_DUT!='hfe6fffec0bb1)&&(PCOUT_DUT!='hfe6fffec0bb1)&&(M_DUT!='h1e)&&
(BCOUT_DUT!='h6)&&(CARRYOUT_DUT!=1)&&(CARRYOUTF_DUT!=1)) begin
$display("INCORRECT OUTPUTS");
$stop;
end
$stop;
end
initial begin
$monitor("P=%h,M=%h,BCOUT=%h,CARRYOUT=%h",P_DUT,M_DUT,BCOUT_DUT,CARRYO
UT_DUT);
end
endmodule
