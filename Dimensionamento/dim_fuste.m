function [Asl,Ast,Aslt,situacao,msg_erro] = dim_fuste(ENVFUS,fator_amp,fuste,viaduto,config_draw)
%Dimensiona os fustes 
%   Utilizando integral analitica dastensões sobre a
%poligonal que descreve a seção transversal
%Não funciona com longarinas depois do eixo de simetria

%% inicialização das variaveis 
Asl=0;
Ast=0;
Aslt=0;
situacao=true;
msg_erro='sem erro';


%% Propriedade dos fustes
diam=fuste.d;%m
fck=fuste.fck/1E6;%MPa;
gama_c=viaduto.fustes.gama_c;

c=fuste.c;%m
fi_l_max = viaduto.fustes.fi_l_max;%m
fi_l_min = viaduto.fustes.fi_l_min;%m
fi_t = viaduto.fustes.fi_t;%m
dmag=viaduto.dia_max_agr_grau;

Es=viaduto.Es;%kN/cm² %modulo de elasticidade aço passivo
fpyd=viaduto.fpyd;%kN/cm² 
fptd=viaduto.fptd;%kN/cm² 
Eppu=viaduto.Eppu;%‰
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade
fyd=viaduto.fyk/viaduto.gama_s;


%% Propriedades da seção transversal
n_pontos_disc_secao=32;
[secaox,secaoy]=circulo(diam/2,n_pontos_disc_secao);
secao(:,1)=secaox;secao(:,2)=secaoy;
[geom,iner,~] = polygeom(secao(:,1),secao(:,2));
Ac=geom(1);
u=geom(4);
I=iner(1);

%% Propriedades da armadura ativa (nula)
aa.x=0; aa.y=0; aa.A=0; aa.Epp=0; aa.dcabo=0; aa.ncord=0; aa.n=0;

%% Esforços dimensionamentes
Msd=double(ENVFUS.MAX.Mabs/1000)*fator_amp;                      %Momento fletor maximo absoluto multiplicado pelo fator de ampliação de primeira para segunda ordem, em kN.m
Nsd_max=double(max(ENVFUS.MAX.Nx)/1000);                         %Esforço normal máximo (tração) em kN
Nsd_min=double(min(ENVFUS.MIN.Nx)/1000);                         %Esforço normal máximo (compressão) em kN
Vy_max=double(max([abs(ENVFUS.MAX.Vy) abs(ENVFUS.MIN.Vy)])/1000);%Esforço cortante y máximo em kN
Vz_max=double(max([abs(ENVFUS.MAX.Vz) abs(ENVFUS.MIN.Vz)])/1000);%Esforço cortante z máximo em kN
Vsd=sqrt(Vy_max^2+Vz_max^2);                                     %Resultante do esforço cortante maximo em kN
Tsd=double(max(abs([ENVFUS.MAX.Tx ENVFUS.MIN.Tx]))/1000);        %Esforço torçõr máximo em kN.m

%% Dimensionamento a flexão longitudinal
As_min=Ac*.4/100;%minima %NBR 6122:2019
As_max=Ac*4/100;%máxima

[Asl_Nmax,situacao,msg_erro] = flexao_circular(secao,diam,fck,gama_c,Msd,Nsd_max,aa,c,As_min,As_max,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
if not(situacao)
    msg_erro=[msg_erro ' Fuste com normal máxima'];
    return
end
[Asl_Nmin,situacao,msg_erro] = flexao_circular(secao,diam,fck,gama_c,Msd,Nsd_min,aa,c,As_min,As_max,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
if not(situacao)
    msg_erro=[msg_erro ' Fuste com normal mínima'];
    return
end
Asl=max([Asl_Nmax Asl_Nmin])*10^4;

%% Dimensionamento a esforço cortante e torção
d=.72*diam;%Resistência à força cortante de vigas de concreto armado com seção transversal circular - RIEM 2012
b=diam;%Resistência à força cortante de vigas de concreto armado com seção transversal circular - RIEM 2012
A=diam^2*pi/4;
u=diam*pi;
c1=c+fi_t+fi_l_max/2;
Ae=(diam-c1*2)^2*pi/4;
I=pi*diam^4/64;
ymin=diam/2;



[Ast,Aslt,situacao,msg_erro] = dim_cisalhamento(Vsd,0,0,Tsd,0,0,-Nsd_min,d,A,u,Ae,I,b,c1,ymin,Msd,fck,gama_c);
if not(situacao)
    msg_erro=[msg_erro ' Fuste.'];
    return
end





end