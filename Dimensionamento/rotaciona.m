function [xr,yr] = rotaciona(x,y,t)
%Rotaciola o vetor coluna de pontos em torno da origem
xy=[x y]*[cos(t) -sin(t); sin(t) cos(t)];

xr=xy(:,1);
yr=xy(:,2);

end

