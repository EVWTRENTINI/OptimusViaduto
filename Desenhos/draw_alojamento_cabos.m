figure
plot(secao(:,1),secao(:,2))
hold on
%plot(offs_l.x,offs_l.y) %contorno de eixo de cabo alojavel

%%CAMADAS
%             for i=1:nmc_real
%                 plot(camada(i).x,camada(i).y)
%             end
%%BARRAS
for i=1:n_bar_necessarias
    [Xas,Yas] = circulo(dcabo/2,16);
    plot(aa.x(i)+Xas,aa.y(i)+Yas,'r');
end


plot([min(secao(:,1)) max(secao(:,1))],[min(secao(:,2))+amp min(secao(:,2))+amp],'k--')
plot([min(secao(:,1)) max(secao(:,1))],[ultima_camada ultima_camada],'k--')

axis equal
%scatter(ap_objt.x,ap_objt.y,'o')
hold off
drawnow