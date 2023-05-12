function [Naa,Maa] = Naa_Maa(aa,ap,EpA,xa,Epap,vmax,fpyd,fptd,Eppu,Ep)
%Sormatorio de normal e momento da aço ativo com curvatura definida por:
%Epa, deformação no ponto A e xa, linha neutra
%   Epap é a deformacao no aço ativo mais tracionado quando xa é igual a
%   zero
Naa=0;
Maa=0;
aa.tensao=zeros(1,aa.n);
d=vmax-min(ap.y);% em relação ao aço passivo
for i=1:aa.n
    k=(Epap-EpA)/d;
    Epi=k*(vmax-aa.y(i))+EpA;
%     if xa==0
%         Epi=Epap/d*(vmax-aa.y(i));%‰
%     else
%         Epi=-EpA/xa*(vmax-aa.y(i))+EpA;%‰
%     end
    aa.tensao(i)=aa_relacao_constitutiva(Epi,aa.Epp(i),fpyd,fptd,Eppu,Ep);%kN/cm²
    Naai=aa.tensao(i)*aa.A(i);%kN
    Maai=-Naai*aa.y(i);%kN*m
    Naa=Naa+Naai;%kN
    Maa=Maa+Maai;%kN*m
end
end