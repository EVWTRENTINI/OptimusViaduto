function [legenda, legenda_longa, escala, unidade] = monta_legenda(nv_max)
legenda = strings(1,nv_max);
legenda_longa = strings(1,nv_max);
escala = ones(1,nv_max);
unidade = strings(1,nv_max);


n_apoios = variaveis2n_apoios(zeros(1,nv_max));
n = 1;
escala(n) = 100;
unidade(n) = ' cm';
legenda(n) = 'c_{f}';
legenda_longa(n) = 'Cobrimento das armaduras dos tubulões'; n = n + 1;

escala(n) = 1;
unidade(n) = ' MPa';
legenda(n) = 'f_{ck,p}';
legenda_longa(n) = 'Resistência característica do concreto dos pilares'; n = n + 1;

escala(n) = 100;
unidade(n) = ' cm';
legenda(n) = 'c_{p}';
legenda_longa(n) = 'Cobrimento das armaduras dos pilares'; n = n + 1;

escala(n) = 1;
unidade(n) = ' MPa';
legenda(n) = 'f_{ck,t}';
legenda_longa(n) = 'Resistência característica do concreto das travessas'; n = n + 1;

escala(n) = 100;
unidade(n) = ' cm';
legenda(n) = 'c_{t}';
legenda_longa(n) = 'Cobrimento das armaduras das travessas'; n = n + 1;

escala(n) = 1;
unidade(n) = ' MPa';
legenda(n) = 'f_{ck,tb}';
legenda_longa(n) = 'Resistência característica do concreto dos tabuleiros'; n = n + 1;

escala(n) = 100;
unidade(n) = ' cm';
legenda(n) = 'c_{lg}';
legenda_longa(n) = 'Cobrimento das armaduras das longarinas'; n = n + 1;

escala(n) = 100;
unidade(n) = ' cm';
legenda(n) = 'c_{lj}';
legenda_longa(n) = 'Cobrimento das armaduras das lajes'; n = n + 1;

% Primeiro e ultimo apoio
for i = [1 n_apoios]
    escala(n) = 1;
    unidade(n) = ' m';
    legenda(n) = ['p_{f,' num2str(i) '}'];              % 9    16
    legenda_longa(n) = ['Profundidade da fundação do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 1;
    unidade(n) = '';
    legenda(n) = ['N_{p,' num2str(i) '}'];             % 10   17
    legenda_longa(n) = ['Número de pilares do ' num2str(i) 'º apoio']; n = n + 1;


    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['D_{f,' num2str(i) '}'];              % 11   18
    legenda_longa(n) = ['Diâmetro dos fustes do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['D_{p,' num2str(i) '}'];              % 12   19
    legenda_longa(n) = ['Diâmetro dos pilares do ' num2str(i) 'º apoio']; n = n + 1;
    
    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['H_{t,' num2str(i) '}'];              % 13   20
    legenda_longa(n) = ['Altura da travessa do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['B_{t,' num2str(i) '}'];              % 14   21
    legenda_longa(n) = ['Largura da travessa do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['BL_{t,' num2str(i) '}'];             % 15   22
    legenda_longa(n) = ['Balanço da travessa do ' num2str(i) 'º apoio']; n = n + 1;
end

% Primeiro vão
for i = 1
    escala(n) = 1;
    unidade(n) = '';
    legenda(n) = ['N_{lg,' num2str(i) '}'];             % 23
    legenda_longa(n) = ['Número de longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 1000;
    unidade(n) = ' mm';
    legenda(n) = ['h_{e,' num2str(i) '}'];              % 24
    legenda_longa(n) = ['Altura dos aparelhos de apoio do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h1_{' num2str(i) '}'];               % 25
    legenda_longa(n) = ['Dimensão h1 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h2_{' num2str(i) '}'];               % 26
    legenda_longa(n) = ['Dimensão h2 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h3_{' num2str(i) '}'];               % 27
    legenda_longa(n) = ['Dimensão h3 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h4_{' num2str(i) '}'];               % 28
    legenda_longa(n) = ['Dimensão h4 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h5_{' num2str(i) '}'];               % 29
    legenda_longa(n) = ['Dimensão h5 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['b1_{' num2str(i) '}'];               % 30
    legenda_longa(n) = ['Dimensão b1 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['b2_{' num2str(i) '}'];               % 31
    legenda_longa(n) = ['Dimensão b2 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['b3_{' num2str(i) '}'];               % 32
    legenda_longa(n) = ['Dimensão b3 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = '%';
    legenda(n) = ['E_{l,' num2str(i) '}'];            % 33
    legenda_longa(n) = ['Comprimento do enrijecimento das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['E_{b,' num2str(i) '}'];            % 34
    legenda_longa(n) = ['Largura do enrijecimento das longarinas do ' num2str(i) 'º vão']; n = n + 1;
    
    escala(n) = 100;
    unidade(n) = '%';
    legenda(n) = ['h_{pc,' num2str(i) '}'];             % 35
    legenda_longa(n) = ['Altura dos cabos de protenção na ancoragem das longarinas do ' num2str(i) 'º vão']; n = n + 1;


    escala(n) = 100;
    unidade(n) = '%';
    legenda(n) = ['h_{pa,' num2str(i) '}'];             % 36
    legenda_longa(n) = ['Altura dos cabos de protenção no centro do vão das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 1;
    unidade(n) = '';
    legenda(n) = ['N_{cp,' num2str(i) '}'];             % 37
    legenda_longa(n) = ['Número de cordoalhas nas longarinas do ' num2str(i) 'º vão']; n = n + 1;


    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['H_{lj,' num2str(i) '}'];             % 38
    legenda_longa(n) = ['Altura da laje do ' num2str(i) 'º vão']; n = n + 1;
end

% Para cada vão adicional

for i = 2:n_apoios-1
    % Apoio
    escala(n) = 1;
    unidade(n) = ' m';
    legenda(n) = ['x_{p,' num2str(i) '}'];              % 39   63
    legenda_longa(n) = ['Posição do ' num2str(i) 'º apoio intermediário']; n = n + 1;

    escala(n) = 1;
    unidade(n) = ' m';
    legenda(n) = ['p_{f,' num2str(i) '}'];              % 40   64
    legenda_longa(n) = ['Profundidade da fundação do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 1;
    unidade(n) = '';
    legenda(n) = ['N_{p,' num2str(i) '}'];              % 41   65
    legenda_longa(n) = ['Número de pilares do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['D_{f,' num2str(i) '}'];             % 42   66
    legenda_longa(n) = ['Diâmetro dos fustes do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['D_{p,' num2str(i) '}'];              % 43   67
    legenda_longa(n) = ['Diâmetro dos pilares do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['H_{t,' num2str(i) '}'];              % 44   68
    legenda_longa(n) = ['Altura da travessa do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['B_{t,' num2str(i) '}'];             % 45   69
    legenda_longa(n) = ['Largura da travessa do ' num2str(i) 'º apoio']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['BL_{t,' num2str(i) '}'];             % 46   70
    legenda_longa(n) = ['Balanço da travessa do ' num2str(i) 'º apoio']; n = n + 1;

    % Vao
    escala(n) = 1;
    unidade(n) = '';
    legenda(n) = ['N_{lg,' num2str(i) '}'];             % 47   71
    legenda_longa(n) = ['Número de longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 1000;
    unidade(n) = ' mm';
    legenda(n) = ['h_{e,' num2str(i) '}'];              % 48   72
    legenda_longa(n) = ['Altura dos aparelhos de apoio do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h1_{' num2str(i) '}'];               % 49   73
    legenda_longa(n) = ['Dimensão h1 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h2_{' num2str(i) '}'];               % 50   74
    legenda_longa(n) = ['Dimensão h2 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h3_{' num2str(i) '}'];               % 51   75
    legenda_longa(n) = ['Dimensão h3 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h4_{' num2str(i) '}'];               % 52   76
    legenda_longa(n) = ['Dimensão h4 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['h5_{' num2str(i) '}'];               % 53   77
    legenda_longa(n) = ['Dimensão h5 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['b1_{' num2str(i) '}'];               % 54   78
    legenda_longa(n) = ['Dimensão b1 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['b2_{' num2str(i) '}'];               % 55   79
    legenda_longa(n) = ['Dimensão b2 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['b3_{' num2str(i) '}'];               % 56   80
    legenda_longa(n) = ['Dimensão b3 das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = '%';
    legenda(n) = ['E_{l,' num2str(i) '}'];            % 57   81
    legenda_longa(n) = ['Comprimento do enrijecimento das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['E_{b,' num2str(i) '}'];            % 58   82
    legenda_longa(n) = ['Largura do enrijecimento das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = '%';
    legenda(n) = ['h_{pc,' num2str(i) '}'];             % 59   83
    legenda_longa(n) = ['Altura dos cabos de protenção na ancoragem das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = '%';
    legenda(n) = ['h_{pa,' num2str(i) '}'];             % 60   84
    legenda_longa(n) = ['Altura dos cabos de protenção no centro do vão das longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 1;
    unidade(n) = '';
    legenda(n) = ['N_{cp,' num2str(i) '}'];             % 61   85
    legenda_longa(n) = ['Número de cordoalhas nas longarinas do ' num2str(i) 'º vão']; n = n + 1;

    escala(n) = 100;
    unidade(n) = ' cm';
    legenda(n) = ['H_{lj,' num2str(i) '}'];             % 62   86
    legenda_longa(n) = ['Altura da laje do ' num2str(i) 'º vão']; n = n + 1;
end
end