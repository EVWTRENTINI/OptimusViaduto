function F = cria_F_baseado_strength(R, D)
%%
unique_R = unique(R);
sum_unique_R = zeros(1,length(unique_R));
F = cell(1,length(unique_R));
for i = 1:length(unique_R)
    sum_unique_R(i) = sum(R == unique_R(i));
    F{i} = zeros(1,sum_unique_R(i));
end
%%
for i = 1:length(unique_R)
    ct = 0;
    for f = 1:length(R)
        if R(f) == unique_R(i)
            ct = ct + 1;
            F{i}(ct) = f;
        end
    end
end

% Organizar o F em função da densidade D
 for f = 1:length(F)
     D_of_Ff = D(F{f});
     [~,iD] = sort(D_of_Ff);
     Ff_original = F{f};
     F{f} = Ff_original(iD);
 end
end