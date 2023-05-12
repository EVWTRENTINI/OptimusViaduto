function M = crowded_binary_tournament_selection(rank,crowding_distance)
%
%
pop_size = length(rank);
M = zeros(1,pop_size);
    for torneio = 1:2
        disponibilidade = true(1,pop_size);
        for rounde = 1:pop_size/2
            indice_disponiveis = find(disponibilidade==true);
            i = indice_disponiveis(randi(length(indice_disponiveis)));
            disponibilidade(i) = false;
            indice_disponiveis = find(disponibilidade==true);
            j = indice_disponiveis(randi(length(indice_disponiveis)));
            disponibilidade(j) = false;
            indice_disponiveis = find(disponibilidade==true);

            if rank(i)==rank(j)
                if crowding_distance(i)==crowding_distance(j)
                    if rand < .5; m = i; else; m = j; end
                else
                    if crowding_distance(i) > crowding_distance(j)
                        m = i;
                    else
                        m = j;
                    end
                end
            else
                if rank(i) < rank(j)
                    m = i;
                else
                    m = j;
                end
            end
            M((torneio-1)*pop_size/2+rounde) = m;
        end
    end
end