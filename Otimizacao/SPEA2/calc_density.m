function D = calc_density(fitness)
k = round(sqrt(size(fitness,1)));
if k<1; k=1; end

fmin = min(fitness);
fmax = max(fitness);

fdelta = fmax - fmin;


D = zeros(1,size(fitness,1));
for p = 1:size(fitness,1)
    d = zeros(1,size(fitness,1));
    for q = 1:size(fitness,1)
        if not(p == q)
            for o = 1:size(fitness,2)
                d(q) = d(q) + ((fitness(p,o)-fitness(q,o))/fdelta(o))^2;
            end
            d(q) = sqrt(d(q));
        end
    end
    
    d = sort(d);
    sigma = d(k+1);
    D(p) = 1/(sigma+2);
end
end