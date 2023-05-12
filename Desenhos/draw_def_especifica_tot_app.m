%Esta versão 2 utilia o Epap_tot, resolvendo o problema de xb=0.

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
plot(fa,[0;10],[halfa;halfa-d],'m--');%limite dominio 1-2
plot(fa,[-Epcu;10],[halfa;halfa-d],'m--');%limite dominio 2-3
plot(fa,[-Epcu;2.0703933747412008281573498964803],[halfa;halfa-d],'m--');%limite dominio 3-4
plot(fa,[-Epcu;0],[halfa;0],'m--');%limite dominio 4a-5
plot(fa,[-Epc2;-Epc2],[halfa;0],'m--');%reta b

text(fa,2.07,halfa-d*1.07,[num2str(2.07,3) ' ‰'],'Color','black','VerticalAlignment','middle','HorizontalAlignment','left');
text(fa,Epap_tot,halfa-d*1,[num2str(Epap_tot,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','left');
text(fa,-Epcu,halfa*1.01,[num2str(Epcu,3) ' ‰'],'Color','black','VerticalAlignment','bottom','HorizontalAlignment','center');
text(fa,EpB_tot,halfa*1,[num2str(EpB_tot,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');
text(fa,EpA_tot,(halfa-hlj)*1,[num2str(EpA_tot,3) ' ‰'],'Color','black','VerticalAlignment','top','HorizontalAlignment','right');

if not(EpA_tot==EpB_tot)
    if and(xb1>=0,xb1<=hlj)
        text(fa,5,halfa-xb1,['  L.N. 1, x=' num2str(xb1*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
        plot(fa,[20;-10],[halfa-xb1;halfa-xb1],'k--');% x linha neutra
    end
end

if not(EpB_tot==Epap_tot)
    text(fa,5,halfa-xb2,['  L.N. 2, x=' num2str(xb2*100,3) ' cm'],'Color','b','VerticalAlignment','bottom','HorizontalAlignment','left');
    plot(fa,[20;-10],[halfa-xb2;halfa-xb2],'k--');% x linha neutra
end


plot(fa,[Epap_tot;0],[halfa-d;halfa-d],'b');%Alongamento aço mais alongado


plot(fa,[Epap_tot;EpA_tot;EpA_pos;EpB_pos],[halfa-d;halfa-hlj;halfa-hlj;halfa],'b','LineWidth',2)
% if not(EpB_tot==Epap_tot)
%     plot(fa,[EpB_tot;0],[halfa;halfa-xb],'r');%linha do alongamento 2 da face superior ate a linha neutra
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

%Zerando area de aço da laje
aalllj=aall;
aalllj.A(:)=0;
%Zerando area de aço da laje
aplllj=apll;
aplllj.A(:)=0;
for i=1:1:aplllj.n
    aplllj.camada(i).As=0;
end
%%%%%%%%%%%%%%%%%%%%%%
W=viaduto.W;
b1=viaduto.vao(1).longarina.b1;
'VAO 1'
long_i=2
n_longa=viaduto.vao(1).n_longarinas;
switch long_i
    case 1
        blj=(W-b1)/(n_longa-1)/2+b1/2;%Largura da laje sobre a longarina(m)
    case n_longa
        blj=(W-b1)/(n_longa-1)/2+b1/2;
    otherwise
        blj=(W-b1)/(n_longa-1);
end
secaolj=[-blj/2 0;-blj/2 -hlj;blj/2 -hlj;blj/2 0;-blj/2 0];
secaolj(:,2)=secaolj(:,2)+vmaxll;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dif_cg=vminll-vminl;
secaolg=secaol;
secaolg(:,2)=secaolg(:,2)+dif_cg;


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
[Nc1,Mc1] = Nc_Mc(fcd,n_conc,EpB_tot_lj,xb_lj,Epap_tot_lj,dll,Epcu,Epc2,secaolj,vmaxll,mult_fcd);
text(fa,0,halfa-vmax-Mc1/Nc1,'$\rightarrow$','FontSize',20,'Color',[.25 .25 .25],'Interpreter','latex','VerticalAlignment','middle');
text(fa,0,halfa-vmax-Mc1/Nc1,['Rcd1=' num2str(-Nc1,5) ' kN '],'Color',[.25 .25 .25],'VerticalAlignment','middle','HorizontalAlignment','right');


[Nc2,Mc2] = Nc_Mc(fcd,n_conc,EpB_tot_lg,xb_lg,Epap_tot_lg,dll,Epcu,Epc2,secaolg,vmaxll,mult_fcd);
text(fa,0,halfa-vmax-Mc2/Nc2,'$\rightarrow$','FontSize',20,'Color',[.25 .25 .25],'Interpreter','latex','VerticalAlignment','middle');
text(fa,0,halfa-vmax-Mc2/Nc2,['Rcd2=' num2str(-Nc2,5) ' kN '],'Color',[.25 .25 .25],'VerticalAlignment','middle','HorizontalAlignment','right');



axis(fa,[-6 10.5 -(halfa)*.1 (halfa)*1.1]);

set(fa, 'yticklabel', []);
%drawnow
hold (fa,'off');
