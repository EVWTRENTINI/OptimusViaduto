function [] = draw_fresta_de_laje(ax,joints,jb,r,info,viaduto)
hold(ax,'on')

for k=1:viaduto.n_apoios-1
    for g=1:viaduto.vao(k).n_longarinas-1
        hlj=viaduto.vao(k).laje.h;
        bf_por_2=info.longarinas.vao(k).longarina(g).bf_por_2;
        secao=info.longarinas.vao(k).longarina(g).secao;
        lb=info.longarinas.vao(k).longarina(1).lb;
        n = info.longarinas.vao(k).longarina(g).membros;

        meia_fresta_1=info.longarinas.vao(k).longarina(g).fresta_ate_meio;
        meia_fresta_2=info.longarinas.vao(k).longarina(g+1).fresta_ate_meio;
        fresta=meia_fresta_1+meia_fresta_2;
        if abs(fresta)>0.01

            secao_b=[0 bf_por_2+fresta max(secao(:,3));...
                0 bf_por_2+fresta max(secao(:,3))-hlj;...
                0 bf_por_2 max(secao(:,3))-hlj;...
                0 bf_por_2 max(secao(:,3));...
                0 bf_por_2+fresta max(secao(:,3))];

            secao_e=secao_b;
            secao_e(:,1)=secao_e(:,1)+lb;
            secao_b=secao_b*r(:,:,n);
            secao_e=secao_e*r(:,:,n);

            [np,~]=size(secao_b);

            for f=1:np-1
                x=[secao_b(f,1) secao_b(f+1,1) secao_e(f+1,1) secao_e(f,1)]+joints(jb(n,1),1);
                y=[secao_b(f,2) secao_b(f+1,2) secao_e(f+1,2) secao_e(f,2)]+joints(jb(n,1),2);
                z=[secao_b(f,3) secao_b(f+1,3) secao_e(f+1,3) secao_e(f,3)]+joints(jb(n,1),3);
                patch(ax,x,y,z,[.5 .5 .5]);
            end
            patch(ax,transpose(secao_b(:,1))+joints(jb(n,1),1),...
                transpose(secao_b(:,2))+joints(jb(n,1),2),...
                transpose(secao_b(:,3))+joints(jb(n,1),3),[.5 .5 .5]);

            patch(ax,transpose(secao_e(:,1))+joints(jb(n,1),1),...
                transpose(secao_e(:,2))+joints(jb(n,1),2),...
                transpose(secao_e(:,3))+joints(jb(n,1),3),[.5 .5 .5]);

        end
    end
end




hold(ax,'off')
end