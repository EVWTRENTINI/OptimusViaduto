function draw_loads(esc,cc,cd,joints,jb,cm,lb,jl)
%Desenha os carregamentos
%[Barra direcao posicao valor] cc
    hold on
    [nbcc,~]=size(cc);
    [nbcd,~]=size(cd);
    [nb,~]=size(jb);
    [nj,~]=size(jl);
    vetor=zeros(3,3);
    for linhacc=1:nbcc %Carregamentos concentradas em barra
        n=cc(linhacc,1);
        cor=[0.6350 0.0780 0.1840];
        if (cc(linhacc,2)==4|cc(linhacc,2)==5|cc(linhacc,2)==6)
            cor=[0.4940 0.1840 0.5560];
        end
        vetor(1,:)=[lb(n)*cc(linhacc,3) 0 0]; %x1y1z1;x2y2z2
        if (cc(linhacc,2)==1|cc(linhacc,2)==4)
            vetor(2,:)=[lb(n)*cc(linhacc,3)+cc(linhacc,4)*esc 0 0];
        end
        if (cc(linhacc,2)==2||cc(linhacc,2)==5)
            vetor(2,:)=[lb(n)*cc(linhacc,3) cc(linhacc,4)*esc 0];
        end
        if (cc(linhacc,2)==3|cc(linhacc,2)==6)
            vetor(2,:)=[lb(n)*cc(linhacc,3) 0 cc(linhacc,4)*esc];
        end
        %segunda bolinha
        if cc(linhacc,2)==4
           vetor(3,:)=[lb(n)*cc(linhacc,3)+cc(linhacc,4)*esc*.8 0 0]; 
        end
        if cc(linhacc,2)==5
           vetor(3,:)=[lb(n)*cc(linhacc,3) cc(linhacc,4)*esc*.8 0]; 
        end
        if cc(linhacc,2)==6
           vetor(3,:)=[lb(n)*cc(linhacc,3) 0 cc(linhacc,4)*esc*.8]; 
        end
        vetor=vetor*cm(:,:,n);
        vetor=[vetor(1,1)+xi(n,joints,jb)...
               vetor(1,2)+yi(n,joints,jb)...
               vetor(1,3)+zi(n,joints,jb);...
               vetor(2,1)+xi(n,joints,jb)...
               vetor(2,2)+yi(n,joints,jb)...
               vetor(2,3)+zi(n,joints,jb);
               vetor(3,1)+xi(n,joints,jb)...
               vetor(3,2)+yi(n,joints,jb)...
               vetor(3,3)+zi(n,joints,jb)];
        plot3([vetor(1,1) vetor(2,1)],...
              [vetor(1,2) vetor(2,2)],...
              [vetor(1,3) vetor(2,3)],'color',cor)
        if (cc(linhacc,2)==1|cc(linhacc,2)==2|cc(linhacc,2)==3)
            text(vetor(2,1),vetor(2,2),vetor(2,3),...
            ['   F=' num2str(abs(cc(linhacc,4)))],'HorizontalAlignment','left');
            plot3([vetor(2,1)],...
                  [vetor(2,2)],...
                  [vetor(2,3)],'o','color',cor);
        else
            text(vetor(2,1),vetor(2,2),vetor(2,3),...
            ['   M=' num2str(abs(cc(linhacc,4)))],'HorizontalAlignment','left');
            plot3([vetor(2,1)],...
                  [vetor(2,2)],...
                  [vetor(2,3)],'o','color',cor);
            plot3([vetor(3,1)],...
                  [vetor(3,2)],...
                  [vetor(3,3)],'o','color',cor);  
        end
    end
    %[1-Barra 2-direcao 3-inicio 4-fim 5-valor] cd
    
    for linhacd=1:nbcd %Carregamentos distribuidas em barra
        n=cd(linhacd,1);
        cor=[0.6350 0.0780 0.1840];
        ld=lb(n)*cd(linhacd,4)-lb(n)*cd(linhacd,3);
        
        nv=floor(ld/2)+1;%numero de vetor por metro
        if nv==1
            nv=2;
        end
        delta=(ld)/(nv-1);
        if cd(linhacd,2)==4
            cor=[0.4940 0.1840 0.5560];
        end
        for i=1:nv
        vetor(1,:)=[(lb(n)*cd(linhacd,3)+delta*(i-1)) 0 0]; %x1y1z1;x2y2z2
        if (cd(linhacd,2)==1||cd(linhacd,2)==4)
            vetor(2,:)=[lb(n)*cd(linhacd,3)+delta*(i-1)+cd(linhacd,5)*esc 0 0];
        end
        if (cd(linhacd,2)==2||cd(linhacd,2)==5)
            vetor(2,:)=[lb(n)*cd(linhacd,3)+delta*(i-1) cd(linhacd,5)*esc 0];
        end
        if (cd(linhacd,2)==3||cd(linhacd,2)==6)
            vetor(2,:)=[lb(n)*cd(linhacd,3)+delta*(i-1) 0 cd(linhacd,5)*esc];
        end
        %segunda bolinha
        if cd(linhacd,2)==4
           vetor(3,:)=[lb(n)*cd(linhacd,3)+cd(linhacd,5)*esc*.8+delta*(i-1) 0 0]; 
        end
        if i==1% inicio linha da carga distribuida
                linha(1,:)=vetor(2,:);
        end
        if i==nv% final da linha da carga distribuida
                linha(2,:)=vetor(2,:);
        end
%         if cd(linhacd,2)==5
%            vetor(3,:)=[lb(n)*cd(linhacd,3)+delta*(i-1)) cd(linhacd,4)*esc*.8 0]; 
%         end
%         if cd(linhacd,2)==6
%            vetor(3,:)=[lb(n)*cd(linhacd,3)+delta*(i-1)) 0 cd(linhacd,4)*esc*.8]; 
%         end
        vetor=vetor*cm(:,:,n);
        
        vetor=[vetor(1,1)+xi(n,joints,jb)...
               vetor(1,2)+yi(n,joints,jb)...
               vetor(1,3)+zi(n,joints,jb);...
               vetor(2,1)+xi(n,joints,jb)...
               vetor(2,2)+yi(n,joints,jb)...
               vetor(2,3)+zi(n,joints,jb);
               vetor(3,1)+xi(n,joints,jb)...
               vetor(3,2)+yi(n,joints,jb)...
               vetor(3,3)+zi(n,joints,jb)];
        
        plot3([vetor(1,1) vetor(2,1)],...
              [vetor(1,2) vetor(2,2)],...
              [vetor(1,3) vetor(2,3)],'color',cor);
        
        if (cd(linhacd,2)==1|cd(linhacd,2)==2|cd(linhacd,2)==3)
            if i==nv
                text(vetor(2,1),vetor(2,2),vetor(2,3),...
                ['   Fd=' num2str(abs(cd(linhacd,5)))],'HorizontalAlignment','left');
            end    
                plot3([vetor(2,1)],...
                      [vetor(2,2)],...
                      [vetor(2,3)],'o','color',cor);
            
        else
            if i==nv
                text(vetor(2,1),vetor(2,2),vetor(2,3),...
                ['   Md=' num2str(abs(cd(linhacd,5)))],'HorizontalAlignment','left');
            end
            plot3([vetor(2,1)],...
                  [vetor(2,2)],...
                  [vetor(2,3)],'o','color',cor);
            plot3([vetor(3,1)],...
                  [vetor(3,2)],...
                  [vetor(3,3)],'o','color',cor);  
        end
    
    
        end
        linha=linha*cm(:,:,n);
        linha=[linha(1,1)+xi(n,joints,jb)...
               linha(1,2)+yi(n,joints,jb)...
               linha(1,3)+zi(n,joints,jb);...
               linha(2,1)+xi(n,joints,jb)...
               linha(2,2)+yi(n,joints,jb)...
               linha(2,3)+zi(n,joints,jb)];
        plot3([linha(1,1) linha(2,1)],...
              [linha(1,2) linha(2,2)],...
              [linha(1,3) linha(2,3)],'color',cor);
    end
    for i=1:nj
        if (abs(jl(i))>10^-5)
            n=floor((i-1)/6)+1;%n=numero do nó
            dir=i-((n-1)*6);%direção
            cor=[0.6350 0.0780 0.1840];
            if dir==1
                plot3([joints(n,1) joints(n,1)+jl(i)*esc],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1)+jl(i)*esc,joints(n,2),joints(n,3),'o','color',cor);
                text( joints(n,1)+jl(i)*esc,joints(n,2),joints(n,3),...
                ['   F=' num2str(abs(jl(i)))],'HorizontalAlignment','left');
            end
            if dir==2
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)+jl(i)*esc],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1),joints(n,2)+jl(i)*esc,joints(n,3),'o','color',cor);
                text( joints(n,1),joints(n,2)+jl(i)*esc,joints(n,3),...
                ['   F=' num2str(abs(jl(i)))],'HorizontalAlignment','left');
            end
            if dir==3
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)+jl(i)*esc],'color',cor);
                plot3(joints(n,1),joints(n,2),joints(n,3)+jl(i)*esc,'o','color',cor);
                text( joints(n,1),joints(n,2),joints(n,3)+jl(i)*esc,...
                ['   F=' num2str(abs(jl(i)))],'HorizontalAlignment','left');
            end
            if dir==4
                cor=[0.4940 0.1840 0.5560];
                plot3([joints(n,1) joints(n,1)+jl(i)*esc],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1)+jl(i)*esc,joints(n,2),joints(n,3),'o','color',cor);
                plot3(joints(n,1)+jl(i)*esc*.8,joints(n,2),joints(n,3),'o','color',cor);
                text( joints(n,1)+jl(i)*esc,joints(n,2),joints(n,3),...
                ['   M=' num2str(abs(jl(i)))],'HorizontalAlignment','left');
            end
            if dir==5
                cor=[0.4940 0.1840 0.5560];
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)+jl(i)*esc],[joints(n,3) joints(n,3)],'color',cor);
                plot3(joints(n,1),joints(n,2)+jl(i)*esc,joints(n,3),'o','color',cor);
                plot3(joints(n,1),joints(n,2)+jl(i)*esc*.8,joints(n,3),'o','color',cor);
                text( joints(n,1),joints(n,2)+jl(i)*esc,joints(n,3),...
                ['   M=' num2str(abs(jl(i)))],'HorizontalAlignment','left');
            end
            if dir==6
                cor=[0.4940 0.1840 0.5560];
                plot3([joints(n,1) joints(n,1)],[joints(n,2) joints(n,2)],[joints(n,3) joints(n,3)+jl(i)*esc],'color',cor);
                plot3(joints(n,1),joints(n,2),joints(n,3)+jl(i)*esc,'o','color',cor);
                plot3(joints(n,1),joints(n,2),joints(n,3)+jl(i)*esc*.8,'o','color',cor);
                text( joints(n,1),joints(n,2),joints(n,3)+jl(i)*esc,...
                ['   M=' num2str(abs(jl(i)))],'HorizontalAlignment','left');
            end
        end
    end
    hold off
end
