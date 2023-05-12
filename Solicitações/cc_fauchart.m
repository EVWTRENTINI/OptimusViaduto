function [R] = cc_fauchart(p,y,K,invKu,L,Lacum,W)
%Distribui entre as longarinas uma carga concentrada aplicada no tabuleiro
%   Avalia o processode Fuchart e monta um vetor de reação do tipo R
y0=W/2+y;
[Nb,~]=size(L);
for Barra=1:1:Nb %Procurar barra carregada
    if y0>=Lacum(Barra,1) && y0<Lacum(Barra+1,1)
        Infbc=Barra;
        a=y0-Lacum(Barra,1);
        b=L(Barra,1)-a;
    end
end
if y0>=Lacum(Nb+1,1)
    a=L(Nb,1);
    b=0;
    Infbc=Nb;
end
F=zeros((Nb+1)*2,1);
F(Infbc*2-1,1)=-1*b^2/L(Infbc,1)^3*(3*a+b);
F(Infbc*2  ,1)=-1*a*b^2/L(Infbc,1)^2;
F(Infbc*2+1,1)=-1*a^2/L(Infbc,1)^3*(3*b+a);
F(Infbc*2+2,1)=1*b*a^2/L(Infbc,1)^2;

U=invKu*F;
R=(K*U-F)*p;

end

