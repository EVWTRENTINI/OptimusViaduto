function [F,rank] = fast_non_dominated_sorting(fitness, min_or_max)
% Stage-1
S = cell(1,size(fitness,1));
nn = zeros(1,size(fitness,1));
rank = zeros(1,size(fitness,1));
F{1} = [];
for p = 1:size(fitness,1)
    for q = 1:size(fitness,1)
        if not(p==q)
            dominancia = confere_dominancia(fitness(p,:), fitness(q,:), min_or_max);
            if dominancia == 3
                if isempty(S{p}); S{p} = q; else; S{p}(end+1) = q; end
            elseif dominancia == 1
                nn(p) = nn(p) + 1;
            end
        end
    end
    if nn(p) == 0
        rank(p) = 1;
        if isempty(F{1}); F{1} = p; else; F{1}(end+1) = p; end
    end
end
% Stage-2
i = 1;
while not(isempty(F{i}))
    Q = [];
    for p = F{i}
        for q = S{p}
            nn(q) = nn(q) - 1;
            if nn(q) == 0
                rank(q) = i + 1;
                if isempty(Q); Q = q; else; Q(end+1) = q; end
            end
        end
    end
    i = i + 1;
    F{i} = Q;
end
F(i)=[];
end