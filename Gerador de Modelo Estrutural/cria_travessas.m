function [joints,memb,info] = cria_travessas(viaduto,info_pilares,info_longarinas,info_fustes)
%Cria travessas
%   Cria os nós e membros das travessas
% Para otimização necessita prealocar memória

n=0;
m=0;
no_rep=0;

W=viaduto.W;
nt_pilares=sum([viaduto.apoio(:).n_pilares]);
for i=1:viaduto.n_apoios
    lista=[];
    cont=0;
    dp=viaduto.apoio(i).pilares.d;
    fck=viaduto.apoio(i).travessa.fck;
    bl=viaduto.apoio(i).travessa.bl;
    b=viaduto.apoio(i).travessa.b;
    h=viaduto.apoio(i).travessa.h;
    A=b*h;
    E=calc_Ecs(fck,viaduto.alfa_e);
    G=E/2.4;
    Iy=b*h^3/12;
    Iz=h*b^3/12;
    J=calc_Jret( b,h );
    secao(:,:)=  [ 0  b/2  h/2;...
                   0 -b/2  h/2;...
                   0 -b/2 -h/2;...
                   0  b/2 -h/2;...
                   0  b/2  h/2];
    
    x=info_fustes.apoio(i).fuste(1).x_fundacao;
    %if bl>0   %Removido após concertar o comprimento rigido
        %Cria nós dos balanços
        %Inicio do balanço
        y=-W/2;
        z=info_pilares.apoio(i).pilar(1).cota_topo;
        n=n+1;
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        cont=cont+1;
        lista(1,cont)=n+info_longarinas.UNE;
        lista(2,cont)=y;
        %Final do balanço
        y=W/2;
        n=n+1;
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        cont=cont+1;
        lista(1,cont)=n+info_longarinas.UNE;
        lista(2,cont)=y;
    %end    %Removido após concertar o comprimento rigido
    
    
    
    
    for j=1:viaduto.apoio(i).n_pilares
        %Nó esquerdo do pilar
        n=n+1;
        y=-W/2+bl+dp/2+((j-1)*(W-2*bl-dp)/(viaduto.apoio(i).n_pilares-1));%Coordenada do pilar - Fazer isso direito, pegar coordenada do pilar e não recalcular
        cont=cont+1;
        lista(1,cont)=info_pilares.apoio(i).pilar(j).primeiro_no;
        lista(2,cont)=y;
        
        %0.3 é da NBR 6118:2014 item 16.6.2.1
        y=y-dp/2+.3*dp;%Corrige para coordenada do pilar para nó da travessa
        
        z=info_pilares.apoio(i).pilar(j).cota_topo;
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        cont=cont+1;
        lista(1,cont)=n+info_longarinas.UNE;
        lista(2,cont)=y;
        lista(3,cont)=1;
        %Nó direito do pilar
        n=n+1;
        
        y=y+.4*dp;%0.4 é (1-2*.3) da NBR 6118:2014 item 16.6.2.1
        
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        cont=cont+1;
        lista(1,cont)=n+info_longarinas.UNE;
        lista(2,cont)=y;
        lista(3,cont)=-1;
        
    end
    
    
    for a=1:-1:0
        switch i-a
            case 0
            case viaduto.n_apoios
            otherwise
                n_longa=viaduto.vao(i-a).n_longarinas;
                for g=1:n_longa
                    switch a
                        case 1
                            y=info_longarinas.vao(i-a).longarina(g).yb;
                        case 0
                            y=info_longarinas.vao(i-a).longarina(g).ye;
                    end
                    %CHECAR ANTES DE CRIAR O NÓ, SE O NÓ JA EXISTE
                    limite_barra_minima = .05; % limite de comprimento de barra
                    yigual=find(and(lista(2,:) > y - limite_barra_minima, lista(2,:) < y + limite_barra_minima)); % Checa se existe algum nó que criaria uma barra muito curta
                    if isempty(yigual) %SE NÃO EXISTE CRIA
                        n=n+1;
                        joints(n).x=x;
                        joints(n).y=y;
                        joints(n).z=z;
                        joints(n).vr=[0 0 0 0 0 0];
                        joints(n).vf=[];
                        cont=cont+1;
                        lista(1,cont)=n+info_longarinas.UNE;
                        lista(2,cont)=y;
                        info.vao(i-a).longarina(g).apoio(1+a)=n+info_longarinas.UNE;%ANOTA
                    else %SE JA EXISTE
                        [~, indice_mais_proximo] = min(abs(lista(2, yigual) - y)); % Indice do nó mais proximo
                        no_rep=no_rep+1;
                        info.vao(i-a).longarina(g).apoio(1+a)=lista(1,yigual(indice_mais_proximo));%ANOTA
                        info.no_rep=no_rep;
                    end

                end
        end
        
    end
    lista=transpose(sortrows(transpose(lista),2));
    [~,mt]=size(lista);
    barrarig=0;
    for mt=1:mt-1
        barrarig=barrarig+lista(3,mt);
        m=m+1;
        memb(m).b=lista(1,mt);
        memb(m).e=lista(1,mt+1);
        memb(m).rb=[];
        memb(m).re=[];
        if barrarig==0
            memb(m).rig=[];
            memb(m).rig_ex=[];
            memb(m).draw_not=[];
            memb(m).secao=[];
        else
            memb(m).rig=[1];
            memb(m).rig_ex=[];
            memb(m).draw_not=[];
            memb(m).secao=[];
        end
        memb(m).secao=secao;
        memb(m).A=A;
        memb(m).E=E;
        memb(m).G=G;
        memb(m).Iz=Iz;
        memb(m).Iy=Iy;
        memb(m).J=J;
        info.apoio(i).membros(mt)=m+info_longarinas.UME;
    end
end

% figure(1)
% clf
% hold on
% for i=1:n 
%     plot3(joints(i).x,joints(i).y,joints(i).z,'o','Color','k','MarkerFaceColor','k')
%     text(joints(i).x,joints(i).y,joints(i).z,[' ' num2str(i+info_longarinas.UNE)],'HorizontalAlignment', 'left','VerticalAlignment', 'top')
% end
% hold off

info.UNE=n+info_longarinas.UNE;%ultimo nó estrutura
info.UME=m+info_longarinas.UME;%ultimo membro estrutura

end

