function [F,front_crowding_distance] = calc_front_crowding_distance(F, f, fitness)
grupo = cell(1,length(F(f)));
for i = 1:length(F{f})
    grupo{i}.fitness = fitness(F{f}(i),:);
end

[front_crowding_distance_original, index_cd_vector] = calc_crowding_distance(grupo, length(grupo));

F_ori = F{f};

front_crowding_distance = zeros(1,length(F{f}));
for i = 1:length(F{f})
    front_crowding_distance(i) = front_crowding_distance_original(index_cd_vector(i));
    F{f}(i) = F_ori(index_cd_vector(i));
end

front_crowding_distance = flip(front_crowding_distance);
F{f} = flip(F{f});
end