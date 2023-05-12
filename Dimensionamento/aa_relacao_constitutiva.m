function [tensao] = aa_relacao_constitutiva(Epi,Epp,fpyd,fptd,Eppu,Ep)
%Relação constitutiva do aço ativo CP-190 RB
%   Relação constitutiva do aço ativo CP-190 RB de acordo com 

Epyd=fpyd/Ep*1000;%‰

Ept=Epi+Epp;%‰

if Ept>=Epyd%‰
    tensao=fpyd+(fptd-fpyd)/(Eppu-Epyd)*(Ept-Epyd);%kN/cm²
elseif Ept <=-Epyd%‰
    tensao=-(fpyd+(fptd-fpyd)/(Eppu-Epyd)*(-Ept-Epyd));%kN/cm²
else
    tensao=Ep*Ept/1000;%kN/cm²
end

if Epi>10.001
    tensao=0;
elseif Epi<-10.001
    tensao=0;
end



end