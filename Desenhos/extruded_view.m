function extruded_view(ax, secao,joints,jb,lb,r,draw_not)
%Desenha a visão estrudada da estrutura
%   cria um desenho 3D com PATCH

hold(ax,'on')
[~,ndraw_not]=size(draw_not);
[~,nb]=size(lb);

desenha=ones(1,nb);
for n=1:ndraw_not
    desenha(draw_not(n))=0;
end


for n=1:nb
    if desenha(n)==1
        secao_b=secao(n).nos;
        secao_e=secao(n).nos;
        secao_e(:,1)=secao_e(:,1)+lb(n);
        secao_b=secao_b*r(:,:,n);
        secao_e=secao_e*r(:,:,n);


        [np,~]=size(secao(n).nos);

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
axis(ax,"vis3d")
axis(ax,"equal")
view(ax,[-28 18])
hold(ax,'off')

end

