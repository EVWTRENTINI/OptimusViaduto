viaduto.W=16.2;%m
viaduto.L=70.35;%m
viaduto.n_apoios=2;
viaduto.nfaixa=2;
viaduto.hpav=.1;%m
config_padrao_viaduto
for i=1:viaduto.n_apoios
    viaduto.apoio(i).DPP=-5;%%m - Distancia do pilar a pista
    viaduto.apoio(i).cota_greide=7.95;
    viaduto.apoio(i).cota_arrasamento=0;%face superior do bloco
    viaduto.apoio(i).cota_fundacao=-6;
    viaduto.apoio(i).hap=.05;%m - altura aparelho de apoio
    viaduto.apoio(i).kap=1E6;%N/m - rigidez aparelho de apoio
    viaduto.apoio(i).n_pilares=3;
    viaduto.apoio(i).fustes.d=.6;%m
    viaduto.apoio(i).fustes.fck=20E6;%Pa
    viaduto.apoio(i).pilares.d=.7;%m
    viaduto.apoio(i).pilares.fck=30E6;%Pa
    viaduto.apoio(i).travessa.h=.8;%m
    viaduto.apoio(i).travessa.b=.8;%m
    viaduto.apoio(i).travessa.bl=1.325;%m 
    viaduto.apoio(i).travessa.fck=30E6;%Pa
end
%'viaduto_exStucchi'
for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=40.250;%m
    viaduto.vao(i).n_longarinas=7;
    viaduto.vao(i).laje.h=.2;%m
    viaduto.vao(i).laje.fck=35E6;%Pa
    viaduto.vao(i).longarina.b1=1.2;%m
    viaduto.vao(i).longarina.b2=.2;%m
    viaduto.vao(i).longarina.b3=.7;%m
    viaduto.vao(i).longarina.h1=1.8;%m
    viaduto.vao(i).longarina.h2=.12;%m
    viaduto.vao(i).longarina.h3=.08;%m
    viaduto.vao(i).longarina.h4=.2;%m
    viaduto.vao(i).longarina.h5=.25;%m
    viaduto.vao(i).longarina.enr=.2;% multiplocador do comprimento da viga
    viaduto.vao(i).longarina.fck=35E6;%Pa
    viaduto.vao(i).longarina.c=.03;%m
end

[MA,info]=cria_viaduto(viaduto);
clear i 