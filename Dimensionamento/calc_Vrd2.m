function Vrd2 = calc_Vrd2(fck,gama_c,bw,d)
%Calcula Vrd2 em kN de acordo com o modelo I da NBR 6118:2014 item 17.4.2.2
%   fck em MPa
%   bw em cm
%   d em cm
Vrd2= 0.27 * (1 - fck / 250) * fck / gama_c / 10 * bw * d; % kN
end