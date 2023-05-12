function [populacao] = compute_new_velocity(populacao, archive, n_archive, quantidade_type, archive_type, n_archive_type, w_max, w_min, t, maxgen, c3i, top, p1, c1, c2, minvalue, maxvalue, discvalue)
    pop_type = zeros(1,length(populacao));
    for i = 1:length(populacao)
        pop_type(i) = populacao{i}.type;
    end

    
    % Organiza o vetor de index por ordem de distancia de aglomeramento
    [archive_crowding_distance, index_cd] = calc_crowding_distance(archive, n_archive);

    for j = 1:quantidade_type
        [archive_type_crowding_distance{j}, index_cd_type{j}] = calc_crowding_distance(archive_type{j}, n_archive_type(j));
    end

    % Calcula a quantidade de particulas de cada tipo na população
    unique_pop_type = unique(pop_type);
    quantitade_pop_type = zeros(1,length(unique_pop_type));
    for i = 1:length(unique_pop_type)
        quantitade_pop_type(i) = sum(pop_type==unique_pop_type(i));
    end

    % Calcula a melhor posição média - average best position / Multi-objective particle swarm optimization algorithm based on sharing-learning and Cauchy mutation
    C = cell(1, length(unique_pop_type));
    soma_C = cell(1, length(unique_pop_type));
    for j = 1:length(unique_pop_type)
        indices_mesmo_tipo = find(pop_type == unique_pop_type(j));
        n_variaveis = length(populacao{indices_mesmo_tipo(1)}.variaveis);
        soma_C{j} = zeros(1,n_variaveis);
        for i = 1:length(populacao)
            if pop_type(i) == unique_pop_type(j)
                soma_C{j} = soma_C{j} + populacao{i}.variaveis;
            end
        end
        C{j} = soma_C{j}/quantitade_pop_type(j);
    end
    
    % Calcula as velocidades e posições
    w = w_max - (w_max - w_min)*(t - 1)/(maxgen - 1);
    %c3 = c3i + 1/(maxgen);
    c3 = c3i;
    for i = 1:length(populacao)
        % Seleciona a melhor do arquivo
        gbest = archive{index_cd(n_archive+1-randi(ceil(n_archive*top)))};
        if populacao{i}.type == gbest.type % Se o tipo da particula por igual ao tipo do gbest
            % Não necessita de nenhuma ação especial
        else % Caso não seja
            % Existe uma pobabilidade p1 de que o tipo da particula seja alterada
            if rand < p1 % É alterado o tipo da particula assumindo o mesmo tipo de gbest
                if any(pop_type == gbest.type) % Caso exista alguma particula na população do mesmo tipo do arquivo
                    % Clona uma particula aleatória com o mesmo tipo de gbest
                    mesmo_tipo = find(pop_type == gbest.type); % Indices com mesmo tipo
                    populacao{i} = populacao{mesmo_tipo(randi(length(mesmo_tipo)))};
                else % Caso não exista alguma particula na população do mesmo tipo do arquivo
                    % A particula atual vira a particula do gbest
                    populacao{i} = gbest;
                end
                % Corrige o tipo da particula na lista
                pop_type(i) = populacao{i}.type;
            else % Não é alterado o tipo da particula
                % Seleciona a melhor do arquivo do tipo dela
                gbest = archive_type{pop_type(i)}{index_cd_type{pop_type(i)}(n_archive_type(pop_type(i))+1-randi(ceil(n_archive_type(pop_type(i))*top)))};
            end
        end

        % Lista de numeros aleatorios
        random_list = rand(3,length(populacao{i}.velocidades));
        % Velocidades
        if any(populacao{i}.type == unique_pop_type)
            populacao{i}.velocidades = w * populacao{i}.velocidades + ...                                     Parcela do comportamento atual
                c1 * random_list(1,:) .* (populacao{i}.pbests_var - populacao{i}.variaveis) + ...             Parcela do auto conhecimento
                c2 * random_list(2,:) .* (gbest.variaveis - populacao{i}.variaveis) + ...                     Parcela do conhecimento geral
                c3 * random_list(3,:) .* (C{unique_pop_type==populacao{i}.type} - populacao{i}.variaveis);  % Parcela do conhecimento compartilhado
        else
            populacao{i}.velocidades = w * populacao{i}.velocidades + ...                         Parcela da inercia
                c1 * random_list(1,:) .* (populacao{i}.pbests_var - populacao{i}.variaveis) + ... Parcela do pbest
                c2 * random_list(2,:) .* (gbest.variaveis - populacao{i}.variaveis);            % Parcela do gbest
        end

        % Posições
        populacao{i}.variaveis = populacao{i}.variaveis + populacao{i}.velocidades;


    end

    % Maintain particles in the population within the search space

    populacao = maintain_particles(populacao, minvalue, maxvalue, discvalue, true);
end