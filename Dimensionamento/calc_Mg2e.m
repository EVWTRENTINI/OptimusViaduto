function [Mg2e] = calc_Mg2e(x,k,j,viaduto,info,hlj,blj)
%Calcula o momento proporcionado pela ação do peso proprio da longarina
%premoldada e a reação de apoio.

Mg2e=zeros(1,length(x));

All=info.longarinas.vao(k).longarina(j).A+(hlj*blj);
Allenr=info.longarinas.vao(k).longarina(j).Aenr+(hlj*blj);
enr=viaduto.vao(k).longarina.enr;

PP=25E3*(All);
PPenr=25E3*(Allenr-All);

L=x(end);

R=(PP*L+PPenr*enr*L*2)/2;


for i=1:length(x)
    l=x(i);
    if l<=enr*L
        Mg2e(i)=R*(l)-(PP+PPenr)*(l^2)/2;
    elseif and(l>enr*L,l<=L-enr*L)
        Mg2e(i)=R*(l)-(PP)*(l^2)/2-PPenr*enr*L*(l-enr*L/2);
    elseif l>L-enr*L
        Mg2e(i)=R*(L-l)-(PP+PPenr)*((L-l)^2)/2;
    end
end

%plot(x,Mg2e)
end