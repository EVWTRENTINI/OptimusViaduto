%Desenha as seções transversais da estrutura

hold on

num_secoes=1;
for n=1:nb
    secao_j=secao(n).nos;
    secao_size=size(secao(n).nos);    
    for j=1:num_secoes
        secao_j(:,1)=secao_j(:,1)+[(lb(n)/(num_secoes+1))];
        secao_rot=secao_j*r(:,:,n);
        for i=1:(secao_size(1)-1)
            plot3([secao_rot(i,1)+joints(jb(n,1),1) secao_rot(i+1,1)+joints(jb(n,1),1)],...
                  [secao_rot(i,2)+joints(jb(n,1),2) secao_rot(i+1,2)+joints(jb(n,1),2)],...
                  [secao_rot(i,3)+joints(jb(n,1),3) secao_rot(i+1,3)+joints(jb(n,1),3)],'color','b');
        end
        plot3([secao_rot(1,1)+joints(jb(n,1),1) secao_rot(secao_size(1),1)+joints(jb(n,1),1)],...
              [secao_rot(1,2)+joints(jb(n,1),2) secao_rot(secao_size(1),2)+joints(jb(n,1),2)],...
              [secao_rot(1,3)+joints(jb(n,1),3) secao_rot(secao_size(1),3)+joints(jb(n,1),3)],'color','b');
    end
end
hold off