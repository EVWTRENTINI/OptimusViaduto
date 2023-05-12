function [Kglobal,invKu,L,Lacum] = constroi_fauchart(viaduto,info,k)
%Constroi a matriz de rigidez para o tabuleiro k
%   Constroi a matriz de rigidez para membros com 4 graus de liberdade
%   O processo de Fauchart utilizado aqui é uma adaptação de Trentini
%   (2016).


Vtrans=viaduto.W;
Vlong=info.longarinas.vao(k).longarina(1).xe-info.longarinas.vao(k).longarina(1).xb;
Nlonga=viaduto.vao(k).n_longarinas;

fck_lj=viaduto.vao(k).laje.fck;
fck_lg=viaduto.vao(k).longarina.fck;
alfa_e=viaduto.alfa_e;
b1=viaduto.vao(k).longarina.b1;
h2=viaduto.vao(k).longarina.h2;

Hlaje=viaduto.vao(k).laje.h;

Ec=calc_Ecs(fck_lg,alfa_e);
Gc=Ec/2.4;




Nb=3*Nlonga-1;

cont=0;
for Barra=1:1:Nb
    cont=cont+1;
    if cont~=3 
        L(Barra,1)=b1/2;
        I(Barra,1)=(Hlaje+h2)^3/12;
    else
        L(Barra,1)=(Vtrans-Nlonga*b1)/(Nlonga-1);
        I(Barra,1)=Hlaje^3/12;
    end
    if cont==3
        cont=0;
    end
end


Ive=info.longarinas.vao(k).longarina(1).Iy;
Ivc=info.longarinas.vao(k).longarina(2).Iy;
FaucKvve=(pi/Vlong)^4*Ec*Ive; %N/m
FaucKvvc=(pi/Vlong)^4*Ec*Ivc;

Itve=info.longarinas.vao(k).longarina(1).J;  %m^4
Itvc=info.longarinas.vao(k).longarina(2).J;
FaucKtve=(pi/Vlong)^2*Gc*Itve; %N/rad
FaucKtvc=(pi/Vlong)^2*Gc*Itvc;




%% montarKlocal;

Ec=calc_Ecs(fck_lj,alfa_e);
Gc=Ec/2.4;

%DURANTE A FASE DE TESTES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ec=33792647721.065;
%Gc=Ec*.4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Klocal=zeros(4,4,Nb);
for Barra=1:1:Nb
    Klocal(1,1,Barra)=Ec*I(Barra,1)*12/L(Barra,1)^3;
    Klocal(1,2,Barra)=Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(1,3,Barra)=-Ec*I(Barra,1)*12/L(Barra,1)^3;
    Klocal(1,4,Barra)=Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(2,1,Barra)=Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(2,2,Barra)=Ec*I(Barra,1)*4/L(Barra,1);
    Klocal(2,3,Barra)=-Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(2,4,Barra)=Ec*I(Barra,1)*2/L(Barra,1);
    Klocal(3,1,Barra)=-Ec*I(Barra,1)*12/L(Barra,1)^3;
    Klocal(3,2,Barra)=-Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(3,3,Barra)=Ec*I(Barra,1)*12/L(Barra,1)^3;
    Klocal(3,4,Barra)=-Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(4,1,Barra)=Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(4,2,Barra)=Ec*I(Barra,1)*2/L(Barra,1);
    Klocal(4,3,Barra)=-Ec*I(Barra,1)*6/L(Barra,1)^2;
    Klocal(4,4,Barra)=Ec*I(Barra,1)*4/L(Barra,1);
end


%% montarKglobal;

Kglobal=zeros(Nb*2+2,Nb*2+2);
contl=0;
contc=0;
for Barra=1:1:Nb
    for mkgl=Barra*2-1:1:Barra*2+2
        contl=contl+1;
        for mkgc=Barra*2-1:1:Barra*2+2
            contc=contc+1;
            Kglobal(mkgl,mkgc)=Kglobal(mkgl,mkgc)+Klocal(contl,contc,Barra);
            if contc==4
                contc=0;
            end
        end
        if contl==4
                contl=0;
        end
    end
end


%% montarcoefmola;

coefmola=zeros(1,(Nb+1)*2);
cont=0;
No=2;
for cont=1:1:(Nb+1)*2
    No=No+1;
    if No==5
         coefmola(1,cont)=FaucKvvc;
    end
    if No==6
         coefmola(1,cont)=FaucKtvc;
    end
    if No==6
        No=0;
    end
end
coefmola(1,3)=FaucKvve;
coefmola(1,4)=FaucKtve;
coefmola(1,(Nb+1)*2-3)=FaucKvve;
coefmola(1,(Nb+1)*2-2)=FaucKtve;
coefmola=diag(coefmola);


%% K=Kglobal+coefmola;

invKu=inv(Kglobal+coefmola);

Lacum=zeros(Nb+1,1);
for Barra=2:1:Nb %MONTAR L ACUMULADO
    Lacum(1,1)=0;
    Lacum(2,1)=L(1,1);
    Lacum(Barra+1,1)=Lacum(Barra,1)+L(Barra,1);
    Lacum(Nb+1,1)=Vtrans;
end



end

 