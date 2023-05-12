%Aço ativo viga retangular inicio
ap.A=[1];%cm²
[~,ap.n]=size(ap.A);
%Aço ativo viga retangular fim

cont=0;
for Epi=-35:.1:35
    cont=cont+1;
    [tensao(cont)] = ap_relacao_constitutiva(Epi,viaduto.Es,fyd);
    def(cont)=Epi;
end

plot(def,tensao)