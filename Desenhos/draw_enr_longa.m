function draw_enr_longa(ax,joints,jb,r,info,viaduto)
hold(ax,'on')

transicao = 1; % comprimento da transição

for k=1:viaduto.n_apoios-1
    b1 = viaduto.vao(k).longarina.b1;
    b3 = viaduto.vao(k).longarina.b3;
    benr = viaduto.vao(k).longarina.benr;
    for g=1:viaduto.vao(k).n_longarinas
        secao=info.longarinas.vao(k).longarina(g).secao;
        secao_enr=info.longarinas.vao(k).longarina(g).secao_enr;
        secao_enr = [zeros(length(secao_enr),1) secao_enr];
        dif_cg = (min(secao_enr(:,3)) - min(secao(:,3)));
        secao_enr(:,3) = secao_enr(:,3) - dif_cg;
        lb=info.longarinas.vao(k).longarina(1).lb;
        m = info.longarinas.vao(k).longarina(g).membros;

        for i = 1:2
            if i==1
                transicao_i = transicao;
                secao_enr(:,1) = 0;
                enr = viaduto.vao(k).longarina.enr;
            elseif i==2
                transicao_i = - transicao;
                secao_enr(:,1) = lb;
                secao(:,1) = lb;
                enr = -viaduto.vao(k).longarina.enr;
            end
            if or(g == 1,g == viaduto.vao(k).n_longarinas) %nós das faces do enrijecimento
                ni(1) = 4;
                nf(1) = 5;
                ni(2) = 10;
                nf(2) = 11;
                if or(benr>b1,benr>b3)
                    ni(1) = 3;
                    nf(1) = 6;
                    ni(2) = 9;
                    nf(2) = 12;
                end
            else
                ni(1) = 5;
                nf(1) = 6;
                ni(2) = 11;
                nf(2) = 12;
                if or(benr>b1,benr>b3)
                    ni(1) = 4;
                    nf(1) = 7;
                    ni(2) = 10;
                    nf(2) = 13;
                end
            end
            for n = 1:2 % Direita depois esquerda
                % Trecho reto
                secao_b=secao_enr((ni(n):nf(n)),:);
                secao_e=secao_enr((ni(n):nf(n)),:);
                secao_e(:,1)=secao_e(:,1)+lb*enr - transicao_i/2;

                liga_secoes_be(ax, secao_b, secao_e, m, r, joints, jb)

                % Treço de tansição
                secao_b=secao_enr((ni(n):nf(n)),:);
                secao_e=secao((ni(n):nf(n)),:);
                secao_b(:,1)=secao_b(:,1)+lb*enr - transicao_i/2;
                secao_e(:,1)=secao_e(:,1)+lb*enr + transicao_i/2;
                liga_secoes_be(ax, secao_b, secao_e, m, r, joints, jb)

                % Cabeça
                secao_juncao = [secao((ni(n):nf(n)),:);flip(secao_enr((ni(n):nf(n)),:))]*r(:,:,m);
                patch(ax,transpose(secao_juncao(:,1))+joints(jb(m,1),1),...
                    transpose(secao_juncao(:,2))+joints(jb(m,1),2),...
                    transpose(secao_juncao(:,3))+joints(jb(m,1),3),[.5 .5 .5]);
            end
        end
    end
end

hold(ax,'off')
end

function liga_secoes_be(ax,secao_b, secao_e, m, r, joints, jb)
secao_b=secao_b*r(:,:,m);
secao_e=secao_e*r(:,:,m);
[np,~]=size(secao_b);

for f=1:np-1
    x=[secao_b(f,1) secao_b(f+1,1) secao_e(f+1,1) secao_e(f,1)]+joints(jb(m,1),1);
    y=[secao_b(f,2) secao_b(f+1,2) secao_e(f+1,2) secao_e(f,2)]+joints(jb(m,1),2);
    z=[secao_b(f,3) secao_b(f+1,3) secao_e(f+1,3) secao_e(f,3)]+joints(jb(m,1),3);
    patch(ax,x,y,z,[.5 .5 .5]);
end
end
