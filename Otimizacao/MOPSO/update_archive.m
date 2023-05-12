function [archive, n_archive] = update_archive(populacao, n_archive, archive, min_or_max, bottom)
for i = 1:length(populacao)
    if populacao{i}.violations == 0
        if n_archive == 0
            archive{1} = populacao{i};
            n_archive = 1;
        else
            dominancia = zeros(1,n_archive);
            for k = 1:n_archive
                dominancia(k) = confere_dominancia(populacao{i}.fitness, archive{k}.fitness, min_or_max);
            end
            if any(dominancia == 1) % Se a particula da populacao é dominado por alguma do arquivo
                % Ignora ela
            elseif any(dominancia == 3) % Se a particula da populacao domina alguma do arquivo
                % Pegar indices das particulas dominadas do arquivo
                n_dominados = 0;
                indices_deletar = 0;
                for k = 1:n_archive
                    if dominancia(k) == 3
                        n_dominados = n_dominados + 1;
                        indices_deletar(n_dominados) = k;
                    end
                end
                % Deletar particulas dominadas do arquivo
                for d = 1:length(indices_deletar)
                    archive(indices_deletar(d):n_archive-1) = archive(indices_deletar(d)+1:n_archive);
                    archive{n_archive} = [];
                    indices_deletar = indices_deletar - 1;
                    n_archive = n_archive - 1;
                end
                % Adiciona a particula da população que domina na ultima posição do arquivo
                archive{n_archive+1} = populacao{i};
                n_archive = n_archive + 1;
            else% Se a particula da populacao é indiferente a todas do arquivo
                if n_archive < length(archive) % Se ainda tiver espaço no arquivo
                    % Adiciona a particula da população que é indiferente ao arquivo no arquivo
                    archive{n_archive+1} = populacao{i};
                    n_archive = n_archive + 1;
                else % Se não tiver espaço no arquivo
                    % Calcula a distancia de aglomeramento e seleciona os indices por ordem de distancia de aglomeramento da menor para a maior
                    [archive_crowding_distance, index_cd] = calc_crowding_distance(archive,n_archive);
                    % Adiciona a particula em uma posição aleatoria dentro da região mais congestionada (menor distancia de aglomeramento) delimitada pela variavel bottom
                    archive{index_cd(randi(ceil(n_archive*bottom)))} = populacao{i};
                end
            end
        end
    end
end
end