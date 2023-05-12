function [Nap,Map] = Nap_Map(ap,EpA,xa,Epap,vmax,Es,fyd)
%Sormatorio de normal e momento da aço passivo com curvatura definida por:
%Epa, deformação no ponto A e xa, linha neutra
%   Epap é a deformacao no aço ativo mais tracionado quando xa é igual a
%   zero
Nap=0;
Map=0;
ap.tensao=zeros(1,ap.n);
d=vmax-min(ap.y);
for i=1:ap.n
    k=(Epap-EpA)/d;
    Epi=k*(vmax-ap.y(i))+EpA;
%     if xa==0
%         Epi=Epap/d*(vmax-ap.y(i));%‰
%     else
%         Epi=-EpA/xa*(vmax-ap.y(i))+EpA;%‰
%     end
    ap.tensao(i)=ap_relacao_constitutiva(Epi,Es,fyd);%kN/cm²
    Napi=ap.tensao(i)*ap.A(i);%kN
    Mapi=-Napi*ap.y(i);%kN*m
    Nap=Nap+Napi;%kN
    Map=Map+Mapi;%kN*m
end
end


