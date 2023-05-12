function [Ecs] = calc_Ecs(fck,alfa_e)
%Calcula o modulo de elasticidade secante do concreto em Pa
fck=fck/(1E6);
alfa_i=.8+.2*fck/80;
if alfa_i>1
    alfa_i=1;
end
if fck<=50
    Ecs=alfa_e*5600*(fck)^.5*alfa_i;
elseif fck>50
    Ecs=21.5E3*alfa_e*(fck/10+1.25)^(1/3)*alfa_i;
end
Ecs=Ecs*(1E6);
end

