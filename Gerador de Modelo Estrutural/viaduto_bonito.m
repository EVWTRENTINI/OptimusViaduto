viaduto.W=16.2;%m
viaduto.L=greide.x(end);%m
viaduto.n_apoios=4;
viaduto.nfaixa=2;
viaduto.hpav=.1;%m
c=.03;
viaduto.h_bloco_enterrado=0;%metros

viaduto.x_apoio=[0 15/55 40/55  1];

for i=1:viaduto.n_apoios
    viaduto.apoio(i).DPP=-5;%%m - Distancia do pilar a pista
    viaduto.apoio(i).cota_greide=interp1(greide.x,greide.z,viaduto.x_apoio(i)*viaduto.L);
    viaduto.apoio(i).cota_topo_bloco=interp1([sondagem.x],[sondagem.nivel_terreno],viaduto.x_apoio(i)*viaduto.L)-viaduto.h_bloco_enterrado;
    viaduto.apoio(i).cota_fundacao=-10;
    viaduto.apoio(i).n_pilares=3;
    viaduto.apoio(i).fustes.d=1;%m
    viaduto.apoio(i).fustes.fck=25E6;%Pa
    viaduto.apoio(i).fustes.gama_c=3.1;% Escavado sem fluido
    viaduto.apoio(i).fustes.c=.04;%cobrimento em m
    viaduto.apoio(i).fustes.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
    viaduto.apoio(i).fustes.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
    viaduto.apoio(i).fustes.fi_t=.008;%diametro da armadura transversal em m
    viaduto.apoio(i).blocos.c=c;%cobrimento em m
    viaduto.apoio(i).pilares.d=1.2;%m
    viaduto.apoio(i).pilares.fck=30E6;%Pa
    viaduto.apoio(i).pilares.c=c;%cobrimento em m
    viaduto.apoio(i).pilares.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
    viaduto.apoio(i).pilares.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
    viaduto.apoio(i).pilares.fi_t=.008;%diametro da armadura transversal em m
    viaduto.apoio(i).travessa.h=1;%m
    viaduto.apoio(i).travessa.b=1.2;%m
    viaduto.apoio(i).travessa.bl=1.325;%m
    viaduto.apoio(i).travessa.fck=30E6;%MPa
    viaduto.apoio(i).travessa.c=c;%m
end

for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=viaduto.L*(viaduto.x_apoio(i+1)-viaduto.x_apoio(i));%m
    viaduto.vao(i).n_longarinas=7;
    viaduto.vao(i).hap=.073;%m - altura aparelho de apoio
    viaduto.vao(i).laje.h=.2;%m
    viaduto.vao(i).laje.fck=35E6;%Pa
    viaduto.vao(i).lajes.fi_l=.016;% diametro da armadura long em metros
    viaduto.vao(i).laje.c=c;%m
    viaduto.vao(i).longarina.b1=1.2;%m
    viaduto.vao(i).longarina.b2=.2;%m
    viaduto.vao(i).longarina.b3=.7;%m
    viaduto.vao(i).longarina.h1=1.8;%m
    viaduto.vao(i).longarina.h2=.12;%m
    viaduto.vao(i).longarina.h3=.08;%m
    viaduto.vao(i).longarina.h4=.2;%m
    viaduto.vao(i).longarina.h5=.25;%m
    viaduto.vao(i).longarina.enr=.2;% Porcentagem do comprimento da viga
    viaduto.vao(i).longarina.benr=.3;%m%largura do enrijecimento
    viaduto.vao(i).longarina.fck=35E6;%Pa
    viaduto.vao(i).longarina.c=c;%m
    viaduto.vao(i).amp=.10;% altura minima protensão, da face do cabo até o ponto mais inferior da longarina, em metros
    viaduto.vao(i).aap=1.3;% altura estimada do cg da protensão na ancoragem
    viaduto.vao(i).danc=danc;% distancia entre eixo de ancoragens de protensão
    viaduto.vao(i).ntcord=52; %numero total de cordoalhas por longarina
end



viaduto.vao(2).longarina.h1=2.1;%m


viaduto.apoio(1).n_pilares=2;
viaduto.apoio(4).n_pilares=2;


viaduto.apoio(2).travessa.h=1.1;%m
viaduto.apoio(2).travessa.b=1.3;%m
viaduto.apoio(3).travessa.h=1.1;%m
viaduto.apoio(3).travessa.b=1.3;%m

config_padrao_viaduto

viaduto.vao(1).ntcord=20; %numero total de cordoalhas por longarina
viaduto.vao(2).ntcord=30;
viaduto.vao(3).ntcord=20;
