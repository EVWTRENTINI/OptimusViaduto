function [Nctr,Mctr] = Nctr_Mctr(fcd,c1,c2,y,mult_fcd)
%Calcula o resultado da integral do retangulo sem condição de contorno
% Nctp-Normal concreto trapezio retangulo
% Mctp-Momento concreto trapezio retangulo

Nctr=mult_fcd*fcd*(c1*y+c2*y^2/2);
Mctr=mult_fcd*fcd*(c1*y*y/2+c2*y*y*y/3);%Codigo fonte do OblqCalco
end
