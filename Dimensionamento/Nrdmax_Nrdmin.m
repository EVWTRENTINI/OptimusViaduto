function [Nrdmax,Nrdmin] = Nrdmax_Nrdmin(secao,ap,aa,fcd,Epc2,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd)
%Calcula o esforço normal máximo resistido pela seção transversal
%   
Asecao=area(secao(:,1),secao(:,2));%m²

ap.tensao=zeros(1,ap.n);
aa.tensao=zeros(1,aa.n);


%% Considerando que toda seção esta deformada em Epc2 - Reta B
% Calculo na normal mínima

Nap=0;
for i=1:ap.n
    ap.tensao(i)=ap_relacao_constitutiva(-Epc2,Es,fyd);%kN/cm²
    Napi=ap.tensao(i)*ap.A(i);%kN
    Nap=Nap+Napi;%kN
end

Naa=0;
for i=1:aa.n
    aa.tensao(i)=aa_relacao_constitutiva(-Epc2,aa.Epp(i),fpyd,fptd,Eppu,Ep);%kN/cm²
    Naai=aa.tensao(i)*aa.A(i);%kN
    Naa=Naa+Naai;%kN
end

Nrdmin=Asecao*fcd*mult_fcd*-1E3+Nap+Naa;


%% Considerando que toda seção esta deformada em 10‰ - Reta A
% Calculo na normal máxima

Nap=0;
for i=1:ap.n
    ap.tensao(i)=ap_relacao_constitutiva(10,Es,fyd);%kN/cm²
    Napi=ap.tensao(i)*ap.A(i);%kN
    Nap=Nap+Napi;%kN
end

Naa=0;
for i=1:aa.n
    aa.tensao(i)=aa_relacao_constitutiva(10,aa.Epp(i),fpyd,fptd,Eppu,Ep);%kN/cm²
    Naai=aa.tensao(i)*aa.A(i);%kN
    Naa=Naa+Naai;%kN
end


Nrdmax=Nap+Naa;

end

