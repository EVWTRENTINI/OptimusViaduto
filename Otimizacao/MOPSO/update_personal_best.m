function populacao = update_personal_best(populacao, min_or_max)
    for i = 1:length(populacao)
        if populacao{i}.violations == 0
            dominancia = confere_dominancia(populacao{i}.fitness, populacao{i}.pbests_fit, min_or_max);
            if or(dominancia == 3, and(dominancia == 2, rand < .5))
                populacao{i}.pbests_fit = populacao{i}.fitness;
                populacao{i}.pbests_var = populacao{i}.variaveis;
            end
        end
    end
end