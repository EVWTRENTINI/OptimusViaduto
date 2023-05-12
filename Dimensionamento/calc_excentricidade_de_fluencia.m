function [ecc] = calc_excentricidade_de_fluencia(Uar,Umi,Ac,fck,delta_t_ef,s,alfa_flu,Ti,abatimento,alfa_e,le,Ic,MQP,NQP,ea)
%Calcula a excentricidade adicional de fleuncia
%   De acordo com a NBR 6118:2014 item 15.8.4


[h_fic] = calc_h_fic(Umi,Ac,Uar);
[phi] = calc_coeficiente_fluencia(fck,delta_t_ef,Umi,s,h_fic,alfa_flu,Ti,abatimento);%Coeficiente de fluência
Eci = calc_Eci(fck*1E6,alfa_e);
Ne=10*Eci*Ic/le^2/1000;%O 10 na verdade é pi^2, resultado em kN
ecc=(MQP/NQP+ea)*(2.718^(phi*NQP/(Ne-NQP))-1);% o 2.718 na verdade é o numero de Euler, resultado em metros

end

