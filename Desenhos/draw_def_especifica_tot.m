%Esta versão 2 utilia o Epap_tot, resolvendo o problema de xb=0.

%figure
vlj = [-10 halfall-hlj; 20 halfall-hlj; 20 halfall; -10 halfall];
flj = [1 2 3 4];
plot(fa,[10;10],[halfall;0],'k--');%limite alongamento do aço
patch(fa,'Faces',flj,'Vertices',vlj,'FaceColor',[.8 .8 .8])
hold (fa,'on');
plot(fa,[-Epcut1e;-Epcut1e],[0;halfall-hlj],'k--');%limite encurtamento do concreto 1e
plot(fa,[-Epcut2e;-Epcut2e],[halfall-hlj;halfall],'k--');%limite encurtamento do concreto 2e


Epap_tot=Epap_ini+Epap_pos;
EpB_tot=EpB_pos;
EpA_tot=EpA_ini+EpA_pos;

plot(fa,[0;0],[0;halfall],'k');%deformação nula
plot(fa,[20;-10],[0;0],'k');%face inferior
plot(fa,[20;-10],[halfall;halfall],'k');%face superior
plot(fa,[0;10],[halfall;halfall-dll],'m--');%limite dominio 1-2
plot(fa,[-Epcut2e;10],[halfall;halfall-dll],'m--');%limite dominio 2-3
plot(fa,[-Epcut2e;2.0703933747412008281573498964803],[halfall;halfall-dll],'m--');%limite dominio 3-4
plot(fa,[-Epcut2e;0],[halfall;0],'m--');%limite dominio 4a-5
plot(fa,[-Epc2t2e;-Epc2t2e],[halfall;0],'m--');%reta b

text(fa,2.07,halfall-dll*1.07,[num2str(2.07,3) ' ‰'],'Color','black','VerticalAlignment','middle','HorizontalAlignment','left');
text(fa,Epap_tot,halfall-dll*1,[num2str(Epap_tot,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left');

text(fa,-Epcut1e,0,[' ' num2str(Epcut1e,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left','Rotation',90);
text(fa,-Epcut2e,halfall-hlj,[' ' num2str(Epcut2e,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left','Rotation',90);

text(fa,EpB_tot,halfall*1,[num2str(EpB_tot,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');
text(fa,EpA_tot,(halfall-hlj)*1,[num2str(EpA_tot,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');



k1=(EpA_pos-EpB_pos)/hlj/1000;%metros
if not(abs(EpA_pos-EpA_tot)<1E-10)
    xb1=-EpB_pos/1000/k1;
else
    xb1=0;%não existe
end

k2=(Epap_tot-EpA_tot)/(dl)/1000;%metros
if not(abs(EpB_tot-EpA_tot)<1E-10)
    xb2=-EpA_tot/1000/k2+hlj;
else
    xb2=0;%não existe
end




if not(EpA_tot==EpB_tot)
    if and(xb1>=0,xb1<=hlj)
        text(fa,5,halfall-xb1,['  L.N. 1, x=' num2str(xb1*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
        plot(fa,[20;-10],[halfall-xb1;halfall-xb1],'k--');% x linha neutra
    end
end

if not(EpB_tot==Epap_tot)
    text(fa,5,halfall-xb2,['  L.N. 2, x=' num2str(xb2*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
    plot(fa,[20;-10],[halfall-xb2;halfall-xb2],'k--');% x linha neutra
end


plot(fa,[Epap_tot;0],[halfall-dll;halfall-dll],'b');%Alongamento aço mais alongado


plot(fa,[Epap_tot;EpA_tot;EpA_pos;EpB_pos],[halfall-dll;halfall-hlj;halfall-hlj;halfall],'b','LineWidth',2)
% if not(EpB_tot==Epap_tot)
%     plot(fa,[EpB_tot;0],[halfall;halfall-xb],'r');%linha do alongamento 2 da face superior ate a linha neutra
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
EpB_tot_lj=EpB_pos;
Epap_tot_lj=Epap_pos;
k_pos=(Epap_pos-EpA_pos)/dl/1000;%metros
if not(abs(EpB_tot_lj-Epap_tot_lj)<1E-10)
    xb_lj=-EpB_pos/1000/k_pos;
else
    xb_lj=0;%não existe
end



Epap_tot_lg=Epap_ini+Epap_pos;
EpA_tot_lg=EpA_ini+EpA_pos;
k_tot_lg=(Epap_tot_lg-EpA_tot_lg)/dl/1000;
EpB_tot_lg=-k_tot_lg*1000*hlj+EpA_tot_lg;
if not(abs(EpB_tot_lg-Epap_tot_lg)<1E-10)
    xb_lg=-EpB_tot_lg/1000/k_tot_lg;
else
    xb_lg=0;%não existe
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Nc1,Mc1] = Nc_Mc(fcdt2e,n_conct2e,EpB_tot_lj,xb_lj,Epap_tot_lj,dll,Epcut2e,Epc2t2e,secaolj,vmaxll,mult_fcd);
text(fa,0,halfall-vmaxll-Mc1/Nc1,'$\rightarrow$','FontSize',20,'Color',[.25 .25 .25],'Interpreter','latex','VerticalAlignment','middle');
text(fa,0,halfall-vmaxll-Mc1/Nc1,['Rcd1=' num2str(-Nc1,5) ' kN '],'Color',[.25 .25 .25],'VerticalAlignment','middle','HorizontalAlignment','right');


[Nc2,Mc2] = Nc_Mc(fcdt1e,n_conct1e,EpB_tot_lg,xb_lg,Epap_tot_lg,dll,Epcut1e,Epc2t1e,secaolg,vmaxll,mult_fcd);
text(fa,0,halfall-vmaxll-Mc2/Nc2,'$\rightarrow$','FontSize',20,'Color',[.25 .25 .25],'Interpreter','latex','VerticalAlignment','middle');
text(fa,0,halfall-vmaxll-Mc2/Nc2,['Rcd2=' num2str(-Nc2,5) ' kN '],'Color',[.25 .25 .25],'VerticalAlignment','middle','HorizontalAlignment','right');



[Nap,Map] = Nap_Map(apll,EpB_tot_lg,xb_lg,Epap_tot_lg,vmaxll,Es,fyd);
[Naa,Maa] = Naa_Maa(aall,apll,EpB_tot_lg,xb_lg,Epap_tot_lg,vmaxll,fpyd,fptd,Eppu,Ep);%Aço Ativo CP-190 RB kN e kN*m

if Nap<0
    text(fa,0,halfall-vmaxll-Map/Nap,'$\rightarrow$','FontSize',20,'Color','blue','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','left');
    text(fa,0,halfall-vmaxll-Map/Nap,['Rsd=' num2str(-Nap,5) ' kN '],'Color','blue','VerticalAlignment','middle','HorizontalAlignment','right');
elseif Nap>0
    text(fa,0,halfall-vmaxll-Map/Nap,'$\leftarrow$','FontSize',20,'Color','blue','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','right');
    text(fa,0,halfall-vmaxll-Map/Nap,[' Rsd=' num2str(Nap,5) ' kN'],'Color','blue','VerticalAlignment','middle','HorizontalAlignment','left');
end

if Naa<0
    text(fa,0,halfall-vmaxll-Maa/Naa,'$\rightarrow$','FontSize',20,'Color','red','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','left');
    text(fa,0,halfall-vmaxll-Maa/Naa,[' Rpd=' num2str(Naa,5) ' kN, ε_{pre}=' num2str(aall.Epp(1),3) ' ‰'],'Color','red','VerticalAlignment','middle','HorizontalAlignment','right');
elseif Naa>0
    text(fa,0,halfall-vmaxll-Maa/Naa,'$\leftarrow$','FontSize',20,'Color','red','Interpreter','latex','VerticalAlignment','middle','HorizontalAlignment','right');
    text(fa,0,halfall-vmaxll-Maa/Naa,[' Rpd=' num2str(Naa,5) ' kN, ε_{pre}=' num2str(aall.Epp(1),3) ' ‰'],'Color','red','VerticalAlignment','middle','HorizontalAlignment','left');
end

text(fa,0,halfal/2,['N=' num2str(Naa+Nap+Nc1+Nc2,'%.2f') ' kN'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center','Rotation',90);
text(fa,0,halfal/2,['M=' num2str(Maa+Map+Mc1+Mc2,'%.2f') ' kN.m'],'Color','black','VerticalAlignment','top','HorizontalAlignment','center','Rotation',90);

text(fa,10,0,['fcd=' num2str(fcdt1e,'%.1f') ' MPa'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','right');
text(fa,10,halfall-hlj,['fcd=' num2str(fcdt2e,'%.1f') ' MPa'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','right');


axis(fa,[-6 10.5 -(halfall)*.1 (halfall)*1.1]);

set(fa, 'yticklabel', []);
%drawnow
hold (fa,'off');
