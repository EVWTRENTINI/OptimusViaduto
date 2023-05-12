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

%%Faixas
for i=1:nc
    h=camada(i).As/camada(i).l;
    %plot(camada(i).x,camada(i).y,'b')
%     plot(camada(i).x,camada(i).y+h/2,'b');
%     plot(camada(i).x,camada(i).y-h/2,'b');
% xx=[camada(i).x(1) camada(i).x(2) camada(i).x(2) camada(i).x(1)];
% yy=[camada(i).y(1)+h/2 camada(i).y(2)+h/2 camada(i).y(2)-h/2 camada(i).y(1)-h/2];
% patch(xx,yy,'b');
v=[camada(i).x(1) camada(i).y(1)+h/2;...
   camada(i).x(2) camada(i).y(2)+h/2;...
   camada(i).x(2) camada(i).y(2)-h/2;...
   camada(i).x(1) camada(i).y(1)-h/2];
f=[1 2 3 4];
patch('Faces',f,'Vertices',v,'EdgeColor','b','FaceColor','none');
end

axis equal
%scatter(ap_objt.x,ap_objt.y,'o')
hold off
drawnow