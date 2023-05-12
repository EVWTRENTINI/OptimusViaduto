function [a,b,c] = parabola(x1,x2,x3,y1,y2,y3)
%Acha os coeficientes da parabola
%   Apartir dos pontos xi,yi encontra a parabola y = a*x^2 + b*x + c


a = y1/(x1*x1 - x1*x2 - x1*x3 + x2*x3) + y2/(-x1*x2 + x1*x3 + x2*x2 - x2*x3) + y3/(x1*x2 - x1*x3 - x2*x3 + x3*x3);
b = - (x2*y1)/(x1*x1 - x1*x2 - x1*x3 + x2*x3) - (x3*y1)/(x1*x1 - x1*x2 - x1*x3 + x2*x3) - (x1*y2)/(-x1*x2 + x1*x3 + x2*x2 - x2*x3) - (x3*y2)/(-x1*x2 + x1*x3 + x2*x2 - x2*x3) - (x1*y3)/(x1*x2 - x1*x3 - x2*x3 + x3*x3) - (x2*y3)/(x1*x2 - x1*x3 - x2*x3 + x3*x3);
c = (x2*x3*y1)/(x1*x1 - x1*x2 - x1*x3 + x2*x3) + (x1*x3*y2)/(-x1*x2 + x1*x3 + x2*x2 - x2*x3) + (x1*x2*y3)/(x1*x2 - x1*x3 - x2*x3 + x3*x3);


end

