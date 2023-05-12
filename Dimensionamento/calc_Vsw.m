function Vsw = calc_Vsw(Asw_s,d,fywd,alfa)
%Calcula Vsw em kN de acordo com o modelo I da NBR 6118:2014 item 17.4.2.2
%   Asw_s em cm²/cm
%   d em cm
%   fywd em kN
%   alfa em radianos

Vsw = Asw_s * 0.9 * d * fywd * (sin(alfa) + cos(alfa)); % kN
end