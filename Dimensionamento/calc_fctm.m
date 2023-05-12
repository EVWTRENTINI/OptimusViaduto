function [fctm,fctkinf,fctksup] = calc_fctm(fck)
%Calcula a resistencia a tração do concreto
%   Calcula de acordo com a NBR 6118:2014 com fck, fctk em MPa
%% 
if fck<=50
    fctm=0.3*(fck^2)^(1/3);
else
    fctm=2.12*log(1+.11*fck);
end
fctkinf=0.7*fctm;
fctksup=1.3*fctm;

end

