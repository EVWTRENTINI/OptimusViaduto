function Eci_t = calc_Eci_t(fck,t,s_cim,alfa_e)
% Calcula o modulo de elasticidade inicial do concreto em Pa.
% fck e em MPa.
% t é em dias

fck_t = calc_fct(fck,s_cim,t);%MPa


%% Cálculo do módulo de elasticidade
Eci = calc_Eci(fck*1E6,alfa_e);%Pa

if fck<=50
    Eci_t=Eci*(fck_t/fck)^.5;%Pa
else
    Eci_t=Eci*(fck_t/fck)^.3;%Pa
end
end