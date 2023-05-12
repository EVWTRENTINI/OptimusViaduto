function [Mg0,R] = calc_Mg0(x,Al,k,j,viaduto,info)
%Calcula o momento proporcionado pela ação do peso proprio da longarina
%premoldada e a reação de apoio.

Mg0=zeros(1,(viaduto.disc_cabos+3));

All=info.longarinas.vao(k).longarina(j).A;
Allenr=info.longarinas.vao(k).longarina(j).Aenr;
enr=viaduto.vao(k).longarina.enr;

PP=25E3*(Al);
PPenr=25E3*(Allenr-All);

L=x(viaduto.disc_cabos+3)-2*x(2);

R=(PP*L+PPenr*enr*L*2)/2;

Mg0(1)=0;
Mg0(viaduto.disc_cabos+3)=0;
for i=2:viaduto.disc_cabos+2
    l=x(i)-x(2);
    if l<=enr*L
        Mg0(i)=R*(l)-(PP+PPenr)*(l^2)/2;
    elseif and(l>enr*L,l<=L-enr*L)
        Mg0(i)=R*(l)-(PP)*(l^2)/2-PPenr*enr*L*(l-enr*L/2);
    elseif l>L-enr*L
        Mg0(i)=R*(L-l)-(PP+PPenr)*((L-l)^2)/2;
    end
end

%plot(x,Mg0)
end