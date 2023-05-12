function [crowding_distance, index_cd] = calc_crowding_distance(grupo,n_grupo)
fitness = zeros(n_grupo,length(grupo{1}.fitness));
for i = 1:n_grupo
    fitness(i,:)=grupo{i}.fitness;
end

crowding_distance = zeros(1,n_grupo);
indice_min = zeros(1,size(fitness,2));
indice_max = zeros(1,size(fitness,2));

for f = 1:size(fitness,2)
    [fmin,indice_min(f)] = min(fitness(:,f));
    [fmax,indice_max(f)] = max(fitness(:,f));
    delta_f = fmax -  fmin;
    [~, index_order] = sort(fitness(:,f));
    for i = 2:n_grupo-1
        crowding_distance(index_order(i)) = crowding_distance(index_order(i)) + (fitness(index_order(i+1),f)-fitness(index_order(i-1),f))/delta_f;

    end

end

indice_extremos = unique([indice_min indice_max]);

crowding_distance(indice_extremos) = max(crowding_distance) * 1.1;
[~, index_cd] = sort(crowding_distance);
end