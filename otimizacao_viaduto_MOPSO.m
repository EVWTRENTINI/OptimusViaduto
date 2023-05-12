%addpath('Análise Estrutural');
%addpath('Desenhos');
%addpath('Gerador de Modelo Estrutural');
%addpath('Solicitações');
%addpath('Dimensionamento');
%addpath('Funções Objetivo');
%addpath('Otimizacao');
%addpath('Otimizacao/MOPSO');
%addpath('Otimizacao/NSGAII');
%addpath('Otimizacao/SPEA2');
%addpath('Interface');
%addpath('Res');

fprintf([datestr(now,'HH:MM:SS') ': MOPSO v1.0.\n']);
% v1.0:
% - Le todas as informações iniciais de arquivos *.xml. 
% - Arrumou o problema do corta_pol_1linha onde o corte falha.
% - Ralocação do inicio, fim e largura do "parametros_gerador_modelo" para "greide"
% - Remoção de n_vaos do parametros_gerador_modelo

relatorio_tempo = false;
relatorio_erro = false;

min_or_max = [1,1,-1]; % 1 para minimizar e -1 para maximizar
upper_bound = [5000000 2000 0];
log_hv_freq = 10;

% Opçoes de salvamento
log_var_freq = 10;
mcrdir = diretorio_mcr();

%% Configuração de plotagem
config_draw_off
%config_draw_on

%% Opções do programa
[parametros_gerador_modelo, parametros_gerador_modelo_relativo, viaduto_padrao, custos, emissoes, coeficientes_VUP, greide, impedido, terreno, parametros_MOPSO] = ler_input_arquivos(mcrdir);

[pop_size, archive_size, bottom, top, w_min, w_max, c1, c2, c3i, p1, maxgen, mut_prob, eta_m] = individualiza_parametros_MOPSO(parametros_MOPSO);

%% Inicialização da população
[vaos_unicos, quantidade_type, minvalue, maxvalue, discvalue, populacao] = inicializa_populacao(parametros_gerador_modelo, impedido, pop_size, viaduto_padrao, terreno, greide, parametros_gerador_modelo_relativo, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw);




%% Inicializa o arquivo geral
archive = cell(1,archive_size);

n_archive = 0;

%% Atualiza o arquivo geral

[archive, n_archive] = update_archive(populacao, n_archive, archive, min_or_max, bottom);

%% Inicializa o arquivo de cada tipo de particula
[tamanho_archive_type, ~] = divide_populacao_por_grupo_vao(vaos_unicos, archive_size);
archive_type = cell(1,quantidade_type);
for i = 1:quantidade_type
    archive_type{i} = cell(1,tamanho_archive_type(i));
end
n_archive_type = [0, 0, 0];

%% Atualiza o arquivo de cada tipo de particula

[archive_type, n_archive_type] = update_archive_type(populacao, quantidade_type, archive_type, n_archive_type, min_or_max, bottom);


%% Inicializa o armazenador de hypervolume

hypervolume = zeros(1,fix(maxgen/log_hv_freq));

%% Inicializa o armazenador de variaveis

variaveis = cell(1,fix(maxgen/log_var_freq));



%% Inicializa variaveis para desenho
archive_fitness = cell(1,maxgen);


%% Inicializador do contador de tempo
tempo_analise = zeros(1,maxgen);
t_inicio_analise = tic;


%% Processo iterativo - MAIN LOOP
t = 1;

%%
while t <= maxgen
    fprintf( [datestr(now,'HH:MM:SS') ': Iteração número ' num2str(t) '.\n']);
    
    [populacao, archive, n_archive, archive_type, n_archive_type] = iteracao_MOPSO(populacao, archive, n_archive, quantidade_type, archive_type, n_archive_type, w_max, w_min, t, maxgen, c3i, top, p1, c1, c2, minvalue, maxvalue, discvalue, mut_prob, eta_m, impedido, parametros_gerador_modelo, viaduto_padrao, terreno, greide, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, min_or_max, bottom, config_draw);



    %% Calcula o hypervolume

    if rem(t,log_hv_freq) == 0
        hypervolume(fix(t/log_hv_freq)) = calc_hypervolume(archive,n_archive, min_or_max, upper_bound);
        fprintf( [datestr(now,'HH:MM:SS') ': Hypervolume: ' num2str(hypervolume(fix(t/log_hv_freq))/1E9) ' G.\n']);
    end


    %% Anota variaveis
    if rem(t,log_var_freq) == 0
        variaveis{fix(t/log_hv_freq)} = cell(1,length(populacao));
        for i = 1:length(populacao)
            if populacao{i}.violations == 0
                variaveis{fix(t/log_hv_freq)}{i} = populacao{i}.variaveis;
            end
        end
    end


    %% Anota o tempo

    tempo_analise(t) = toc(t_inicio_analise);


    %% Prepara archive_fitness para salvar
    archive_fitness{t} = zeros(n_archive,3);
    for i = 1:n_archive
        archive_fitness{t}(i,:) = archive{i}.fitness;
    end

    %% Salva progresso para o caso de interrupção 

    save([mcrdir 'saida_MOPSO'] ,'parametros_MOPSO','tempo_analise','t','populacao', 'archive', 'n_archive', 'archive_type', 'n_archive_type', 'hypervolume', 'variaveis', 'archive_fitness')


    %% Itera contador

    t = t + 1;
    

end
fprintf([datestr(now,'HH:MM:SS') ': Fim da análise.\n']);

