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
%addpath('Res');

relatorio_tempo = false;
relatorio_erro = false;

min_or_max = [1,1,-1]; % 1 para minimizar e -1 para maximizar
upper_bound = [5000000 2000 0];
log_hv_freq = 10;

% Opçoes de salvamento
algoritimo = 'NSGAII';
mcrdir = diretorio_mcr();

%% Configuração de plotagem
config_draw_off
%config_draw_on

%% Opções do programa
config_gerador_modelo
config_gerador_modelo_relativo
config_padrao_viaduto
config_custos
config_emissoes
config_coeficientes_VUP

viaduto_padrao = viaduto;

%% Terreno
terreno_exemplo_simetrico

%% Opções NSGA-II

parametros_NSGAII.pop_size = 100; % Tamanho da população - PRECISA SER PAR!
parametros_NSGAII.maxgen = 10000; % Numero máximo de iterações
parametros_NSGAII.p_c = .9; % Probabilidade de cruzamento
parametros_NSGAII.p_m = .25; % Probabilidade de mutação - recomendado 1/numero_variaveis %.2 % .2 %.5
parametros_NSGAII.eta_c = 5; % SBX - Operador de cruzamento % 20 % 40 % 5
parametros_NSGAII.eta_m = 10; % Polynomial mutation operator % 2  % 60 % 10


%% Inicialização da população
pop_size = parametros_NSGAII.pop_size;
maxgen = parametros_NSGAII.maxgen;
p_c = parametros_NSGAII.p_c;
p_m = parametros_NSGAII.p_m;
eta_c = parametros_NSGAII.eta_c;
eta_m = parametros_NSGAII.eta_m;

% Construção dos vãos possíveis
[apoios_possiveis, n_vaos_possiveis, vaos_unicos] = cria_apoios_possiveis(greide.x(1), greide.x(end), impedido, parametros_gerador_modelo.L_vao);

% Construção da população inicial
[tamanho_grupos_vao, quantidade_type] = divide_populacao_por_grupo_vao(vaos_unicos, pop_size);

% Define vetor de limites
[minvalue, maxvalue, discvalue] = define_valores_limites(vaos_unicos, parametros_gerador_modelo, greide);

% inicializa população
populacao = cell(1,pop_size);

% Barra de progresso
% posicao_barra = 0;
% barra_criacao = waitbar(posicao_barra,['Criando população inicial... (0/' num2str(length(populacao)) ')']);
% total_barra = sum(vaos_unicos.^1.6 .* tamanho_grupos_vao);

% inicializa o contador de tempo
t_geracao_populacao_ini = tic;

delete(gcp('nocreate'))
myCluster = parcluster('local');
parpool('processes',myCluster.NumWorkers);

% inicializa batch
batch_size = myCluster.NumWorkers;
batch = cell(1,batch_size);



fprintf([datestr(now,'HH:MM:SS') ': Iniciando a criação da população aleatória.\n']);
flag_sucesso = false;

n_sucessos_populacao = 0;
for g = 1 : quantidade_type
    n_vaos_desejados = vaos_unicos(g);
    apoios_possiveis_para_teste_n_vaos = [apoios_possiveis{n_vaos_possiveis==n_vaos_desejados}];

    n_sucessos_grupo_atual = 0;
    while true 
        parfor i = 1 : batch_size
            %fprintf( ['Tentativa número ' num2str(i) '.\n']);
            batch{i}.viaduto_original = cria_viaduto_aleatorio_relativo(transpose(reshape(apoios_possiveis_para_teste_n_vaos,n_vaos_desejados+1,[])), viaduto_padrao, terreno, greide, parametros_gerador_modelo, parametros_gerador_modelo_relativo);
            [~, batch{i}.orcamento, batch{i}.impacto_ambiental, batch{i}.VUP, batch{i}.viaduto, ~, batch{i}.situacao, batch{i}.msg_erro] = ...
                avalia_viaduto_recalculo_protensao(batch{i}.viaduto_original, terreno, greide, impedido, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw);
        end
        for i = 1 : batch_size
            if batch{i}.situacao
                flag_sucesso = true;
                n_sucessos_populacao = n_sucessos_populacao + 1;
                n_sucessos_grupo_atual = n_sucessos_grupo_atual + 1;
                populacao{n_sucessos_populacao} = batch{i};
                populacao{n_sucessos_populacao}.type = g;
                populacao{n_sucessos_populacao}.variaveis = viaduto2variaveis(populacao{n_sucessos_populacao}.viaduto);
                populacao{n_sucessos_populacao}.fitness = [populacao{n_sucessos_populacao}.orcamento.TOTAL populacao{n_sucessos_populacao}.impacto_ambiental.TOTAL populacao{n_sucessos_populacao}.VUP.min];
                populacao{n_sucessos_populacao}.violations = 0; 

                % Barra de progresso
%                 posicao_barra = posicao_barra + (n_vaos_desejados.^1.6)/total_barra;
%                 waitbar(posicao_barra,barra_criacao,['Criando população inicial... (' num2str(n_sucessos_populacao) '/' num2str(length(populacao)) ')']);

                if n_sucessos_grupo_atual == tamanho_grupos_vao(g); break; end
            end
        end
        if flag_sucesso
            flag_sucesso = false;
            fprintf([datestr(now,'HH:MM:SS') ': Já foram criados ' num2str(n_sucessos_populacao) ' viadutos aleatórios com sucesso.\n']);
        end
        if n_sucessos_grupo_atual == tamanho_grupos_vao(g); break; end
    end
end
% Barra de progresso
%delete(barra_criacao);

t_geracao_populacao_fim = toc(t_geracao_populacao_ini);
fprintf([datestr(now,'HH:MM:SS') ': Populacao inicial gerada em ' num2str(t_geracao_populacao_fim) ' segundos.\n']);


%% Separa fitness da populacao
fitness = zeros(length(populacao),length(min_or_max));
for i = 1:length(populacao)
    fitness(i,:) = populacao{i}.fitness;
end

%% Fast Non-dominated Sorting
[F,rank] = fast_non_dominated_sorting(fitness, min_or_max);

%% Calcula e organiza por Crowding distance de cada fronte f

[F,front_crowding_distance,crowding_distance] = calc_all_front_crowding_distance(F, fitness);

%% Inicializa o armazenador de hypervolume

hypervolume = zeros(1,fix(maxgen/log_hv_freq));

%% Inicializador do contador de tempo
tempo_analise = zeros(1,maxgen);
t_inicio_analise = tic;


%% Processo iterativo - MAIN LOOP
t = 1;

%%
while t <= maxgen
    fprintf( [datestr(now,'HH:MM:SS') ': Geração número ' num2str(t) '.\n']);

    % Atualiza lista de tipos
    pop_type = zeros(1,length(populacao));
    for i = 1:length(populacao)
        pop_type(i) = populacao{i}.type;
    end

    % Calcula a quantidade de particulas de cada tipo na população
    unique_pop_type = unique(pop_type);
    quantitade_pop_type = zeros(1,length(unique_pop_type));
    for i = 1:length(unique_pop_type)
        quantitade_pop_type(i) = sum(pop_type==unique_pop_type(i));
    end


    %% Crowded Binary Tournament Selection Operator

    M = crowded_binary_tournament_selection(rank,crowding_distance);


    %% SBX Crossover Operator

    Q = crossover(M, pop_type, populacao, minvalue, maxvalue, p_c, eta_c);


    %% Mutate the population

    Q = mutate_polynomial(Q, p_m, minvalue, maxvalue, eta_m);


    %% Maintain particles in the population within the search space

    Q = maintain_particles(Q, minvalue, maxvalue, discvalue, false);

    %% Verifica duplicações

    % Entre offspring e população
    for i = 1:length(Q)
        for j = 1:length(populacao)
            if Q{i}.type == populacao{j}.type
                while all(Q{i}.variaveis == populacao{j}.variaveis)
                    Q(i) = mutate_polynomial(Q(i), 1, minvalue, maxvalue, eta_m);
                    Q(i) = maintain_particles(Q(i), minvalue, maxvalue, discvalue, false);
                end
            end
        end
    end
    % Entre offspring e offspring
    for i = 1:length(Q)
        for j = 1:length(Q)
            if not(i == j)
                if Q{i}.type == Q{j}.type
                    while all(Q{i}.variaveis == Q{j}.variaveis)
                        Q(i) = mutate_polynomial(Q(i), 1, minvalue, maxvalue, eta_m);
                        Q(i) = maintain_particles(Q(i), minvalue, maxvalue, discvalue, false);
                    end
                end
            end
        end
    end
    % Ainda existe a possibilidade de apos a mutação o filho ficar igual a
    % algum individuo que ja foi comparado. Para contornar este problema,
    % sera feita uma comparação depois da avaliação, caso as variaveis
    % sejam iguais, uma violação é considerada.


    %% Check constraints violations

    Q = check_constraints(Q, impedido, parametros_gerador_modelo, greide);


    %% Evaluate particles in the population
    parfor i = 1 : length(Q)
        % fprintf( ['Novo indivíduo número ' num2str(i) '.\n']);
        % Transforma variaveis em viaduto
        Q{i}.viaduto = variaveis2viaduto(Q{i}.variaveis,viaduto_padrao,parametros_gerador_modelo,greide);

        if Q{i}.violations == 0
            [~, Q{i}.orcamento, Q{i}.impacto_ambiental, Q{i}.VUP, Q{i}.viaduto, ~, Q{i}.situacao, Q{i}.msg_erro] = ...
                avalia_viaduto_recalculo_protensao(Q{i}.viaduto, terreno, greide, impedido, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw);

        end
        if Q{i}.situacao
            Q{i}.variaveis = viaduto2variaveis(Q{i}.viaduto);
            Q{i}.fitness = [Q{i}.orcamento.TOTAL Q{i}.impacto_ambiental.TOTAL Q{i}.VUP.min];

        else
            Q{i}.violations = Q{i}.violations + 1;
        end
    end

    % Checa se a alteração feita durante a avaliação do viadulo não tornou
    % ele igual a algum na população ou na offspring
    for i = 1 : length(Q)
        if Q{i}.situacao
            % Entre offspring e população
            for j = 1:length(populacao)
                if Q{i}.type == populacao{j}.type
                    if all(Q{i}.variaveis == populacao{j}.variaveis)
                        Q{i}.violations = Q{i}.violations + 1;
                        break
                    end
                end
            end

            % Entre offspring e offspring
            for j = 1:length(Q)
                if and(not(i == j), Q{i}.violations == 0) % Checar se tem violação é importante para manter ao menos uma das duas repetidas
                    if Q{i}.type == Q{j}.type
                        if all(Q{i}.variaveis == Q{j}.variaveis)
                            Q{i}.violations = Q{i}.violations + 1;
                            break
                        end
                    end
                end
            end
        end
    end

    %% Survivor or Elimination

    % Separa fitness da offspring
    n_sucessos = 0;
    for i = 1 : length(Q)
        if Q{i}.violations == 0
            n_sucessos = n_sucessos + 1;
        end
    end
    %
    offspring_fitness = zeros(n_sucessos,length(min_or_max));
    is = zeros(1,n_sucessos);
    n_sucessos = 0;
    for i = 1 : length(Q)
        if Q{i}.violations == 0
            n_sucessos = n_sucessos + 1;
            is(n_sucessos) = i;
            offspring_fitness(n_sucessos,:) = Q{i}.fitness;
        end
    end

    total_fitness = [fitness ; offspring_fitness];
    
    % Fast Non-dominated Sorting
    [F,rank] = fast_non_dominated_sorting(total_fitness, min_or_max);

    % Calcula e organiza por Crowding distance de cada fronte f
    [F,front_crowding_distance,crowding_distance] = calc_all_front_crowding_distance(F, total_fitness);

    
    pop_size = length(populacao);
    new_pop = cell(1,pop_size);
    n_new_pop = 0;

    for f = 1:length(F)
        if (n_new_pop + length(F{f})) <= pop_size
            for i = 1:length(F{f})
                n_new_pop = n_new_pop + 1;
                if F{f}(i) > pop_size
                    new_pop{n_new_pop} = Q{is(F{f}(i) - pop_size)};
                else
                    new_pop{n_new_pop} = populacao{F{f}(i)};
                end
            end
        else
            for i = 1:pop_size-n_new_pop
                n_new_pop = n_new_pop + 1;
                if F{f}(i) > pop_size
                    new_pop{n_new_pop} = Q{is(F{f}(i) - pop_size)};
                else
                    new_pop{n_new_pop} = populacao{F{f}(i)};
                end
            end

            break
        end
    end

    populacao = new_pop;

    %% Separa fitness da populacao
    fitness = zeros(length(populacao),length(min_or_max));
    for i = 1:length(populacao)
        fitness(i,:) = populacao{i}.fitness;
    end

    %% Fast Non-dominated Sorting
    [F,rank] = fast_non_dominated_sorting(fitness, min_or_max);

    %% Calcula e organiza por Crowding distance de cada fronte 

    [F,front_crowding_distance,crowding_distance] = calc_all_front_crowding_distance(F, fitness);


    %% Calcula o hypervolume

    if rem(t,log_hv_freq) == 0
        hypervolume(fix(t/log_hv_freq)) = calc_hypervolume(populacao, length(populacao), min_or_max, upper_bound);
        fprintf( [datestr(now,'HH:MM:SS') ': Hypervolume: ' num2str(hypervolume(fix(t/log_hv_freq))/1E9) ' G.\n']);
    end

    %% Anota o tempo

    tempo_analise(t) = toc(t_inicio_analise);


    %% Plot
    pop_size = length(populacao);

    ct = 0;
    for i = 1:pop_size
        if populacao{i}.violations == 0
            ct = ct + 1;
        end
    end

    pop_fitness{t} = zeros(ct,length(min_or_max));
    ct = 0;
    for i = 1:pop_size
        if populacao{i}.violations == 0
            ct = ct + 1;
            pop_fitness{t}(ct,:) = populacao{i}.fitness;
        end
    end


%     plot_history = 5;
%     if t < plot_history
%         figure(645)
% 
%         scatter3(pop_fitness{t}(:,1),pop_fitness{t}(:,2),pop_fitness{t}(:,3),'.')
% 
%         grid on
%     
%         drawnow
%     else
%         for np = 0:plot_history-1
%             figure(645)
%             if not(np == 0)
%                 hold on
%             end
%             scatter3(pop_fitness{t - np}(:,1),pop_fitness{t - np}(:,2),pop_fitness{t - np}(:,3),'.')
% 
%             grid on
%             hold off
%             
%         end
%     end
% 
%     if and(rem(t,log_hv_freq) == 0,fix(t/log_hv_freq)>1)
%         figure(564)
%         hold on
%         plot([t-log_hv_freq t], [hypervolume(fix(t/log_hv_freq)-1) hypervolume(fix(t/log_hv_freq))],'color',[0 0.4470 0.7410])
%         hold off
%     end
% 
%     drawnow
    
    
    %% Salva progresso para o caso de interrupção

    save([mcrdir 'saida_' algoritimo] ,'parametros_NSGAII','tempo_analise','t','populacao','hypervolume', 'pop_fitness')

    %% Itera contador
    t = t + 1;

end
fprintf([datestr(now,'HH:MM:SS') ': Fim da análise. \n']);