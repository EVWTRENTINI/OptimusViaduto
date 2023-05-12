function [J] = calc_Jret( b,h )
%Calcula o modulo de resistencia a torção para seção retagunlar
%   Subistituir por Roark’s Formulas for Stress and Strain pagina 401, erro 0,5% menor.
a=max(b,h);
b=min(b,h);
x=a/b;
c2=(183.59*x^6-2794*x^5+14950*x^4-25783*x^3-49983*x^2+269519*x-65468)/1000000;
if x>5
    c2=1/3*(1-0.63*1/x);
end
if c2>1/3
    c2=1/3;
end
J=c2*a*b^3;
end

