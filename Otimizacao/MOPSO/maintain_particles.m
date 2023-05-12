function populacao = maintain_particles(populacao, minvalue, maxvalue, discvalue, alterar_velocidades)
%MAINTAIN_PARTICLES Mantem as variaveis dentro dos limites estabelecidos
%   É tambem possivel trocar o sinal da velocidade caso algum limite seja
%   extrapolado

for i = 1:length(populacao)
    % Inverte velocidades quando o limite é extrapolado
    % An Effective Use of Crowding Distance in Multiobjective Particle Swarm Optimization
    if alterar_velocidades
        populacao{i}.velocidades(or(populacao{i}.variaveis < minvalue{populacao{i}.type}, populacao{i}.variaveis > maxvalue{populacao{i}.type})) = - populacao{i}.velocidades(or(populacao{i}.variaveis < minvalue{populacao{i}.type}, populacao{i}.variaveis > maxvalue{populacao{i}.type}));
    end

    % Arredonda dentro da discretização
    for n = 1 : length(populacao{i}.variaveis)
        populacao{i}.variaveis(n) = minvalue{populacao{i}.type}(n) + round((populacao{i}.variaveis(n) - minvalue{populacao{i}.type}(n))/discvalue{populacao{i}.type}(n)) * discvalue{populacao{i}.type}(n);
    end

    % Mantem dentro dos limites
    populacao{i}.variaveis(populacao{i}.variaveis < minvalue{populacao{i}.type}) = minvalue{populacao{i}.type}(populacao{i}.variaveis < minvalue{populacao{i}.type});
    populacao{i}.variaveis(populacao{i}.variaveis > maxvalue{populacao{i}.type}) = maxvalue{populacao{i}.type}(populacao{i}.variaveis > maxvalue{populacao{i}.type});
end
end