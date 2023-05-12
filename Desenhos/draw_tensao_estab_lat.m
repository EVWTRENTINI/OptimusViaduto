function draw_tensao_estab_lat(secao,tensao,fs,comp)
figure

patch(zeros(length(secao),1),secao(:,1),secao(:,2),-tensao*fs)
hold on


patch(comp*ones(length(secao),1),secao(:,1),secao(:,2),[.5 .5 .5])

np=length(secao);

for f=1:np-1
    x=[0 0 comp comp];
    y=[secao(f,1) secao(f+1,1) secao(f+1,1) secao(f,1)];
    z=[secao(f,2) secao(f+1,2) secao(f+1,2) secao(f,2)];
    patch(x,y,z,[.5 .5 .5]);
end

patch(-tensao*fs,secao(:,1),secao(:,2),-tensao*fs)

for f=1:np-1
    x=[0 0 -tensao(f+1)*fs -tensao(f)*fs];
    y=[secao(f,1) secao(f+1,1) secao(f+1,1) secao(f,1)];
    z=[secao(f,2) secao(f+1,2) secao(f+1,2) secao(f,2)];
    patch(x,y,z,[-tensao(f)*fs -tensao(f+1)*fs -tensao(f+1)*fs -tensao(f)*fs]);
    text(-tensao(f)*fs,secao(f,1),secao(f,2),['   ' num2str(tensao(f),3) ' MPa'])

end

%colormap turbo 
%colorbar
axis equal vis3d
view(-28,18)
set(gca,'Visible','off')
set(gcf,'color','w')
hold off
end