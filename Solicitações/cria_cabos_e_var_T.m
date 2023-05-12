function [info,situacao,msg_erro]=cria_cabos_e_var_T(vao_i,long_i,LC_cd_PP,viaduto,info,config_draw)
situacao=true;
msg_erro='sem erro';

var_T=0;
Epp=0;
Eppime=0;
aal=0;

W=viaduto.W;
fi_t=viaduto.longa_fi_tran;
c=viaduto.vao(vao_i).longarina.c;
b1=viaduto.vao(vao_i).longarina.b1;
b2=viaduto.vao(vao_i).longarina.b2;
b3=viaduto.vao(vao_i).longarina.b3;
h1=viaduto.vao(vao_i).longarina.h1;
h2=viaduto.vao(vao_i).longarina.h2;
h3=viaduto.vao(vao_i).longarina.h3;
h4=viaduto.vao(vao_i).longarina.h4;
h5=viaduto.vao(vao_i).longarina.h5;
hlj=viaduto.vao(vao_i).laje.h;
fck=viaduto.vao(vao_i).longarina.fck/1E6;%MPa;
n_longa=viaduto.vao(vao_i).n_longarinas;
l=viaduto.vao(vao_i).l;
nm=info.longarinas.vao(vao_i).longarina(long_i).membros;%numero do membro da longarina
ndc=viaduto.disc_cabos;%numero de discretização do traçado do cabo
amp=viaduto.vao(vao_i).amp; %altura máxima do cabo de protensão
ntcord=viaduto.vao(vao_i).ntcord; %numero total de cordoalhas por vão
dcabo=viaduto.dcabo;%diametro do cabo em metros
nmcc=viaduto.nmcc;%numero máximo de cordoalhas por cabo
Ti=viaduto.Ti;%Temperatura média diária do ambiente em graus Celsius
Umi=viaduto.Umi;%Umidade relativa do ar em %
abatimento=viaduto.longarinas.abatimento;%abatimento do concreto em centimetros;


% Propriedades da seção da longarina-laje
secaoll=info.longarinas.vao(vao_i).longarina(long_i).secao;%seção do conjunto longarina laje
secaoll(:,1)=[];
All=info.longarinas.vao(vao_i).longarina(long_i).A;
Iyll=info.longarinas.vao(vao_i).longarina(long_i).Iy;

% Propriedades da seção da longarina pré-moldada
[secaol,Al,Iyl,ZCG] = secao_long(viaduto,vao_i);%seção da longarina pré-moldada

[aal,situacao,msg_erro] = aloja_cabos(secaol,b2,ntcord,nmcc,dcabo,amp,viaduto.area_cordoalha,c,fi_t,config_draw);
if not(situacao); return; end

xb=info.longarinas.vao(vao_i).longarina(long_i).xb;
yb=info.longarinas.vao(vao_i).longarina(long_i).yb;
zb=info.longarinas.vao(vao_i).longarina(long_i).zb;
xe=info.longarinas.vao(vao_i).longarina(long_i).xe;
ye=info.longarinas.vao(vao_i).longarina(long_i).ye;
ze=info.longarinas.vao(vao_i).longarina(long_i).ze;
    lb=((xb-xe)^2 + ...
        (yb-ye)^2 + ...
        (zb-ze)^2)^.5;
info.longarinas.vao(vao_i).longarina(long_i).lb=lb;%m

[cabos,situacao,msg_erro] = cria_prop_cabos(aal,ZCG,viaduto.vao(vao_i),viaduto,lb);
if not(situacao); return; end

% Esforços necessarios para o calculo das perdas e para o dimensionamento
[Mg0,~]=calc_Mg0(cabos(1).x,Al,vao_i,long_i,viaduto,info);
Mg= calc_Mg(cabos(1).x,vao_i,long_i,LC_cd_PP,viaduto,info)/1000;%kN.m


%% Perdas imediatas
[cabos,SigPi,situacao,msg_erro] = perdas_imediatas(cabos,viaduto,config_draw);
if not(situacao); return; end


[cabo_eq_ato,cabo_eq_enc] = calc_cabo_eq(cabos,aal.n,ndc,aal.A,config_draw);


cabo_eq_enc_ime=cabo_eq_enc;

%Perda por encurtamento elastico
for s=1:viaduto.disc_cabos+3
    DelSigp=calc_perca_encurtamento_elastico(s,cabo_eq_enc,Mg0,secaol,Al,Iyl,aal.n,fck,viaduto);%MPa
    DelSigp=DelSigp/10;%kN/cm²
    cabo_eq_enc_ime.Sig(s)=cabo_eq_enc.Sig(s)-DelSigp;
end


%% Perdas progressivas

% Relaxação do aço
porc_fptd=zeros(1,viaduto.disc_cabos+3);
phi_1000=zeros(1,viaduto.disc_cabos+3);
phi_inf=zeros(1,viaduto.disc_cabos+3);
chi_inf=zeros(1,viaduto.disc_cabos+3);

for s=1:viaduto.disc_cabos+3
    porc_fptd(s)=cabo_eq_enc_ime.Sig(s)/(viaduto.fptd*1.15);
    phi_1000(s)=-16.667*porc_fptd(s)^3+25*porc_fptd(s)^2+0.6667*porc_fptd(s)-4.5; % Regressão no excel da tabela 8.4 da 6118:2014    y = -16,667x3 + 25x2 + 0,6667x - 4,5
    phi_inf(s)=phi_1000(s)*2.5;
    chi_inf(s)=-log(1-phi_inf(s)/100);
end


% Retração do concreto
if or(long_i==1,long_i==viaduto.vao(vao_i).n_longarinas)
    Uar=calc_perimetro(secaoll(:,1),secaoll(:,2))-1*viaduto.vao(vao_i).laje.h;%desconta uma laje
else
    Uar=calc_perimetro(secaoll(:,1),secaoll(:,2))-2*viaduto.vao(vao_i).laje.h;%desconta duas lajes
end

[h_fic] = calc_h_fic(Umi,All,Uar);

t0_ret=viaduto.longarinas.alfa_ret*((viaduto.Ti+10)/30)*viaduto.longarinas.delta_t_ef;

Aret=40;
Bret=116*h_fic^3-282*h_fic^2+220*h_fic-4.8;
Cret=2.5*h_fic^3            -8.8*h_fic+40.7;
Dret=-75*h_fic^3+585*h_fic^2+496*h_fic-6.8;
Eret=-169*h_fic^4+88*h_fic^3+584*h_fic^2-39*h_fic+.8;

beta_s=((t0_ret/100)^3+Aret*(t0_ret/100)^2+Bret*(t0_ret/100))/((t0_ret/100)^3+Cret*(t0_ret/100)^2+Dret*(t0_ret/100)+Eret);

if abatimento<5
    mult_abatimento=0.75;
elseif abatimento>9
    mult_abatimento=1.25;
else 
    mult_abatimento=1.00;
end

epi_1s=(10^-4)*(-8.09+Umi/15-Umi^2/2284-Umi^3/133765+Umi^4/7608150)*mult_abatimento;
epi_2s=(33+2*h_fic*100)/(20.8+3*h_fic*100);
eps_cs_inf=epi_1s*epi_2s;
eps_cs_inf_t0=eps_cs_inf*(1-beta_s);


%Fluência do concreto
phi = calc_coeficiente_fluencia(fck,viaduto.longarinas.delta_t_ef,Umi,viaduto.longarinas.s,h_fic,viaduto.longarinas.alfa_flu,Ti,abatimento);
% Fim da fluencia


alfa_e=viaduto.alfa_e;
Eci= calc_Eci(fck*1E6,alfa_e);%N/m² ou Pa modulo de elasticidade concreto
Eci=Eci/1000/(100^2);%kN/cm²
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade aço ativo
alfa_p=Ep/Eci;

ep=zeros(1,viaduto.disc_cabos+3);

Ap=cabo_eq_enc_ime.A;%cm²
Ap=Ap*10^-4;%m²

ro_p=Ap/All;
SigcP0g=zeros(1,viaduto.disc_cabos+3);
delta_SigP=zeros(1,viaduto.disc_cabos+3);
Perda_total=zeros(1,viaduto.disc_cabos+3);
SigPinf=zeros(1,viaduto.disc_cabos+3);
Pinf=zeros(1,viaduto.disc_cabos+3);
Sigcpd=zeros(1,viaduto.disc_cabos+3);
Pnd=zeros(1,viaduto.disc_cabos+3);
Epp=zeros(1,viaduto.disc_cabos+3);


SigPime=zeros(1,viaduto.disc_cabos+3);
epl=zeros(1,viaduto.disc_cabos+3);
Pime=zeros(1,viaduto.disc_cabos+3);
Sigcpdime=zeros(1,viaduto.disc_cabos+3);
Pndime=zeros(1,viaduto.disc_cabos+3);
Eppime=zeros(1,viaduto.disc_cabos+3);

Pato=zeros(1,viaduto.disc_cabos+3);

for s=1:viaduto.disc_cabos+3
    ep(s)=min(secaoll(:,2))+cabo_eq_enc_ime.y(s);
    eta=1+ep(s)^2*All/Iyll;
    SigP0=cabo_eq_enc_ime.Sig(s);%kN/cm²;
    SigcP0g(s)=(Mg(s)*1000*(-ep(s))/(Iyll)-(SigP0*10^7*Ap)/(All)*eta)/(10^7);
    delta_SigP(s)=(-eps_cs_inf_t0*Ep+alfa_p*-SigcP0g(s)*phi+SigP0*chi_inf(s))/...
        (1+chi_inf(s)+(1+phi/2)*alfa_p*eta*ro_p);
    Perda_total(s)=(SigPi-cabo_eq_enc_ime.Sig(s)+delta_SigP(s))/SigPi;

    % Propriedades do conjunto longarina laje no infinito
    SigPinf(s)=cabo_eq_enc_ime.Sig(s)-delta_SigP(s);
    Pinf(s)=SigPinf(s)*Ap*(100^2);%kN - Força de protensão no infinito
    Sigcpd(s)=(0.9*Pinf(s)*(1/All+ep(s)^2/Iyll))/100^2;%kN/cm² - Tensão no concreto no infinito
    Pnd(s)=0.9*Pinf(s)+alfa_p*(Ap*100^2)*Sigcpd(s);%kN
    Epp(s)=Pnd(s)/(Ep*(Ap*100^2));%Pré alongamento no infinito
    
    % Propriedades da longarina prémoldada no ato da protensão
    SigPime(s)=cabo_eq_enc_ime.Sig(s);
    epl(s)=ep(s)-(min(secaoll(:,2))-min(secaol(:,2)));
    Pime(s)=SigPime(s)*Ap*(100^2);%kN - Força de protensão imediata
    Sigcpdime(s)=(0.9*Pime(s)*(1/Al+epl(s)^2/Iyl))/100^2;%kN/cm² - Tensão no concreto imediata
    Pndime(s)=0.9*Pime(s)+alfa_p*(Ap*100^2)*Sigcpdime(s);%kN
    Eppime(s)=Pndime(s)/(Ep*(Ap*100^2));%Pré alongamento imediata
    
    Pato(s)=cabo_eq_ato.Sig(s)*Ap*(100^2);%kN - Força de protensão ato
end

var_T=eps_cs_inf_t0/viaduto.cdl-viaduto.delta_temperatura-median(Pinf)/((All*10^4)*Eci)*(phi)/viaduto.cdl;


%calculo do angulo com a horizontal do cabo resultante 
caboresul_teta_h(ndc+2)=0;
for i=1:ndc+2
    caboresul_teta_h(i)=atan((cabo_eq_enc_ime.y(i)-cabo_eq_enc_ime.y(i+1))/(cabo_eq_enc_ime.x(i+1)-cabo_eq_enc_ime.x(i)));
end
%plot(cabo(n).teta_h*180/pi())



info.longarinas.vao(vao_i).longarina(long_i).Eci=Eci;%kN/cm²
info.longarinas.vao(vao_i).longarina(long_i).phi=phi;
info.longarinas.vao(vao_i).longarina(long_i).var_T=var_T;
info.longarinas.vao(vao_i).longarina(n_longa-(long_i-1)).var_T=var_T;
info.longarinas.vao(vao_i).longarina(long_i).cabos=cabos;
info.longarinas.vao(vao_i).longarina(long_i).caboresul_teta_h=caboresul_teta_h;
info.longarinas.vao(vao_i).longarina(long_i).aal=aal;
info.longarinas.vao(vao_i).longarina(long_i).Epp=Epp;
info.longarinas.vao(vao_i).longarina(long_i).Eppime=Eppime;
info.longarinas.vao(vao_i).longarina(long_i).Ap=Ap;%m²
info.longarinas.vao(vao_i).longarina(long_i).ep=ep;%m
info.longarinas.vao(vao_i).longarina(long_i).epl=epl;%m
info.longarinas.vao(vao_i).longarina(long_i).Pinf=Pinf;%kN
info.longarinas.vao(vao_i).longarina(long_i).Pime=Pime;%kN
info.longarinas.vao(vao_i).longarina(long_i).Pato=Pato;%kN

if config_draw.forca_prot_inf
    draw_forca_prot_inf
end

if config_draw.perda_prot
    draw_perda_prot
end
end