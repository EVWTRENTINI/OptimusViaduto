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
nc=length(ap.camada);
for i=1:nc
    h=ap.camada(i).As/ap.camada(i).l;
    %plot(ap.camada(i).x,ap.camada(i).y,'b')
%     plot(ap.camada(i).x,ap.camada(i).y+h/2,'b');
%     plot(ap.camada(i).x,ap.camada(i).y-h/2,'b');
% xx=[ap.camada(i).x(1) ap.camada(i).x(2) ap.camada(i).x(2) ap.camada(i).x(1)];
% yy=[ap.camada(i).y(1)+h/2 ap.camada(i).y(2)+h/2 ap.camada(i).y(2)-h/2 ap.camada(i).y(1)-h/2];
% patch(xx,yy,'b');
v=[ap.camada(i).x(1) ap.camada(i).y(1)+h/2;...
   ap.camada(i).x(2) ap.camada(i).y(2)+h/2;...
   ap.camada(i).x(2) ap.camada(i).y(2)-h/2;...
   ap.camada(i).x(1) ap.camada(i).y(1)-h/2];
f=[1 2 3 4];
patch('Faces',f,'Vertices',v,'EdgeColor','b','FaceColor','none');
end

for i=1:aa.n
    [Xas,Yas] = circulo(aa.dcabo(i)/2,16);
    plot(aa.x(i)+Xas,aa.y(i)+Yas,'r');
    text(aa.x(i),aa.y(i),num2str(aa.ncord(i)),'VerticalAlignment','middle','HorizontalAlignment','center');
end

text(0,min(secao(:,2)),['As=' num2str(As*10^4,'%.1f') ' cm²'],'VerticalAlignment','top','HorizontalAlignment','center');


axis equal
%scatter(ap_objt.x,ap_objt.y,'o')
hold off
drawnow