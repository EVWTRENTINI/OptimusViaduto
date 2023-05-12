function [archive_type, n_archive_type] = update_archive_type(populacao, quantidade_archive_type, archive_type, n_archive_type, min_or_max, bottom)
% Organiza um vetor com o tipo da particula
pop_size = length(populacao);
pop_type = zeros(1,pop_size);
for i = 1:pop_size
    pop_type(i)=populacao{i}.type;
end

% Conta quantas particulas existe em cada tipo
size_type = zeros(1,quantidade_archive_type);
for j = 1:quantidade_archive_type
    size_type(j) = sum(pop_type == j);
end

% Separa as particular por tipo de particulas
populacao_type = cell(1, quantidade_archive_type);
for j = 1:quantidade_archive_type
    populacao_type{j} = cell(1,size_type(j));
    cont_pop_type = 0;
    for i = 1:pop_size
        if populacao{i}.type == j
            cont_pop_type = cont_pop_type + 1;
            populacao_type{j}{cont_pop_type} = populacao{i};
        end
    end
end

% Atualiza o arquivo de cada tipo de particula
for j = 1:quantidade_archive_type
    [archive_type{j}, n_archive_type(j)] = update_archive(populacao_type{j}, n_archive_type(j), archive_type{j}, min_or_max, bottom);
end
end