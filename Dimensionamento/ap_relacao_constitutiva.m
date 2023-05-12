function [tensao] = ap_relacao_constitutiva(Epi,Es,fyd)
%Relação constitutiva do aço passivo CA-50
%   Relação constitutiva do aço passivo CA-50 de acordo com a NBR 6118:2014
%50/1.15 kN/cm²

Epyd=fyd/Es*1000;

if Epi>=Epyd%‰
    tensao=fyd;%kN/cm²
elseif Epi <=-Epyd%‰
    tensao=-fyd;%kN/cm²
else
    tensao=Es*Epi/1000;%kN/cm²
end

if Epi>10.001
    tensao=0;
elseif Epi<-10.001
    tensao=0;
end



end