function draw_rf(esc,jf,joints)
%Desenha as reações de apoio

hold on
[nj,~]=size(jf);
for i=1:nj
        if (abs(jf(i))>10^-1)
            n=floor((i-1)/6)+1;%n=numero do nó
            dir=i-((n-1)*6);%direção
            cor=[0.4660 0.6740 0.1880];
            if dir==1
                plot3([joints(n,1) joints(n,1)+jf(i)*esc],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1)+jf(i)*esc,joints(n,2),joints(n,3),'o','color',cor);
                text( joints(n,1)+jf(i)*esc,joints(n,2),joints(n,3),...
                ['   RF=' num2str(abs(jf(i)))],'HorizontalAlignment','left');
            end
            if dir==2
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)+jf(i)*esc],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1),joints(n,2)+jf(i)*esc,joints(n,3),'o','color',cor);
                text( joints(n,1),joints(n,2)+jf(i)*esc,joints(n,3),...
                ['   RF=' num2str(abs(jf(i)))],'HorizontalAlignment','left');
            end
            if dir==3
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)+jf(i)*esc],'color',cor);
                plot3(joints(n,1),joints(n,2),joints(n,3)+jf(i)*esc,'o','color',cor);
                text( joints(n,1),joints(n,2),joints(n,3)+jf(i)*esc,...
                ['   RF=' num2str(abs(jf(i)))],'HorizontalAlignment','left');
            end
            if dir==4
                cor=[0.3010 0.7450 0.9330];
                plot3([joints(n,1) joints(n,1)+jf(i)*esc],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1)+jf(i)*esc,joints(n,2),joints(n,3),'o','color',cor);
                plot3(joints(n,1)+jf(i)*esc*.8,joints(n,2),joints(n,3),'o','color',cor);
                text( joints(n,1)+jf(i)*esc,joints(n,2),joints(n,3),...
                ['   RM=' num2str(abs(jf(i)))],'HorizontalAlignment','left');
            end
            if dir==5
                cor=[0.3010 0.7450 0.9330];
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)+jf(i)*esc],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1),joints(n,2)+jf(i)*esc,joints(n,3),'o','color',cor);
                plot3(joints(n,1),joints(n,2)+jf(i)*esc*.8,joints(n,3),'o','color',cor);
                text( joints(n,1),joints(n,2)+jf(i)*esc,joints(n,3),...
                ['   RM=' num2str(abs(jf(i)))],'HorizontalAlignment','left');
            end
            if dir==6
                cor=[0.3010 0.7450 0.9330];
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)+jf(i)*esc],'color',cor);
                plot3(joints(n,1),joints(n,2),joints(n,3)+jf(i)*esc,'o','color',cor);
                plot3(joints(n,1),joints(n,2),joints(n,3)+jf(i)*esc*.8,'o','color',cor);
                text( joints(n,1),joints(n,2),joints(n,3)+jf(i)*esc,...
                ['   RM=' num2str(abs(jf(i)))],'HorizontalAlignment','left');
            end
        end
end
hold off
end