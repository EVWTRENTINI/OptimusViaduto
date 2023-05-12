function Vc0 = calc_Vc0(fctd, bw, d)
%Calcula Vc0 em kN de acordo com o modelo I da NBR 6118:2014 item 17.4.2.2
%   fctd em MPa
%   bw em cm
%   d em cm
Vc0 = 0.6 * fctd / 10 * bw * d;%kN
end