function [populacao, archive, n_archive, archive_type, n_archive_type] = iteracao_MOPSO(populacao, archive, n_archive, quantidade_type, archive_type, n_archive_type, w_max, w_min, t, maxgen, c3i, top, p1, c1, c2, minvalue, maxvalue, discvalue, mut_prob, eta_m, impedido, parametros_gerador_modelo, viaduto_padrao, terreno, greide, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, min_or_max, bottom, config_draw)
    %% Compute new velocity of each particle in the population
    % Atualiza lista de tipos
    [populacao] = compute_new_velocity(populacao, archive, n_archive, quantidade_type, archive_type, n_archive_type, w_max, w_min, t, maxgen, c3i, top, p1, c1, c2, minvalue, maxvalue, discvalue);

    %% Mutate particles in the population

    populacao = mutate_polynomial(populacao, mut_prob, minvalue, maxvalue, eta_m);


    %% Maintain particles in the population within the search space

    populacao = maintain_particles(populacao, minvalue, maxvalue, discvalue, true);


    %% Check constraints violations

    populacao = check_constraints(populacao, impedido, parametros_gerador_modelo, greide);


    %% Evaluate particles in the population
    
    populacao = evaluate_particles(populacao, viaduto_padrao, parametros_gerador_modelo, terreno, greide, impedido, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw);


    %% Update personal bests of particles in the population

    populacao = update_personal_best(populacao, min_or_max);


    %% Insert new nondominated particles in pop into archive

    [archive, n_archive] = update_archive(populacao, n_archive, archive, min_or_max, bottom);

    [archive_type, n_archive_type] = update_archive_type(populacao, quantidade_type, archive_type, n_archive_type, min_or_max, bottom);
end