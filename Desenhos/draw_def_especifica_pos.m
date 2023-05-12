%Esta versão 2 utilia o Epap_pos, resolvendo o problema de xb=0.

%figure
vlj = [-10 halfall-hlj; 20 halfall-hlj; 20 halfall; -10 halfall];
flj = [1 2 3 4];
plot(fa,[10;10],[halfall;0],'k--');%limite alongamento do aço
patch(fa,'Faces',flj,'Vertices',vlj,'FaceColor',[.8 .8 .8])
hold (fa,'on');
plot(fa,[10;10],[halfall;0],'k--');%limite alongamento do aço
plot(fa,[-Epcut1e;-Epcut1e],[0;halfall-hlj],'k--');%limite encurtamento do concreto 1e
plot(fa,[-Epcut2e;-Epcut2e],[halfall-hlj;halfall],'k--');%limite encurtamento do concreto 2e


plot(fa,[0;0],[0;halfall],'k');%deformação nula
plot(fa,[20;-10],[0;0],'k');%face inferior
plot(fa,[20;-10],[halfall;halfall],'k');%face superior

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CALCULO DO EpC_pos_min;
% k_ini=(Epap_ini-EpA_ini)/dl/1000;%metros
% EpC_ini=k_ini*1000*((halfal-dl))+Epap_ini;
% EpC_tot21=0;
% EpC_pos21=EpC_tot21-EpC_ini;


%%%%%%%%%%%%%%%%%%%%%%%%%%%





% k32B=((10-Epap_ini)-(-Epcu))/dll/1000;
% EpA_pos32B=hlj*k32B*1000+(-Epcu);
% k21B=((EpC_pos21)-(-Epcu))/halfall/1000;
% EpA_pos21B=hlj*k21B*1000+(-Epcu);
% EpA_pos_min=(-Epcu)-EpA_ini;
% 
% k32A=((10-Epap_ini)-(EpA_pos_min))/(d-hlj)/1000;
% k21A=((EpC_pos21)-(EpA_pos_min))/(halfal)/1000;
EpB_pos32A=-hlj*k32A*1000+EpA_pos_min;
EpB_pos21A=-hlj*k21A*1000+EpA_pos_min;

plot(fa,[-Epcut2e;10-Epap_ini],        [halfall;    halfall-dll],'--','Color',[.7 .7 .7]);
plot(fa,[-Epcut1e-EpA_ini;EpC_pos21],  [halfall-hlj;0],'--','Color',[.7 .7 .7]);
plot(fa,[-Epcut1e-EpA_ini;10-Epap_ini],[halfall-hlj;halfall-dll],'--','Color',[.7 .7 .7]);
plot(fa,[-Epcut2e;EpC_pos21],          [halfall;    0],'--','Color',[.7 .7 .7]);

plot(fa,[EpA_pos_min;EpB_pos32A],[halfall-hlj;halfall],'--','Color',[.7 .7 .7]);%3-2%m
plot(fa,[EpA_pos_min;EpB_pos21A],[halfall-hlj;halfall],'--','Color',[.7 .7 .7]);%2-1%b

if EpA_pos21B>EpA_pos_min
    plot(fa,[-Epcut2e;EpC_pos21],[halfall;0],'b--');%LAJE
else
    if EpA_pos32B>EpA_pos_min
%         k22a=(EpA_pos_min-(-Epcu))/hlj/1000;
%         Epap22a=dll*k22a*1000+(-Epcu);
         plot(fa,[-Epcut2e;Epap22a],[halfall;halfall-dll],'g--');%LONGA
    end
    plot(fa,[-Epcut1e-EpA_ini;EpC_pos21],[halfall-hlj;0],'b--');%LONGA
    plot(fa,[EpA_pos_min;EpB_pos21A],[halfall-hlj;halfall],'b--');%2-1%b
end

if EpA_pos32B>EpA_pos_min
    plot(fa,[-Epcut2e;10-Epap_ini],[halfall;halfall-dll],'m--');
else
    plot(fa,[-Epcut1e-EpA_ini;10-Epap_ini],[halfall-hlj;halfall-dll],'m--');
    plot(fa,[EpA_pos_min;EpB_pos32A],[halfall-hlj;halfall],'m--');%3-2%m
end
    
% plot(fa,[-Epcu;10-Epap_ini],[halfall;halfall-d],'m--');
% plot(fa,[-Epcu-EpA_ini;0-Epap_ini],[halfall-hlj;halfall-d],'b--');
% plot(fa,[-Epcu-EpA_ini;10-Epap_ini],[halfall-hlj;halfall-d],'m--');
% plot(fa,[-Epcu;0-Epap_ini],[halfall;halfall-d],'b--');


%%%ANTIGO!
%plot(fa,[0;10],[halfall;halfall-d],'m--');%limite dominio 1-2
%plot(fa,[-Epcu;10],[halfall;halfall-d],'m--');%limite dominio 2-3
%plot(fa,[-Epcu;2.0703933747412008281573498964803],[halfall;halfall-d],'m--');%limite dominio 3-4
%plot(fa,[-Epcu;0],[halfall;0],'m--');%limite dominio 4a-5
%plot(fa,[-Epc2;-Epc2],[halfall;0],'m--');%reta b
%%%ANTIGO!


EpA_pos=k_pos*1000*(hlj)+EpB_pos;

k_pos=(Epap_pos-EpB_pos)/dll/1000;%metros
if not(abs(EpB_pos-Epap_pos)<1E-10)
    xb=-EpB_pos/1000/k_pos;
else
    xb=0;
end

text(fa,2.07,halfall-dll*1.07,[num2str(2.07,3) ' ‰'],'Color','black','VerticalAlignment','middle','HorizontalAlignment','left');
text(fa,Epap_pos,halfall-dll*1,[num2str(Epap_pos,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left');

text(fa,-Epcut1e,0,[' ' num2str(Epcut1e,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left','Rotation',90);
text(fa,-Epcut2e,halfall-hlj,[' ' num2str(Epcut2e,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left','Rotation',90);

text(fa,EpB_pos,halfall*1,[num2str(EpB_pos,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');
text(fa,EpA_pos,(halfall-hlj)*1,[num2str(EpA_pos,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');

if not(EpB_pos==Epap_pos)
    text(fa,5,halfall-xb,['  L.N., x=' num2str(xb*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
end


if not(EpB_pos==Epap_pos)
    plot(fa,[20;-10],[halfall-xb;halfall-xb],'k--');% x linha neutra
end
plot(fa,[Epap_pos;0],[halfall-dll;halfall-dll],'b');%Alongamento aço mais alongado
plot(fa,[Epap_pos;EpB_pos],[halfall-dll;halfall],'r','LineWidth',2);%linha do alongamento 1 da face superior ao aço passivo
if not(EpB_pos==Epap_pos)
    plot(fa,[EpB_pos;0],[halfall;halfall-xb],'r','LineWidth',2);%linha do alongamento 2 da face superior ate a linha neutra
end

text(fa,10,0,['fcd=' num2str(fcdt1e,'%.1f') ' MPa'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','right');
text(fa,10,halfall-hlj,['fcd=' num2str(fcdt2e,'%.1f') ' MPa'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','right');

 
scatter(fa,-Epcut2e,halfall,'k');
scatter(fa,-Epcut1e-EpA_ini,halfall-hlj,'k');
scatter(fa,10-Epap_ini,halfall-dll,'k');

axis(fa,[-6 10.5 -(halfall)*.1 (halfall)*1.1]);

set(fa, 'yticklabel', []);
%drawnow
hold (fa,'off');
