viaduto.W=16.2;%m
viaduto.L=greide.x(end);%m
viaduto.n_apoios=3;
viaduto.nfaixa=2;
viaduto.hpav=.1;%m
c=.03;%m
viaduto.h_bloco_enterrado=0;%metros


viaduto.x_apoio=[0 .5 1];

for i=1:viaduto.n_apoios
    viaduto.apoio(i).DPP=-5;%%m - Distancia do pilar a pista
    viaduto.apoio(i).cota_greide=interp1(greide.x,greide.z,viaduto.x_apoio(i)*viaduto.L);
    viaduto.apoio(i).cota_arrasamento=interp1([sondagem.x],[sondagem.nivel_terreno],viaduto.x_apoio(i)*viaduto.L)-viaduto.h_bloco_enterrado;%face superior do bloco
    viaduto.apoio(i).cota_fundacao=-10;
    viaduto.apoio(i).hap=.05;%m - altura aparelho de apoio
    viaduto.apoio(i).kap=1E6;%N/m - rigidez aparelho de apoio
    viaduto.apoio(i).n_pilares=4;
    viaduto.apoio(i).fustes.d=.9;%m
    viaduto.apoio(i).fustes.fck=25E6;%Pa
    viaduto.apoio(i).fustes.gama_c=3.1;% Escavado sem fluido
    viaduto.apoio(i).fustes.c=.04;%cobrimento em m
    viaduto.apoio(i).fustes.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
    viaduto.apoio(i).fustes.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
    viaduto.apoio(i).fustes.fi_t=.008;%diametro da armadura transversal em m
    viaduto.apoio(i).pilares.d=1;%m
    viaduto.apoio(i).pilares.fck=30E6;%Pa
    viaduto.apoio(i).pilares.c=c;%cobrimento em m
    viaduto.apoio(i).pilares.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
    viaduto.apoio(i).pilares.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
    viaduto.apoio(i).pilares.fi_t=.008;%diametro da armadura transversal em m
    viaduto.apoio(i).travessa.h=1.4;%m
    viaduto.apoio(i).travessa.b=1.4;%m
    viaduto.apoio(i).travessa.bl=1.325;%m 
    viaduto.apoio(i).travessa.fck=30E6;%Pa
    viaduto.apoio(i).travessa.c=c;%m
end
%'viaduto_exStucchi'
for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=viaduto.L*(viaduto.x_apoio(i+1)-viaduto.x_apoio(i));%m
    viaduto.vao(i).n_longarinas=7;
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
    viaduto.vao(i).longarina.enr=.2;% multiplicador do comprimento da viga
    viaduto.vao(i).longarina.benr=.4;%m%largura do enrijecimento
    viaduto.vao(i).longarina.fck=35E6;%Pa
    viaduto.vao(i).longarina.c=c;%m
end
config_padrao_viaduto
viaduto.apoio(1).cota_fundacao=viaduto.apoio(1).cota_arrasamento-10
viaduto.apoio(2).cota_fundacao=viaduto.apoio(2).cota_arrasamento-10
viaduto.apoio(2).n_pilares=6
viaduto.apoio(2).travessa.bl=0;%m
'corrigindo altura da fundação do centro viaduto_exStucchi_mestrado.m'
[MA,info]=cria_viaduto(viaduto,rigidez_solo,sondagem);
clear i 