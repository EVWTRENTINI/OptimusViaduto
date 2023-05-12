hold off
plot(secao(:,1),secao(:,2))
hold on
scatter(secao(:,1),secao(:,2),'k','filled')

[nv,~]=size(secao);
for i=1:nv-1
    text(secao(i,1),secao(i,2),[' ' num2str(i)],'HorizontalAlignment','left','VerticalAlignment','bottom')
end
text(secao(nv,1),secao(nv,2),[' ' num2str(nv)],'HorizontalAlignment','left','VerticalAlignment','top')

plot(uc,z,'r')
scatter(uc,z,'g')



hold off