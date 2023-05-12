function R = calc_strength(fitness, min_or_max)

S = zeros(1,size(fitness,1));
D = cell(1,size(fitness,1));

for p = 1:size(fitness,1)
    for q = 1:size(fitness,1)
        if not(p==q)
            dominancia = confere_dominancia(fitness(p,:), fitness(q,:), min_or_max);
            if dominancia == 3
                S(p) = S(p) + 1;
            elseif dominancia == 1
                if isempty(D{p}); D{p} = q; else; D{p}(end+1) = q; end
            end
        end
    end
end

R = zeros(1,size(fitness,1));
for p = 1:size(fitness,1)
    for i = 1:length(D{p})
        R(p) = R(p) + S(D{p}(i));
    end
end
end