function [vaos_unicos, quantidade_type, minvalue, maxvalue, discvalue, populacao] = inicializa_populacao(parametros_gerador_modelo, impedido, pop_size, viaduto_padrao, terreno, greide, parametros_gerador_modelo_relativo, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw, app)
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
% Lida com a interface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin>13; suspende_processo_pela_interface(app); end     %
if nargin>13; if app.pausar_flag == true; return; end; end   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin>13; app.TextstatusLabel.Text = ['Preparando para utilização de ' num2str(myCluster.NumWorkers) ' núcleos de processamento.']; drawnow; end
parpool('processes',myCluster.NumWorkers);
if nargin>13; if app.pausar_flag == true; app.IniciarotimizacaoButton.Enable = 'on'; app.TextstatusLabel.Text = 'Processo suspenso pelo usuário.'; drawnow; return; end; end
% inicializa batch
batch_size = myCluster.NumWorkers;
batch = cell(1,batch_size);



fprintf([datestr(now,'HH:MM:SS') ': Iniciando a criação da população aleatória.\n']);
if nargin>13; app.TextstatusLabel.Text = 'Iniciando a criação da população aleatória.'; drawnow; end

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
            [~, batch{i}.orcamento, batch{i}.impacto_ambiental, batch{i}.VUP, batch{i}.viaduto, batch{i}.info, batch{i}.situacao, batch{i}.msg_erro] = ...
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
                populacao{n_sucessos_populacao}.velocidades = zeros(1,length(populacao{n_sucessos_populacao}.variaveis));
                populacao{n_sucessos_populacao}.pbests_var = populacao{n_sucessos_populacao}.variaveis;
                populacao{n_sucessos_populacao}.pbests_fit = populacao{n_sucessos_populacao}.fitness; 
                populacao{n_sucessos_populacao}.violations = 0; 
                % Barra de progresso
%                 posicao_barra = posicao_barra + (n_vaos_desejados.^1.6)/total_barra;
%                 waitbar(posicao_barra,barra_criacao,['Criando população inicial... (' num2str(n_sucessos_populacao) '/' num2str(length(populacao)) ')']);
                if n_sucessos_grupo_atual == tamanho_grupos_vao(g); break; end
            end
            
        end
        % Lida com a interface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if nargin>13; suspende_processo_pela_interface(app); end     %
        if nargin>13; if app.pausar_flag == true; return; end; end   %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if flag_sucesso
            flag_sucesso = false;
            fprintf([datestr(now,'HH:MM:SS') ': Já foram criados ' num2str(n_sucessos_populacao) ' viadutos aleatórios com sucesso.\n']);
            if nargin>13; draw_resultados_scatter(populacao,app.UIAxes3); drawnow; end
            
        end
        if nargin>13; app.TextstatusLabel.Text = ['Total de viadutos aleatórios criados com sucesso: ' num2str(n_sucessos_populacao) '.']; drawnow; end
        if n_sucessos_grupo_atual == tamanho_grupos_vao(g); break; end
    end
    
end
% Barra de progresso
% delete(barra_criacao);

t_geracao_populacao_fim = toc(t_geracao_populacao_ini);
fprintf([datestr(now,'HH:MM:SS') ': População inicial gerada em ' num2str(t_geracao_populacao_fim) ' segundos.\n']);
if nargin>13; app.TextstatusLabel.Text = ['População inicial gerada em ' num2str(t_geracao_populacao_fim,'%.0f') ' segundos.']; drawnow; end
if nargin>13; app.populacao_inicial_concluida = true; end

end

function suspende_processo_pela_interface(app)
if app.pausar_flag == true
    app.IniciarotimizacaoButton.Enable = 'on';
    app.TextstatusLabel.Text = 'Processo suspenso pelo usuário.';
    app.NovoMenu.Enable = 'on';
    app.AbrirMenu.Enable = 'on';
    app.SalvarMenu.Enable = 'on';

    drawnow
    return
end
end