function populacao = evaluate_particles(populacao, viaduto_padrao, parametros_gerador_modelo, terreno, greide, impedido, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw)
    parfor i = 1 : length(populacao)
        % fprintf( ['Particula número ' num2str(i) '.\n']);
        % Transforma variaveis em viaduto
        populacao{i}.viaduto = variaveis2viaduto(populacao{i}.variaveis,viaduto_padrao,parametros_gerador_modelo, greide);

        if populacao{i}.violations == 0
            [~, populacao{i}.orcamento, populacao{i}.impacto_ambiental, populacao{i}.VUP, populacao{i}.viaduto, populacao{i}.info, populacao{i}.situacao, populacao{i}.msg_erro] = ...
                avalia_viaduto_recalculo_protensao(populacao{i}.viaduto, terreno, greide, impedido, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw);

        end
        if populacao{i}.situacao
            populacao{i}.variaveis = viaduto2variaveis(populacao{i}.viaduto);
            populacao{i}.fitness = [populacao{i}.orcamento.TOTAL populacao{i}.impacto_ambiental.TOTAL populacao{i}.VUP.min];
        else
            populacao{i}.violations = populacao{i}.violations + 1;
        end
    end
end