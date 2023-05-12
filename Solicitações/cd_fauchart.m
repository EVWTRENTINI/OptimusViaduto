function R = cd_fauchart(MT,K,invKu,L,Lacum,W)
%Distribui entre as longarinas uma carga distribuida aplicada no tabuleiro
%   Avalia o processode Fauchart e monta um vetor de reação R
[Nb,~]=size(L);
ini=W/2+MT.b;
fim=W/2+MT.e;
m=MT.m;
F=zeros((Nb+1)*2,1);
for Barra=1:1:Nb %Procurar barra carregada
    if ini>=Lacum(Barra,1) && ini<Lacum(Barra+1,1)
        b_ini=Barra;
    end
    if fim>=Lacum(Barra,1) && fim<Lacum(Barra+1,1)
        b_fim=Barra;
    end
end
if fim>=Lacum(Nb+1,1)
    b_fim=Nb;
end

for Barra=b_ini:1:b_fim
    lb=L(Barra,1);
    if b_ini==b_fim%Inicia e termina na mesma barra
        l1=ini-Lacum(Barra,1);
        l2=Lacum(Barra+1,1)-fim;
    else
        switch Barra
            case b_ini
                l1=ini-Lacum(Barra,1);
                l2=0;
            case b_fim
                l1=0;
                l2=Lacum(Barra+1,1)-fim;
            otherwise
                l1=0;
                l2=0;
        end
    end
      
    F(Barra*2-1,1)=F(Barra*2-1,1)-m*lb/2*(1-l1/lb^4*(2*lb^3-2*l1^2*lb+l1^3)-l2^3/lb^4*(2*lb-l2));
    F(Barra*2  ,1)=F(Barra*2  ,1)-m*lb^2/12*(1-l1^2/lb^4*(6*lb^2-8*l1*lb+3*l1^2)-l2^3/lb^4*(4*lb-3*l2));
    F(Barra*2+1,1)=F(Barra*2+1,1)-m*lb/2*(1-l1^3/lb^4*(2*lb-l1)-l2/lb^4*(2*lb^3-2*l2^2*lb+l2^3));
    F(Barra*2+2,1)=F(Barra*2+2,1)+m*lb^2/12*(1-l1^3/lb^4*(4*lb-3*l1)-l2^2/lb^4*(6*lb^2-8*l2*lb+3*l2^2));
    
end

U=invKu*F;
R=(K*U-F);
end

