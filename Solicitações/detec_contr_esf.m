function [lista_LC] = detec_contr_esf(Fk,info)
%Detecta quais casos de carregamento contribuiem para determinado esforço
%maximo escolhido
%   Caso queira o minimo, entrar com os carregamentos com o sinal invertido

Fk=reshape(Fk,1,[]);

PPi=info.LC.PP_ini;
MULTi=info.LC.MULT_ini;
VEICi=info.LC.VEIC_ini;
FRENi=info.LC.FREN_ini;
RFTi=info.LC.RFT_ini;
V90i=info.LC.V90_ini;
CEPi=info.LC.CEP_ini;
Qai=MULTi;

PPf=info.LC.PP_fim;
MULTf=info.LC.MULT_fim;
VEICf=info.LC.VEIC_fim;
FRENf=info.LC.FREN_fim;
RFTf=info.LC.RFT_fim;
V90f=info.LC.V90_fim;
CEPf=info.LC.CEP_fim;
Qaf=FRENf;

PPn=PPf-PPi+1;
MULTn=MULTf-MULTi+1;
VEICn=VEICf-VEICi+1;
FRENn=FRENf-FRENi+1;
RFTn=RFTf-RFTi+1;
V90n=V90f-V90i+1;
CEPn=CEPf-CEPi+1;

ny=info.LC.MULT_fim-info.LC.MULT_ini+1;

lista_LC.MULT=zeros(1,ny);
lista_LC.VEIC=0;
lista_LC.FREN=0;
lista_LC.RFT=0;
lista_LC.V90=0;
lista_LC.V90dir=0;
lista_LC.CEP=0;
lista_LC.CEPdir=0;

%% Qa %MULT
        
for faixa=1:ny
    if Fk(MULTi+faixa-1)>0
        lista_LC.MULT(faixa)=1;
    end
end

%% Qa %VEIC

for pVEIC=1:VEICn %montar vetor que anota esforço neste ponto pra todas as posições
    FkVEIC(pVEIC)=Fk(VEICi+pVEIC-1);
end
[maxFkVEIC,indFkVEIC]=max(FkVEIC);%[máximo,indice do máximo]

if maxFkVEIC>0
    lista_LC.VEIC=VEICi+indFkVEIC-1;
end

%% Qa %FREN

if Fk(FRENi)>0
    lista_LC.FREN=1;
else
    lista_LC.FREN=-1;
end

%% RFT

if Fk(RFTi)>0
    lista_LC.RFT=1;
end

%% VT

for iVT=1:V90n %montar vetor que anota esforço neste ponto pra todas as posições
    FkVT(iVT)=abs(Fk(V90i+iVT-1));
end

[~,indmaxFkVT]=max(FkVT);

lista_LC.V90=V90i+indmaxFkVT-1;

if Fk(lista_LC.V90)>0
    lista_LC.V90dir=1;
else
    lista_LC.V90dir=-1;
end
        
%% CEP

for iCEP=1:CEPn %montar vetor que anota esforço neste ponto pra todas as posições
    FkCEP(iCEP)=abs(Fk(CEPi+iCEP-1));
end

[~,indmaxFkCEP]=max(FkCEP);

lista_LC.CEP=CEPi+indmaxFkCEP-1;

if Fk(lista_LC.CEP)>0
    lista_LC.CEPdir=1;
else
    lista_LC.CEPdir=-1;
end


end

