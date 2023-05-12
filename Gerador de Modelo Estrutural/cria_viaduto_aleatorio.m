function viaduto = cria_viaduto_aleatorio(apoios_possiveis, viaduto, terreno, greide, pgm)
% Cria viaduto aleatorio baseado nos parametros estipulados
viaduto.W = greide.largura;
viaduto.L = greide.x(end)-greide.x(1);

[n_combinacoes_apoios_possiveis,viaduto.n_apoios] = size(apoios_possiveis);
 
viaduto.x_apoio = apoios_possiveis(randi([1 n_combinacoes_apoios_possiveis]),:);


viaduto.fundacao.c = aleatorio_entre_arredondado(pgm.fundacao.c);

viaduto.pilares.fck = aleatorio_entre_arredondado(pgm.pilares.fck)*(1E6);
viaduto.pilares.c =   aleatorio_entre_arredondado(pgm.pilares.c);

viaduto.travessas.fck = aleatorio_entre_arredondado(pgm.travessas.fck)*(1E6);
viaduto.travessas.c =   aleatorio_entre_arredondado(pgm.travessas.c);

viaduto.tabuleiro.fck = aleatorio_entre_arredondado(pgm.tabuleiro.fck)*(1E6);

viaduto.longarinas.fck = viaduto.tabuleiro.fck;
viaduto.longarinas.c =   aleatorio_entre_arredondado(pgm.travessas.c);

viaduto.lajes.fck = viaduto.tabuleiro.fck;
viaduto.lajes.c =   aleatorio_entre_arredondado(pgm.lajes.c);

for i=1:viaduto.n_apoios
    viaduto.apoio(i).profundidade_fundacao = aleatorio_entre_arredondado(pgm.fundacao.profundidade_fundacao);

    viaduto.apoio(i).n_pilares = aleatorio_entre_arredondado(pgm.pilares.n);
    
    viaduto.apoio(i).fustes.d = aleatorio_entre_arredondado(pgm.fundacao.d);
    viaduto.apoio(i).fustes.fck = viaduto.fundacao.fck;%Pa
    viaduto.apoio(i).fustes.c = viaduto.fundacao.c;%cobrimento em m

    viaduto.apoio(i).pilares.d = aleatorio_entre_arredondado(pgm.pilares.d);
    viaduto.apoio(i).pilares.fck = viaduto.pilares.fck;%Pa
    viaduto.apoio(i).pilares.c = viaduto.pilares.c;%cobrimento em m

    viaduto.apoio(i).travessa.h = aleatorio_entre_arredondado(pgm.travessas.h);
    viaduto.apoio(i).travessa.b = aleatorio_entre_arredondado(pgm.travessas.b);
    viaduto.apoio(i).travessa.bl = aleatorio_entre_arredondado(pgm.travessas.bl);
    viaduto.apoio(i).travessa.fck = viaduto.travessas.fck;%Pa
    viaduto.apoio(i).travessa.c = viaduto.travessas.c;%m
end

for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=(viaduto.x_apoio(i+1)-viaduto.x_apoio(i));%m
    viaduto.vao(i).n_longarinas = aleatorio_entre_arredondado(pgm.longarinas.n);
    viaduto.vao(i).hap = aleatorio_entre_arredondado(pgm.longarinas.hap);%m - altura aparelho de apoio

    
    viaduto.vao(i).longarina.b1 = aleatorio_entre_arredondado(pgm.longarinas.b1);
    viaduto.vao(i).longarina.b2 = aleatorio_entre_arredondado(pgm.longarinas.b2);
    viaduto.vao(i).longarina.b3 = aleatorio_entre_arredondado(pgm.longarinas.b3);
    viaduto.vao(i).longarina.h1 = aleatorio_entre_arredondado(pgm.longarinas.h1);
    viaduto.vao(i).longarina.h2 = aleatorio_entre_arredondado(pgm.longarinas.h2);
    viaduto.vao(i).longarina.h3 = aleatorio_entre_arredondado(pgm.longarinas.h3);
    viaduto.vao(i).longarina.h4 = aleatorio_entre_arredondado(pgm.longarinas.h4);
    viaduto.vao(i).longarina.h5 = aleatorio_entre_arredondado(pgm.longarinas.h5);
    viaduto.vao(i).longarina.enr = aleatorio_entre_arredondado(pgm.longarinas.enr);
    viaduto.vao(i).longarina.benr = aleatorio_entre_arredondado(pgm.longarinas.benr);
    viaduto.vao(i).longarina.fck = viaduto.longarinas.fck;%Pa %deve ser o mesmo da laje
    viaduto.vao(i).longarina.c = viaduto.longarinas.c;%m
    viaduto.vao(i).amp = aleatorio_entre_arredondado(pgm.longarinas.hpc) * viaduto.vao(i).longarina.h1;% altura minima protensão, da face do cabo até o ponto mais inferior da longarina, em metros
    viaduto.vao(i).aap=aleatorio_entre_arredondado(pgm.longarinas.hpa) * viaduto.vao(i).longarina.h1;% altura estimada do cg da protensão na ancoragem
    viaduto.vao(i).ntcord = aleatorio_entre_arredondado(pgm.longarinas.ncp); %numero total de cordoalhas por longarina

    viaduto.vao(i).laje.h = aleatorio_entre_arredondado(pgm.lajes.h);%m
    viaduto.vao(i).laje.fck = viaduto.lajes.fck;%Pa %deve ser o mesmo da longarina
    viaduto.vao(i).laje.c = viaduto.lajes.c;%m
end


end


