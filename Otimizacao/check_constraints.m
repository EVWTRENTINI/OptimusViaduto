function populacao = check_constraints(populacao, impedido, parametros_gerador_modelo, greide)
    for i = 1 : length(populacao)
        populacao{i}.violations = 0;
        %% Vão máximo e vão mínimo
        % Calcula o tamanho dos vãos
        n_apoios = variaveis2n_apoios(populacao{i}.variaveis);
        n_vaos = n_apoios - 1;
        l_vao = zeros(1,n_vaos);
        xp = zeros(1,n_apoios);
        xp(1) = greide.x(1);
        xp(end) = greide.x(end);
        for k = 2:n_apoios-1
            xp(k) = populacao{i}.variaveis(14+24*(k-1)+1);
        end
        for k = 1:n_vaos
            l_vao(k) = xp(k+1) - xp(k);
        end
        % Checa por vão menores que o mínimo
        n_vaos_menores_minimo = sum(l_vao < parametros_gerador_modelo.L_vao.min);
        if n_vaos_menores_minimo > 0
            populacao{i}.violations = populacao{i}.violations + n_vaos_menores_minimo;
        end

        % Checa por vão maiores que o máximo
        n_vaos_maiores_maximo = sum(l_vao > parametros_gerador_modelo.L_vao.max);
        if n_vaos_maiores_maximo > 0
            populacao{i}.violations = populacao{i}.violations + n_vaos_maiores_maximo;
        end

        %% Pilar sobre região impedida
        for j = 1 : size(impedido,2)
            for k = 1 : n_apoios
                if and(xp(k) >= impedido(j).xi, xp(k) <= impedido(j).xf)
                    populacao{i}.violations = populacao{i}.violations + 1;
                end
            end
        end
    end
end