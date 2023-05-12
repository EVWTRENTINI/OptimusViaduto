function i = truncamento(fitness)
fmin = min(fitness);
fmax = max(fitness);

fdelta = fmax - fmin;
d = zeros(size(fitness,1),size(fitness,1));

for p = 1:size(fitness,1)
    for q = 1:size(fitness,1)
        if not(p == q)
            for o = 1:size(fitness,2)
                d(p,q) = d(p,q) + ((fitness(p,o)-fitness(q,o))/fdelta(o))^2;
            end
            d(p,q) = sqrt(d(p,q));
        end
    end
    
   %d = sort(d);
   %sigma = d(k+1);
   %D(p) = 1/(sigma+2);
end

%% Tentativa de preservar extremos
indice_min = zeros(1,size(fitness,2));
indice_max = zeros(1,size(fitness,2));

for f = 1:size(fitness,2)
    [~,indice_min(f)] = min(fitness(:,f));
    [~,indice_max(f)] = max(fitness(:,f));
end

indice_extremos = unique([indice_min indice_max]);

d(indice_extremos,:) = d(indice_extremos,:) * 2;

%%
d = sort(d,2);
empate = true(size(fitness,1),1);
for i = 2:size(fitness,1)
    dmin = min(d(empate,i));
    empate(empate)=d(empate,i) == dmin;
    if sum(empate) == 1
        break
    end
end
i = find(empate);
if length(i)>1
    i=i(1);
end
end