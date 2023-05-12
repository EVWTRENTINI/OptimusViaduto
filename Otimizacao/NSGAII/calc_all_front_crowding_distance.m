function [F,front_crowding_distance,crowding_distance] = calc_all_front_crowding_distance(F, fitness)
front_crowding_distance = cell(1,length(F));
crowding_distance = zeros(1,size(fitness,1));
for f = 1:length(F)
    [F,front_crowding_distance{f}] = calc_front_crowding_distance(F, f, fitness);
    cont = 0;

        crowding_distance(F{f}) = front_crowding_distance{f};

end
end