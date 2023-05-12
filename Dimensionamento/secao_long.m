function [secaol,Al,Iyl,ZCG,secaolenr,Alenr,Iylenr,ZCGlenr] = secao_long(viaduto,k)
%Calcula as propriedades da longarina pré moldada
%   Detailed explanation goes here
b1=viaduto.vao(k).longarina.b1;
b2=viaduto.vao(k).longarina.b2;
b3=viaduto.vao(k).longarina.b3;
benr=viaduto.vao(k).longarina.benr;
h1=viaduto.vao(k).longarina.h1;
h2=viaduto.vao(k).longarina.h2;
h3=viaduto.vao(k).longarina.h3;
h4=viaduto.vao(k).longarina.h4;
h5=viaduto.vao(k).longarina.h5;
%     1     2         3            4           5           6          7         8        9            10      11     12    13 
Y=[ -b1/2  -b1/2     -b2/2      -b2/2       -b3/2      -b3/2      b3/2      b3/2         b2/2       b2/2      b1/2   b1/2 -b1/2];
Z=[    0    -h2     -h2-h3     -h1+h5+h4    -h1+h5       -h1       -h1     -h1+h5      -h1+h5+h4    -h2-h3     -h2     0     0];
[~,ZCG]=centroide(Y,Z);
Z=Z-ZCG;


[ geom, iner, ~ ] = polygeom(Y,Z) ;
Al=geom(1);
Iyl=iner(1);
%J=((abs(Y(15)-Y(1)))*(hlj)^3+(h1+hlj/2)*(b2)^3)/3;
secaol(:,2)=(Z);
secaol(:,1)=(Y);

Yenr=Y;
Zenr=Z;
Yenr(3)=-benr/2;
Yenr(4)=-benr/2;
Yenr(9)=benr/2;
Yenr(10)=benr/2;
if (Y(9)-Y(8)) == 0
    Zenr(9)=Zenr(8);
else
    Zenr(9)=Zenr(8)+((Z(9)-Z(8))/(Y(9)-Y(8)))*(Yenr(9)-Y(8));
end
Zenr(4) =Zenr(9);
if (Y(11)-Y(10)) ==0
    Zenr(10)=Z(10);
else
    Zenr(10)=Z(10)+(Z(11)-Z(10))/(Y(11)-Y(10))*(Yenr(10)-Y(9));
end
Zenr(3)=Zenr(10);
if benr>b3
    Zenr(9)=Z(9);
    Zenr(4)=Z(9);
end
if benr>b1
    Zenr(10)=Z(10);
    Zenr(3)=Z(10);
end
Zenr=Zenr-max(Zenr);
[~,ZCGlenr]=centroide(Yenr,Zenr);
Zenr=Zenr-ZCGlenr;

[ geom, iner, ~ ] = polygeom(Yenr,Zenr) ;
Alenr=geom(1);
Iylenr=iner(1);
secaolenr(:,2)=(Zenr);
secaolenr(:,1)=(Yenr);

end

