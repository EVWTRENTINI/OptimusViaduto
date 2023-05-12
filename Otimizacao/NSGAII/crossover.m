function Q = crossover(M, pop_type, populacao, minvalue, maxvalue, p_c, eta_c)
    pop_size = length(M);
    Q = cell(1,pop_size);
    disponibilidade = true(1,pop_size);
    M_type = zeros(1,pop_size);
    for i = 1:pop_size
        M_type(i) = pop_type(M(i));
    end
    for cz = 1:pop_size/2
        indice_disponiveis = find(disponibilidade==true);
        i = indice_disponiveis(randi(length(indice_disponiveis)));
        disponibilidade(i) = false;
        disp_type = disponibilidade;
        disp_type = and(disp_type,M_type==M_type(i));
        if sum(disp_type)>0
            indice_disponiveis = find(disp_type==true);
            j = indice_disponiveis(randi(length(indice_disponiveis)));
            disponibilidade(j) = false;
        else
            j = i;
        end
        
        Q{cz*2-1} = populacao{M(i)};
        Q{cz*2} = populacao{M(j)};
        if rand <= p_c
            for n = 1:length(populacao{M(i)}.variaveis)
                [Q{cz*2-1}.variaveis(n), Q{cz*2}.variaveis(n)] = SBX(populacao{M(i)}.variaveis(n), populacao{M(j)}.variaveis(n), minvalue{pop_type(M(i))}(n), maxvalue{pop_type(M(i))}(n), eta_c);
            end 
        end
        %figure(3)
        %clf
        %bar((populacao{M(i)}.variaveis-minvalue{pop_type(M(i))})./(maxvalue{pop_type(M(i))}-minvalue{pop_type(M(i))}))
        %hold on
        %bar((Q{cz*2-1}.variaveis-minvalue{pop_type(M(i))})./(maxvalue{pop_type(M(i))}-minvalue{pop_type(M(i))}),'FaceAlpha',.5)
        %hold off
        %figure(4)
        %clf
        %bar((populacao{M(j)}.variaveis-minvalue{pop_type(M(i))})./(maxvalue{pop_type(M(i))}-minvalue{pop_type(M(i))}))
        %hold on
        %bar((Q{cz*2}.variaveis-minvalue{pop_type(M(i))})./(maxvalue{pop_type(M(i))}-minvalue{pop_type(M(i))}),'FaceAlpha',.5)
        %hold off
    end
end