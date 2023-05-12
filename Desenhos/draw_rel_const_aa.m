%Aço ativo viga retangular inicio
aa.A=[1];%cm²
aa.Epp=[0];%cm²
[~,aa.n]=size(aa.A);
%Aço ativo viga retangular fim

fpyd=viaduto.fpyd;%kN/cm² 
fptd=viaduto.fptd;%kN/cm² 
Eppu=viaduto.Eppu;%‰
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade
fyd=viaduto.fyk/viaduto.gama_s;

cont=0;
for Epi=-35:.1:35
    cont=cont+1;
    [tensao(cont)] = aa_relacao_constitutiva(Epi,aa.Epp(1),fpyd,fptd,Eppu,Ep);
    def(cont)=Epi;
end

plot(def,tensao)