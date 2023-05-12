viaduto.W=14.0;%m

viaduto.n_apoios=3;


c=.03;
viaduto.fundacao.c = .04; 
viaduto.pilares.fck = 35E6;%Pa
viaduto.pilares.c = c;
viaduto.travessas.fck = 30E6;%Pa
viaduto.travessas.c = c; 
viaduto.tabuleiro.fck = 35E6;%Pa
viaduto.longarinas.c = c;

viaduto.lajes.c = c;


viaduto.x_apoio=[0 15.5 31];
viaduto.L=viaduto.x_apoio(end)-viaduto.x_apoio(1);%m


for i=1:viaduto.n_apoios
    viaduto.apoio(i).profundidade_fundacao = 16;
    viaduto.apoio(i).n_pilares=2;
    viaduto.apoio(i).fustes.d=1;%m
    viaduto.apoio(i).fustes.fck=viaduto.fundacao.fck;%Pa
    viaduto.apoio(i).fustes.c=viaduto.fundacao.c;%cobrimento em m
    viaduto.apoio(i).pilares.d=1;%m
    viaduto.apoio(i).pilares.fck=viaduto.pilares.fck;%Pa
    viaduto.apoio(i).pilares.c=viaduto.pilares.c;%cobrimento em m
    viaduto.apoio(i).travessa.h=1.4;%m
    viaduto.apoio(i).travessa.b=1.2;%m
    viaduto.apoio(i).travessa.bl=1.95;%m 
    viaduto.apoio(i).travessa.fck=viaduto.travessas.fck;%Pa
    viaduto.apoio(i).travessa.c=viaduto.travessas.c;%m
end

for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=(viaduto.x_apoio(i+1)-viaduto.x_apoio(i));%m
    viaduto.vao(i).n_longarinas=5;
    viaduto.vao(i).hap=.045;%m - altura aparelho de apoio
    viaduto.vao(i).laje.h=.23;%m
    viaduto.vao(i).laje.fck=viaduto.tabuleiro.fck;%Pa %deve ser o mesmo da longarina
    viaduto.vao(i).laje.c=viaduto.lajes.c;%m
    viaduto.vao(i).longarina.b1=0.8;%m
    viaduto.vao(i).longarina.b2=.2;%m
    viaduto.vao(i).longarina.b3=.5;%m
    viaduto.vao(i).longarina.h1=1.53;%m
    viaduto.vao(i).longarina.h2=.12;%m
    viaduto.vao(i).longarina.h3=.07;%m
    viaduto.vao(i).longarina.h4=.10;%m
    viaduto.vao(i).longarina.h5=.23;%m
    viaduto.vao(i).longarina.enr=.11;% multiplocador do comprimento da viga
    viaduto.vao(i).longarina.benr=.5;%m%largura do enrijecimento
    viaduto.vao(i).longarina.fck=viaduto.tabuleiro.fck;%Pa %deve ser o mesmo da laje
    viaduto.vao(i).longarina.c=viaduto.longarinas.c;%m
    viaduto.vao(i).amp=.12;% altura minima protensão, da face do cabo até o ponto mais inferior da longarina, em metros
    viaduto.vao(i).aap=0.75;% altura estimada do cg da protensão na ancoragem
    viaduto.vao(i).ntcord=13; %numero total de cordoalhas por longarina
end

