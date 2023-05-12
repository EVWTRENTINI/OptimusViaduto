figure
plot(secao(:,1),secao(:,2))
hold on
[est_ex.x,est_ex.y] = offsetCurve(transpose(secao(1:end-1,1)),transpose(secao(1:end-1,2)), c);
est_ex.y(1)=est_ex.y(1)-c;
est_ex.y(end)=est_ex.y(end)-c;
est_ex.x(end+1)=est_ex.x(1);
est_ex.y(end+1)=est_ex.y(1);
plot(est_ex.x,est_ex.y,'Color',[0.6 0.6 0.6])

[est_ex.x,est_ex.y] = offsetCurve(transpose(secao(1:end-1,1)),transpose(secao(1:end-1,2)), c+fi_t);
est_ex.y(1)=est_ex.y(1)-c-fi_t;
est_ex.y(end)=est_ex.y(end)-c-fi_t;
est_ex.x(end+1)=est_ex.x(1);
est_ex.y(end+1)=est_ex.y(1);
plot(est_ex.x,est_ex.y,'Color',[0.6 0.6 0.6])

%%CAMADAS
%             for i=1:nmc_real
%                 plot(camada(i).x,camada(i).y)
%             end
%%BARRAS
for i=1:n_bar_necessarias
    [Xas,Yas] = circulo(fi_l/2,16);
    plot(ap.x(i)+Xas,ap.y(i)+Yas,'b');
end

plot([min(secao(:,1)) max(secao(:,1))],[min(secao(:,2))+amp-ah min(secao(:,2))+amp-ah],'r--')
plot([min(secao(:,1)) max(secao(:,1))],[min(secao(:,2))+amp min(secao(:,2))+amp],'r--')

axis equal
%scatter(ap_objt.x,ap_objt.y,'o')
hold off
drawnow