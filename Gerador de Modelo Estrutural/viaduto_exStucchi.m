viaduto.W=16.2;%m

viaduto.n_apoios=2;


c=.03;
viaduto.fundacao.c = .04; 
viaduto.pilares.fck = 30E6;%Pa
viaduto.pilares.c = c;
viaduto.travessas.fck = 30E6;%Pa
viaduto.travessas.c = c; 
viaduto.tabuleiro.fck = 35E6;%Pa
viaduto.longarinas.c = c;

viaduto.lajes.c = c;


viaduto.x_apoio=[0 39];
viaduto.L=viaduto.x_apoio(end)-viaduto.x_apoio(1);%m


for i=1:viaduto.n_apoios
    viaduto.apoio(i).profundidade_fundacao = 10;
    viaduto.apoio(i).n_pilares=3;
    viaduto.apoio(i).fustes.d=.9;%m
    viaduto.apoio(i).fustes.fck=viaduto.fundacao.fck;%Pa
    viaduto.apoio(i).fustes.gama_c=3.1;% Escavado sem fluido
    viaduto.apoio(i).fustes.c=viaduto.fundacao.c;%cobrimento em m
    viaduto.apoio(i).fustes.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
    viaduto.apoio(i).fustes.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
    viaduto.apoio(i).fustes.fi_t=.008;%diametro da armadura transversal em m
    viaduto.apoio(i).pilares.d=1;%m
    viaduto.apoio(i).pilares.fck=viaduto.pilares.fck;%Pa
    viaduto.apoio(i).pilares.c=viaduto.pilares.c;%cobrimento em m
    viaduto.apoio(i).pilares.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
    viaduto.apoio(i).pilares.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
    viaduto.apoio(i).pilares.fi_t=.008;%diametro da armadura transversal em m
    viaduto.apoio(i).travessa.h=1.4;%m
    viaduto.apoio(i).travessa.b=1.4;%m
    viaduto.apoio(i).travessa.bl=1.325;%m 
    viaduto.apoio(i).travessa.fck=viaduto.travessas.fck;%Pa
    viaduto.apoio(i).travessa.c=viaduto.travessas.c;%m
end
%'viaduto_exStucchi'
for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=(viaduto.x_apoio(i+1)-viaduto.x_apoio(i));%m
    viaduto.vao(i).n_longarinas=7;
    viaduto.vao(i).hap=.073;%m - altura aparelho de apoio
    viaduto.vao(i).laje.h=.2;%m
    viaduto.vao(i).laje.fck=viaduto.tabuleiro.fck;%Pa %deve ser o mesmo da longarina
    viaduto.vao(i).laje.c=viaduto.lajes.c;%m
    viaduto.vao(i).lajes.fi_l=.016;% diametro da armadura long em metros
    viaduto.vao(i).longarina.b1=1.2;%m
    viaduto.vao(i).longarina.b2=.2;%m
    viaduto.vao(i).longarina.b3=.7;%m
    viaduto.vao(i).longarina.h1=2;%m
    viaduto.vao(i).longarina.h2=.12;%m
    viaduto.vao(i).longarina.h3=.08;%m
    viaduto.vao(i).longarina.h4=.2;%m
    viaduto.vao(i).longarina.h5=.25;%m
    viaduto.vao(i).longarina.enr=8/39;% multiplocador do comprimento da viga
    viaduto.vao(i).longarina.benr=.3;%m%largura do enrijecimento
    viaduto.vao(i).longarina.fck=viaduto.tabuleiro.fck;%Pa %deve ser o mesmo da laje
    viaduto.vao(i).longarina.c=viaduto.longarinas.c;%m
    viaduto.vao(i).amp=.10;% altura minima protensão, da face do cabo até o ponto mais inferior da longarina, em metros
    viaduto.vao(i).aap=1.3;% altura estimada do cg da protensão na ancoragem
    viaduto.vao(i).ntcord=52; %numero total de cordoalhas por longarina
end

