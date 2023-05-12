function [fct] = calc_fct(fc28,s,t)
%Quando a verificação se faz em data j inferior a 28 dias, adota-se a expressão
%   NBR6118:2014 item 12.3.3 Resistência de cálculo do concreto.
fct=exp(s*(1-(28/t)^(1/2)))*fc28;
end

