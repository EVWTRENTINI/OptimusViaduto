%Esta versão 2 utilia o Epap, resolvendo o problema de xa=0.

%figure
plot(fa,[10;10],[halfa;0],'k--');%limite alongamento do aço
hold (fa,'on');
plot(fa,[-Epcu;-Epcu],[halfa;0],'k--');%limite encurtamento do concreto
plot(fa,[0;0],[0;halfa],'k');%deformação nula
plot(fa,[20;-10],[0;0],'k');%face inferior
plot(fa,[20;-10],[halfa;halfa],'k');%face superior
plot(fa,[0;10],[halfa;halfa-d],'m--');%limite dominio 1-2
plot(fa,[-Epcu;10],[halfa;halfa-d],'m--');%limite dominio 2-3
plot(fa,[-Epcu;2.0703933747412008281573498964803],[halfa;halfa-d],'m--');%limite dominio 3-4
plot(fa,[-Epcu;0],[halfa;0],'m--');%limite dominio 4a-5
plot(fa,[-Epc2;-Epc2],[halfa;0],'m--');%reta b

text(fa,2.07,halfa-d*1.05,[num2str(2.07,3) ' ‰'],'Color','black','VerticalAlignment','middle','HorizontalAlignment','left');
text(fa,Epap,halfa-d*.95,[num2str(Epap,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center');
text(fa,-Epcu,halfa*1.05,[num2str(Epcu,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center');
text(fa,EpA,halfa*.95,[num2str(EpA,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','center');
if not(EpA==Epap)
    text(fa,5,halfa-xa,['  L.N., x=' num2str(xa*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
end


if not(EpA==Epap)
    plot(fa,[20;-10],[halfa-xa;halfa-xa],'k--');% x linha neutra
end
plot(fa,[Epap;0],[halfa-d;halfa-d],'b');%Alongamento aço mais alongado
plot(fa,[Epap;EpA],[halfa-d;halfa],'k');%linha do alongamento 1 da face superior ao aço passivo
if not(EpA==Epap)
    plot(fa,[EpA;0],[halfa;halfa-xa],'k');%linha do alongamento 2 da face superior ate a linha neutra
end



[Nc,Mc] = Nc_Mc(fcd,n_conc,EpA,xa,Epap,d,Epcu,Epc2,secao,vmax,mult_fcd);
[Nap,Map] = Nap_Map(ap,EpA,xa,Epap,vmax,Es,fyd);
[Naa,Maa] = Naa_Maa(aa,ap,EpA,xa,Epap,vmax,fpyd,fptd,Eppu,Ep);%Aço Ativo CP-190 RB kN e kN*m

text(fa,0,halfa-vmax-Mc/Nc,'$\rightarrow$','FontSize',20,'Color',[.25 .25 .25],'Interpreter','latex','VerticalAlignment','middle');
text(fa,0,halfa-vmax-Mc/Nc,['Rcd=' num2str(-Nc,5) ' kN '],'Color',[.25 .25 .25],'VerticalAlignment','middle','HorizontalAlignment','right');


if Nap<0
    text(fa,0,halfa-vmax-Map/Nap,'$\rightarrow$','FontSize',20,'Color','blue','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','left');
    text(fa,0,halfa-vmax-Map/Nap,['Rsd=' num2str(-Nap,5) ' kN '],'Color','blue','VerticalAlignment','middle','HorizontalAlignment','right');
elseif Nap>0
    text(fa,0,halfa-vmax-Map/Nap,'$\leftarrow$','FontSize',20,'Color','blue','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','right');
    text(fa,0,halfa-vmax-Map/Nap,[' Rsd=' num2str(Nap,5) ' kN'],'Color','blue','VerticalAlignment','middle','HorizontalAlignment','left');
end

if Naa<0
    text(fa,0,halfa-vmax-Maa/Naa,'$\rightarrow$','FontSize',20,'Color','red','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','left');
    text(fa,0,halfa-vmax-Maa/Naa,['Rpd=' num2str(-Naa,5) ' kN '],'Color','red','VerticalAlignment','middle','HorizontalAlignment','right');
elseif Naa>0
    text(fa,0,halfa-vmax-Maa/Naa,'$\leftarrow$','FontSize',20,'Color','red','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','right');
    text(fa,0,halfa-vmax-Maa/Naa,[' Rpd=' num2str(Naa,5) ' kN'],'Color','red','VerticalAlignment','middle','HorizontalAlignment','left');
end

   

axis(fa,[-6 10.5 -halfa*.1 halfa*1.1]);

set(fa, 'yticklabel', []);
drawnow
hold (fa,'off')
