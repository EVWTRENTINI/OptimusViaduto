figure
plot([10;10],[halfa;0],'k--');%limite alongamento do aço
hold on;
plot([-Epcu;-Epcu],[halfa;0],'k--');%limite encurtamento do concreto
plot([0;0],[0;halfa],'k');%deformação nula
plot([20;-10],[0;0],'k');%face inferior
plot([20;-10],[halfa;halfa],'k');%face superior
plot([0;10],[halfa;halfa-d],'m--');%limite dominio 1-2
plot([-Epcu;10],[halfa;halfa-d],'m--');%limite dominio 2-3
plot([-Epcu;2.0703933747412008281573498964803],[halfa;halfa-d],'m--');%limite dominio 3-4
plot([-Epcu;0],[halfa;0],'m--');%limite dominio 4a-5
plot([-Epc2;-Epc2],[halfa;0],'m--');%reta b

text(2.07,halfa-d*1.05,[num2str(2.07,3) ' ‰'],'Color','black','VerticalAlignment','middle','HorizontalAlignment','left');
text(-EpA/xa*(vmax-min(ap.y))+EpA,halfa-d*.95,[num2str(-EpA/xa*(vmax-min(ap.y))+EpA,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center');
text(-Epcu,halfa*1.05,[num2str(Epcu,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center');
text(EpA,halfa*.95,[num2str(EpA,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','center');
text(0,halfa-xa,['  L.N., x=' num2str(xa*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');

plot([20;-10],[halfa-xa;halfa-xa],'k--');% x linha neutra
plot([-EpA/xa*(vmax-min(ap.y))+EpA;0],[halfa-d;halfa-d],'b');%Alongamento aço mais alongado
plot([-EpA/xa*(vmax-min(ap.y))+EpA;EpA],[halfa-d;halfa],'k');%linha do alongamento 1 da face superior ao aço passivo
plot([EpA;0],[halfa;halfa-xa],'k');%linha do alongamento 2 da face superior ate a linha neutra

Es=viaduto.Es;%kN/cm² %modulo de elasticidade aço passivo
fpyd=viaduto.fpyd;%kN/cm² 
fptd=viaduto.fptd;%kN/cm² 
Eppu=viaduto.Eppu;%‰
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade
fyd=viaduto.fyk/viaduto.gama_s;

[Nc,Mc] = Nc_Mc(fcd,n_conc,EpA,xa,Epap,d,Epcu,Epc2,secao,vmax,mult_fcd);
[Nap,Map] = Nap_Map(ap,EpA,xa,Epap,vmax,Es,fyd);
[Naa,Maa] = Naa_Maa(aa,ap,EpA,xa,Epap,vmax,fpyd,fptd,Eppu,Ep);%Aço Ativo CP-190 RB kN e kN*m

text(0,halfa-vmax-Mc/Nc,'$\rightarrow$','FontSize',20,'Color',[.25 .25 .25],'Interpreter','latex','VerticalAlignment','middle');
text(0,halfa-vmax-Mc/Nc,['Rcd=' num2str(-Nc,4) ' kN '],'Color',[.25 .25 .25],'VerticalAlignment','middle','HorizontalAlignment','right');


if Nap<0
    text(0,halfa-vmax-Map/Nap,'$\rightarrow$','FontSize',20,'Color','blue','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','left');
    text(0,halfa-vmax-Map/Nap,['Rsd=' num2str(-Nap,4) ' kN '],'Color','blue','VerticalAlignment','middle','HorizontalAlignment','right');
elseif Nap>0
    text(0,halfa-vmax-Map/Nap,'$\leftarrow$','FontSize',20,'Color','blue','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','right');
    text(0,halfa-vmax-Map/Nap,[' Rsd=' num2str(Nap,4) ' kN'],'Color','blue','VerticalAlignment','middle','HorizontalAlignment','left');
end

if Naa<0
    text(0,halfa-vmax-Maa/Naa,'$\rightarrow$','FontSize',20,'Color','red','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','left');
    text(0,halfa-vmax-Maa/Naa,['Rpd=' num2str(-Naa,4) ' kN '],'Color','red','VerticalAlignment','middle','HorizontalAlignment','right');
elseif Naa>0
    text(0,halfa-vmax-Maa/Naa,'$\leftarrow$','FontSize',20,'Color','red','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','right');
    text(0,halfa-vmax-Maa/Naa,[' Rpd=' num2str(Naa,4) ' kN'],'Color','red','VerticalAlignment','middle','HorizontalAlignment','left');
end




    axis([-6 10.5 -halfa*.1 halfa*1.1]);

set(gca, 'yticklabel', []);
drawnow
hold off
