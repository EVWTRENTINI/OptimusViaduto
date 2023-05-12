function [COMB] = lista_LC2COMB(Fk,lista_LC,Mc,info)
%Utiliza a lista_LC para calcular os esforços maximos do ponto que foi
%feita a lista_LC
%   
[sp,~,~]=size(Fk);
Fk=reshape(Fk,sp,[]);
MULTi=info.LC.MULT_ini;
FRENi=info.LC.FREN_ini;
RFTi=info.LC.RFT_ini;

[~,ny]=size(lista_LC.MULT);

%% PP

COMB=Fk(:,1)*Mc(1);

%% Qa 
%MULT

for faixa=1:ny
    if lista_LC.MULT(faixa)==1
        COMB=COMB+Fk(:,MULTi+faixa-1)*Mc(2);
    end
end

%VEIC

if lista_LC.VEIC>0
    COMB=COMB+Fk(:,lista_LC.VEIC)*Mc(2);
end

%FREN

COMB=COMB+Fk(:,FRENi)*Mc(2)*lista_LC.FREN;

%% RFT

if not(lista_LC.RFT==0)
    COMB=COMB+Fk(:,RFTi)*Mc(3);
end

%% V90

COMB=COMB+Fk(:,lista_LC.V90)*Mc(4)*lista_LC.V90dir;

%% CEP

if not(Mc(5)==0)
    COMB=COMB+Fk(:,lista_LC.CEP)*Mc(5)*lista_LC.CEPdir;
end

end
