function [Eci] = calc_Eci(fck,alfa_e)
%Calcula o modulo de elasticidade inicial do concreto em Pa
fck=fck/(1E6);
if fck<=50
    Eci=alfa_e*5600*(fck)^.5;
elseif fck>50
    Eci=21.5E3*alfa_e*(fck/10+1.25)^(1/3);
end
Eci=Eci*(1E6);
end

