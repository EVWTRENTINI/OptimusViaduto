
%% Vãos
parametros_gerador_modelo.L_vao = struct('min', 10, 'max', 45, 'discretizacao' , 1);

%% Fundação
parametros_gerador_modelo.fundacao.profundidade_fundacao = struct('min', 6, 'max', 20, 'discretizacao' , 1);
parametros_gerador_modelo.fundacao.d = struct('min', .7, 'max', 2, 'discretizacao' , .1);
parametros_gerador_modelo.fundacao.c = struct('min', .04, 'max', .1, 'discretizacao' , .0005);

%% Pilares
parametros_gerador_modelo.pilares.n = struct('min', 2, 'max', 5, 'discretizacao' , 1);
parametros_gerador_modelo.pilares.d = struct('min', .7, 'max', 2, 'discretizacao' , .05);
parametros_gerador_modelo.pilares.fck = struct('min', 25, 'max', 90, 'discretizacao' , 5); % Em MPa
parametros_gerador_modelo.pilares.c =  struct('min', .025, 'max', .1, 'discretizacao' , .0005);

%% Travessas
parametros_gerador_modelo.travessas.h = struct('min', .7, 'max', 2, 'discretizacao' , .05);
parametros_gerador_modelo.travessas.b = struct('min', .7, 'max', 2, 'discretizacao' , .05);
parametros_gerador_modelo.travessas.bl = struct('min', 0, 'max', 2, 'discretizacao' , .05);
parametros_gerador_modelo.travessas.fck = struct('min', 25, 'max', 90, 'discretizacao' , 5); % Em MPa
parametros_gerador_modelo.travessas.c =  struct('min', .025, 'max', .1, 'discretizacao' , .0005);

%% Tabuleiro - longarinas e lajes
parametros_gerador_modelo.tabuleiro.fck = struct('min', 25, 'max', 90, 'discretizacao' , 5); % Em MPa

%% Longarinas
parametros_gerador_modelo.longarinas.n = struct('min', 3, 'max', 15, 'discretizacao' , 1);
parametros_gerador_modelo.longarinas.b1 = struct('min', .25, 'max', 1.3, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.b2 = struct('min', .15, 'max', .3, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.b3 = struct('min', .25, 'max', 1, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.h1 = struct('min', 1, 'max', 2.5, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.h2 = struct('min', .05, 'max', .5, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.h3 = struct('min', .05, 'max', .5, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.h4 = struct('min', .05, 'max', .5, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.h5 = struct('min', .15, 'max', .5, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.enr = struct('min', .05, 'max', .35, 'discretizacao' , .05);
parametros_gerador_modelo.longarinas.benr = struct('min', .15, 'max', 1, 'discretizacao' , .01);
parametros_gerador_modelo.longarinas.c =  struct('min', .025, 'max', .06, 'discretizacao' , .0005);
parametros_gerador_modelo.longarinas.hap =  struct('min', .03, 'max', .075, 'discretizacao' , .005);

% Protensão
parametros_gerador_modelo.longarinas.ncp =  struct('min', 10, 'max', 80, 'discretizacao' , 1);
parametros_gerador_modelo.longarinas.hpa =  struct('min', .3, 'max', .7, 'discretizacao' , .01);% em porcentagem da altura
parametros_gerador_modelo.longarinas.hpc =  struct('min', .1, 'max', .35, 'discretizacao' , .01);% em porcentagem da altura

%% Lajes
parametros_gerador_modelo.lajes.h = struct('min', .17, 'max', .3, 'discretizacao' , .01);
parametros_gerador_modelo.lajes.c =  struct('min', .025, 'max', .06, 'discretizacao' , .0005);



