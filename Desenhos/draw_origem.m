%eixo
hold on
origem     =[0 0 0];
mag=.3;
inicio_seta=[0 0 0];  % X1 Y1 Z1
fim_seta   =[mag 0 0];% X2 Y2 Z2
plot3([inicio_seta(1) fim_seta(1)],...          %[X1 X2]
      [inicio_seta(2) fim_seta(2)],...          %[Y1 Y2]
      [inicio_seta(3) fim_seta(3)],'color',[0.6350 0.0780 0.1840]);%[Z1 Z2]
plot3(fim_seta(1),fim_seta(2),fim_seta(3),'o','color',[0.6350 0.0780 0.1840]);

inicio_seta=[0 0 0];  % X1 Y1 Z1
fim_seta   =[0 mag 0];% X2 Y2 Z2
plot3([inicio_seta(1) fim_seta(1)],...          %[X1 X2]
      [inicio_seta(2) fim_seta(2)],...          %[Y1 Y2]
      [inicio_seta(3) fim_seta(3)],'color',[0.4660 0.6740 0.1880]);%[Z1 Z2]
plot3(fim_seta(1),fim_seta(2),fim_seta(3),'o','color',[0.4660 0.6740 0.1880]);

inicio_seta=[0 0 0];     % X1 Y1 Z1
fim_seta   =[0 0 mag];   % X2 Y2 Z2
plot3([inicio_seta(1) fim_seta(1)],...          %[X1 X2]
      [inicio_seta(2) fim_seta(2)],...          %[Y1 Y2]
      [inicio_seta(3) fim_seta(3)],'color',[0 0.4470 0.7410]);%[Z1 Z2]
plot3(fim_seta(1),fim_seta(2),fim_seta(3),'o','color',[0 0.4470 0.7410]);




hold off