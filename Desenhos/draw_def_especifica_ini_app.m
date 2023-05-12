%Esta versão 2 utilia o Epap_ini, resolvendo o problema de xa=0.

%figure
plot(fa,[10;10],[halfa;0],'k--');%limite alongamento do aço
hold (fa,'on');
plot(fa,[-Epcu;-Epcu],[halfa;0],'k--');%limite encurtamento do concreto
plot(fa,[20;-10],[halfa+hlj;halfa+hlj],'k--');%laje
plot(fa,[0;0],[0;halfa],'k');%deformação nula
plot(fa,[20;-10],[0;0],'k');%face inferior
plot(fa,[20;-10],[halfa;halfa],'k');%face superior
plot(fa,[0;10],[halfa;halfa-d],'m--');%limite dominio 1-2
plot(fa,[-Epcu;10],[halfa;halfa-d],'m--');%limite dominio 2-3
plot(fa,[-Epcu;2.0703933747412008281573498964803],[halfa;halfa-d],'m--');%limite dominio 3-4
plot(fa,[-Epcu;0],[halfa;0],'m--');%limite dominio 4a-5
plot(fa,[-Epc2;-Epc2],[halfa;0],'m--');%reta b

text(fa,2.07,halfa-d*1.07,[num2str(2.07,3) ' ‰'],'Color','black','VerticalAlignment','middle','HorizontalAlignment','left');
text(fa,Epap_ini,halfa-d*1,[num2str(Epap_ini,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left');
text(fa,-Epcu,halfa*1.01,[num2str(Epcu,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center');
text(fa,EpA_ini,halfa*1,[num2str(EpA_ini,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');
if not(EpA_ini==Epap_ini)
    text(fa,5,halfa-xa,['  L.N., x=' num2str(xa*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
end


if not(EpA_ini==Epap_ini)
    plot(fa,[20;-10],[halfa-xa;halfa-xa],'k--');% x linha neutra
end
plot(fa,[Epap_ini;0],[halfa-d;halfa-d],'b');%Alongamento aço mais alongado
plot(fa,[Epap_ini;EpA_ini],[halfa-d;halfa],'g','LineWidth',2);%linha do alongamento 1 da face superior ao aço passivo
if not(EpA_ini==Epap_ini)
    plot(fa,[EpA_ini;0],[halfa;halfa-xa],'g','LineWidth',2);%linha do alongamento 2 da face superior ate a linha neutra
end

Es=viaduto.Es;%kN/cm² %modulo de elasticidade aço passivo
fpyd=viaduto.fpyd;%kN/cm² 
fptd=viaduto.fptd;%kN/cm² 
Eppu=viaduto.Eppu;%‰
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade
fyd=viaduto.fyk/viaduto.gama_s;

[Nc,Mc] = Nc_Mc(fcd,n_conc,EpA_ini,xa,Epap_ini,d,Epcu,Epc2,secao,vmax,mult_fcd);
[Nap,Map] = Nap_Map(ap,EpA_ini,xa,Epap_ini,vmax,Es,fyd);
[Naa,Maa] = Naa_Maa(aa,ap,EpA_ini,xa,Epap_ini,vmax,fpyd,fptd,Eppu,Ep);%Aço Ativo CP-190 RB kN e kN*m

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
%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CALCULO DO EpC_pos_min;
    k_ini=(Epap_ini-EpA_ini)/dl/1000;%metros
    EpC_ini=k_ini*1000*((halfal-dl))+Epap_ini;
    EpC_tot21=0;
    EpC_pos21=EpC_tot21-EpC_ini;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

k32B=((10-Epap_ini)-(-Epcu))/dll/1000;
EpA_pos32B=hlj*k32B*1000+(-Epcu);
k21B=((EpC_pos21)-(-Epcu))/halfall/1000;
EpA_pos21B=hlj*k21B*1000+(-Epcu);
EpA_ini32B=(-Epcu)-EpA_pos32B;
EpA_ini21B=(-Epcu)-EpA_pos21B;
plot(fa,[EpA_ini32B;EpA_ini21B],[halfall-hlj;halfall-hlj],'g')
scatter(fa,EpA_ini32B,halfall-hlj,20,'m','filled');
scatter(fa,EpA_ini21B,halfall-hlj,20,'b','filled');
scatter(fa,EpA_ini,halfall-hlj,'+','k');

%%%%%%%%%%%%%%%%%%%%%%%%

axis(fa,[-6 10.5 -(halfa+hlj)*.1 (halfa+hlj)*1.1]);

set(fa, 'yticklabel', []);
%drawnow
hold (fa,'off');
