addpath('Análise Estrutural');
addpath('Desenhos');
addpath('Gerador de Modelo Estrutural');
addpath('Solicitações');
addpath('Dimensionamento');
addpath('Funções Objetivo');
addpath('Otimizacao');
addpath('Otimizacao/MOPSO');
addpath('Otimizacao/NSGAII');
addpath('Otimizacao/SPEA2');
addpath('Res');

fprintf([datestr(now,'HH:MM:SS') ': Avalia Mandaguaçu v1.0.\n']);
% v1.0 - Inicio da verificação do viaduto de Mandaguaçu

relatorio_tempo = true;
relatorio_erro = true;


%% Configuração de plotagem
config_draw_off
%config_draw_on

%% Opções do programa
config_padrao_viaduto_mandaguacu
viaduto_padrao = viaduto;
config_custos
config_emissoes
config_coeficientes_VUP



%% Terreno
terreno_mandaguacu

%% Cria viaduto


viaduto_mandaguacu
% Geral
greide.largura=viaduto.W;
greide.x(1)=viaduto.x_apoio(1);
greide.x(2)=viaduto.x_apoio(end);
parametros_gerador_modelo.longarinas.benr = struct('min', .15, 'max', 1, 'discretizacao' , .01);

viaduto_original = viaduto;
variaveis = viaduto2variaveis(viaduto_original);
viaduto_original = variaveis2viaduto(variaveis,viaduto_padrao,parametros_gerador_modelo,greide);

%% Avalia viaduto
[~, orcamento, impacto_ambiental, VUP, viaduto_pos_calculo, info, situacao, msg_erro] = ...
    avalia_viaduto_recalculo_protensao(viaduto_original, terreno, greide, impedido, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw);

writestruct(greide,greide.xml,)