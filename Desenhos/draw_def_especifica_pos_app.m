%Esta versão 2 utilia o Epap_pos, resolvendo o problema de xb=0.

%figure

vlj = [-10 halfa-hlj; 20 halfa-hlj; 20 halfa; -10 halfa];
flj = [1 2 3 4];
patch(fa,'Faces',flj,'Vertices',vlj,'FaceColor',[.8 .8 .8])
hold (fa,'on');
plot(fa,[10;10],[halfa;0],'k--');%limite alongamento do aço
plot(fa,[-Epcu;-Epcu],[halfa;0],'k--');%limite encurtamento do concreto



plot(fa,[0;0],[0;halfa],'k');%deformação nula
plot(fa,[20;-10],[0;0],'k');%face inferior
plot(fa,[20;-10],[halfa;halfa],'k');%face superior

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
EpA_pos_min=(-Epcu)-EpA_ini;

k32A=((10-Epap_ini)-(EpA_pos_min))/(d-hlj)/1000;
k21A=((EpC_pos21)-(EpA_pos_min))/(halfal)/1000;
EpB_pos32A=-hlj*k32A*1000+EpA_pos_min;
EpB_pos21A=-hlj*k21A*1000+EpA_pos_min;

plot(fa,[-Epcu;10-Epap_ini],[halfa;halfa-d],'--','Color',[.7 .7 .7]);
plot(fa,[-Epcu-EpA_ini;EpC_pos21],[halfa-hlj;0],'--','Color',[.7 .7 .7]);
plot(fa,[-Epcu-EpA_ini;10-Epap_ini],[halfa-hlj;halfa-d],'--','Color',[.7 .7 .7]);
plot(fa,[-Epcu;EpC_pos21],[halfa;0],'--','Color',[.7 .7 .7]);

plot(fa,[EpA_pos_min;EpB_pos32A],[halfa-hlj;halfa],'--','Color',[.7 .7 .7]);%3-2%m
plot(fa,[EpA_pos_min;EpB_pos21A],[halfa-hlj;halfa],'--','Color',[.7 .7 .7]);%2-1%b

if EpA_pos21B>EpA_pos_min
    plot(fa,[-Epcu;EpC_pos21],[halfa;0],'b--');%LAJE
else
    if EpA_pos32B>EpA_pos_min
        k22a=(EpA_pos_min-(-Epcu))/hlj/1000;
        Epap22a=dll*k22a*1000+(-Epcu);
         plot(fa,[-Epcu;Epap22a],[halfa;halfa-dll],'g--');%LONGA
    end
    plot(fa,[-Epcu-EpA_ini;EpC_pos21],[halfa-hlj;0],'b--');%LONGA
    plot(fa,[EpA_pos_min;EpB_pos21A],[halfa-hlj;halfa],'b--');%2-1%b
end

if EpA_pos32B>EpA_pos_min
    plot(fa,[-Epcu;10-Epap_ini],[halfa;halfa-d],'m--');
else
    plot(fa,[-Epcu-EpA_ini;10-Epap_ini],[halfa-hlj;halfa-d],'m--');
    plot(fa,[EpA_pos_min;EpB_pos32A],[halfa-hlj;halfa],'m--');%3-2%m
end
    
% plot(fa,[-Epcu;10-Epap_ini],[halfa;halfa-d],'m--');
% plot(fa,[-Epcu-EpA_ini;0-Epap_ini],[halfa-hlj;halfa-d],'b--');
% plot(fa,[-Epcu-EpA_ini;10-Epap_ini],[halfa-hlj;halfa-d],'m--');
% plot(fa,[-Epcu;0-Epap_ini],[halfa;halfa-d],'b--');


%%%ANTIGO!
%plot(fa,[0;10],[halfa;halfa-d],'m--');%limite dominio 1-2
%plot(fa,[-Epcu;10],[halfa;halfa-d],'m--');%limite dominio 2-3
%plot(fa,[-Epcu;2.0703933747412008281573498964803],[halfa;halfa-d],'m--');%limite dominio 3-4
%plot(fa,[-Epcu;0],[halfa;0],'m--');%limite dominio 4a-5
%plot(fa,[-Epc2;-Epc2],[halfa;0],'m--');%reta b
%%%ANTIGO!


text(fa,2.07,halfa-d*1.07,[num2str(2.07,3) ' ‰'],'Color','black','VerticalAlignment','middle','HorizontalAlignment','left');
text(fa,Epap_pos,halfa-d*1,[num2str(Epap_pos,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left');
text(fa,-Epcu,halfa*1.01,[num2str(Epcu,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center');
text(fa,EpB_pos,halfa*1,[num2str(EpB_pos,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');
text(fa,EpA_pos,(halfa-hlj)*1,[num2str(EpA_pos,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');

if not(EpB_pos==Epap_pos)
    text(fa,5,halfa-xb,['  L.N., x=' num2str(xb*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
end


if not(EpB_pos==Epap_pos)
    plot(fa,[20;-10],[halfa-xb;halfa-xb],'k--');% x linha neutra
end
plot(fa,[Epap_pos;0],[halfa-d;halfa-d],'b');%Alongamento aço mais alongado
plot(fa,[Epap_pos;EpB_pos],[halfa-d;halfa],'r','LineWidth',2);%linha do alongamento 1 da face superior ao aço passivo
if not(EpB_pos==Epap_pos)
    plot(fa,[EpB_pos;0],[halfa;halfa-xb],'r','LineWidth',2);%linha do alongamento 2 da face superior ate a linha neutra
end

 
scatter(fa,-Epcu,halfa,'k');
scatter(fa,-Epcu-EpA_ini,halfa-hlj,'k');
scatter(fa,10-Epap_ini,halfa-d,'k');

axis(fa,[-6 10.5 -(halfa)*.1 (halfa)*1.1]);

set(fa, 'yticklabel', []);
%drawnow
hold (fa,'off');
