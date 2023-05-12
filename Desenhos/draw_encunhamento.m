plot(cabo(n).x,cabo(n).Sigx)
hold on
plot(cabo(n).x,(cabo(n).Sigx-B))
for i=1:nt+1
    plot([cabo(n).x(i) cabo(n).x(i)],[(cabo(n).Sigx(i)-B(i)) (cabo(n).Sigx(i))],'r')
end
if nt==ndc+2%Se as duas linhas não cruzarem
else
    plot(cabo(n).x(nt+1)+htri,(cabo(n).Sigx(nt+1)-B(nt+1)/2),'o')
end
ylim([0 max(cabo(n).Sigx)*1.3]);
xlim([0 max(cabo(n).x)]);
title('Encunhamento')
xlabel('x (m)')
ylabel('Tensão no cabo (kN/cm²)')
hold off
drawnow