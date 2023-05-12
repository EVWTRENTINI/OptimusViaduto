function [joints,memb,info] = cria_fustes(viaduto,rigidez_solo,sondagem)
%Cria fuste
%   Cria os nós e membros do fuste
%Para otimização necessita prealocar a memória

n=0;
m=0;

l_max_fuste=viaduto.l_max_fuste;
for i=1:viaduto.n_apoios
    W=viaduto.W;
    l=viaduto.apoio(i).cota_topo_bloco-viaduto.apoio(i).cota_fundacao;
    df=viaduto.apoio(i).fustes.d;
    dp=viaduto.apoio(i).pilares.d;
    fck=viaduto.apoio(i).fustes.fck;
    bl=viaduto.apoio(i).travessa.bl;
    A=df^2*pi()/4;
    E=calc_Ecs(fck,viaduto.alfa_e);
    G=E/2.4;
    Iz=pi()/4*((df/2)^4);
    Iy=Iz;
    J=Iy*2;
    passo=10;
    [Y,Z]=circulo(df/2,passo);
    secao=[zeros(passo+1,1) transpose(Y) transpose(Z)];
    switch i
        case 1
            x=viaduto.x_apoio(i);
        otherwise
            x=x+viaduto.vao(i-1).l;
    end
    for j=1:viaduto.apoio(i).n_pilares
        y=-W/2+bl+dp/2+((j-1)*(W-2*bl-dp)/(viaduto.apoio(i).n_pilares-1));
        
        
        %% Numero de pontos
        n_barras=ceil(l/l_max_fuste);
        l_barra=l/n_barras;
        
        %% Criação dos nós
        for k=1:n_barras+1
            z=viaduto.apoio(i).cota_topo_bloco-(k-1)*l_barra;
            if k == 1
                info.apoio(i).fuste(j).cota_primeiro_no = z;
            end
            
            n=n+1;
            
            joints(n).x=x;
            joints(n).y=y;
            joints(n).z=z;
            joints(n).vr=[0 0 0 0 0 0];
            if k==1
                info.apoio(i).fuste(j).primeiro_no=n;
            end
            if k==n_barras+1
            	joints(n).vr=[0 0 1 0 0 0];
                info.apoio(i).fuste(j).ultimo_no=n;
                info.apoio(i).fuste(j).x_fundacao=x;
                info.apoio(i).fuste(j).y_fundacao=y;
                info.apoio(i).fuste(j).z_fundacao=z;
            end
            
            
            %% Rigidez do solo
            nivel_terreno=interp1([sondagem.x],[sondagem.nivel_terreno],viaduto.x_apoio(i));
            z_sup=z+l_barra/2;
            z_inf=z-l_barra/2;
            if k==1
                z_sup=nivel_terreno;
            end
            if k==n_barras+1
                z_inf=z;
            end
            z_tot=z_sup-z_inf;
            K_mola=valor_medio_em_z(rigidez_solo.F,x,z_sup,z_inf,10)*z_tot;%NÃO MULTIPLICA PELO DIAMETRO DO FUSTE!
            
            joints(n).vf=[K_mola K_mola 0 0 0 0];
            
            %% Criação da barra
            if k>=2
                m=m+1;
                memb(m).b=n-1;
                memb(m).e=n;
                memb(m).rb=[];
                memb(m).re=[];
                memb(m).rig=[];
                memb(m).rig_ex=[];
                memb(m).draw_not=[];
                memb(m).secao=secao;
                memb(m).A=A;
                memb(m).E=E;
                memb(m).G=G;
                memb(m).Iz=Iz;
                memb(m).Iy=Iy;
                memb(m).J=J;
                info.apoio(i).fuste(j).membros(k-1)=m;
                
            end
        end
    end
end
info.UNE=n;%último nó estrutura
info.UME=m;%último membro estrutura

% %% Plota nós
% figure(1)
% clf
% hold on
% for i=1:n 
%     plot3(joints(i).x,joints(i).y,joints(i).z,'o','Color','k','MarkerFaceColor','k')
%     text(joints(i).x,joints(i).y,joints(i).z,[' ' num2str(i)],'HorizontalAlignment', 'left','VerticalAlignment', 'top')
% end
% for i=1:m
% 	plot3([joints(memb(i).b).x joints(memb(i).e).x],...          %[X1 X2]
%           [joints(memb(i).b).y joints(memb(i).e).y],...          %[Y1 Y2]
%           [joints(memb(i).b).z joints(memb(i).e).z],'color','b');%[Z1 Z2]
% %     text((joints(memb(i).b).x+joints(memb(i).e).x)/2,...
% %          (joints(memb(i).b).y+joints(memb(i).e).y)/2,...
% %          (joints(memb(i).b).z+joints(memb(i).e).z)/2,...
% %           [' ' num2str(i)],'HorizontalAlignment', 'left','color','b')
% end
% 
% axis  vis3d equal
% hold off
% 

end

