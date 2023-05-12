function [joints,memb,info] = cria_apoios(viaduto,info_pilares,info_longarinas,info_travessas,info_aparelhos_de_apoio)
%Cria Longarinas
%   Cria os nós e membros das longarinas
% Para otimização necessita prealocar a memória

n=0;
m=0;

A=0.04;
E=calc_Ecs(30E6,viaduto.alfa_e);
G=E/2.4;
Iz=.2^4/12;
Iy=Iz;
J=calc_Jret(.2,.2);
secao(:,:)=[ 0  .1  .1;...
             0 -.1  .1;...
             0 -.1 -.1;...
             0  .1 -.1;...
             0  .1  .1];


for k=1:viaduto.n_apoios-1
    h1=viaduto.vao(k).longarina.h1;
    hlj=viaduto.vao(k).laje.h;
    n_longa=viaduto.vao(k).n_longarinas;

    for g=1:n_longa
        ZCG=info_longarinas.vao(k).longarina(g).ZCG;
        for a=1:2
            switch a
                case 1
                    hap=viaduto.vao(k).hap;
                    khap=info_aparelhos_de_apoio.vao(k).khap*1000;%o "*1000" é para transformar de kN/m para N/m
                    cota_pilar=info_pilares.apoio(k).pilar(1).cota_topo;
                    x=info_longarinas.vao(k).longarina(g).xb;
                    y=info_longarinas.vao(k).longarina(g).yb;
                    z=info_longarinas.vao(k).longarina(g).zb;
                    no_membro1=info_longarinas.vao(k).longarina(g).primeiro_no;
                case 2
                    hap=viaduto.vao(k).hap;
                    khap=info_aparelhos_de_apoio.vao(k).khap*1000;%o "*1000" é para transformar de kN/m para N/m
                    cota_pilar=info_pilares.apoio(k+1).pilar(1).cota_topo;
                    x=info_longarinas.vao(k).longarina(g).xe;
                    y=info_longarinas.vao(k).longarina(g).ye;
                    z=info_longarinas.vao(k).longarina(g).ze;
                    no_membro1=info_longarinas.vao(k).longarina(g).ultimo_no;
            end
            
            %nó 1
            n=n+1;
            x=x-.05;
            y=y;
            z=z-ZCG-hlj-h1-hap/2;
            joints(n).x=x;
            joints(n).y=y;
            joints(n).z=z;
            joints(n).vr=[0 0 0 0 0 0];
            joints(n).vf=[];
            
            %barra 1
            m=m+1;
            memb(m).b=no_membro1;
            memb(m).e=n+info_travessas.UNE;
            memb(m).rb=[];
            memb(m).re=[];
            memb(m).rig=[1];
            memb(m).rig_ex=[];
            memb(m).draw_not=[1];
            memb(m).secao=secao;
            memb(m).A=A;
            memb(m).E=E;
            memb(m).G=G;
            memb(m).Iz=Iz;
            memb(m).Iy=Iy;
            memb(m).J=J;
            
            %nó 2
            n=n+1;
            x=x+.1;
            y=y;
            z=z;
            joints(n).x=x;
            joints(n).y=y;
            joints(n).z=z;
            joints(n).vr=[0 0 0 0 0 0];
            joints(n).vf=[];
            %barra 2
            
            m=m+1;
            memb(m).b=n-1+info_travessas.UNE;
            memb(m).e=n+info_travessas.UNE;
            memb(m).rb=[];
            memb(m).re=[];
            memb(m).rig=[1];
            memb(m).rig_ex=[khap];
            info.vao(k).longarina(g).m_ap(a)=info_travessas.UME+m;
            memb(m).draw_not=[1];
            memb(m).secao=secao;
            memb(m).A=A;
            memb(m).E=E;
            memb(m).G=G;
            memb(m).Iz=Iz;
            memb(m).Iy=Iy;
            memb(m).J=J;
            
            %nó 3
            n=n+1;
            x=x-.05;
            y=y-.05;
            z=z;
            joints(n).x=x;
            joints(n).y=y;
            joints(n).z=z;
            joints(n).vr=[0 0 0 0 0 0];
            joints(n).vf=[];
            
            %barra 3
            m=m+1;
            memb(m).b=n-1+info_travessas.UNE;
            memb(m).e=n+info_travessas.UNE;
            memb(m).rb=[];
            memb(m).re=[];
            memb(m).rig=[1];
            memb(m).rig_ex=[];
            memb(m).draw_not=[1];
            memb(m).secao=secao;
            memb(m).A=A;
            memb(m).E=E;
            memb(m).G=G;
            memb(m).Iz=Iz;
            memb(m).Iy=Iy;
            memb(m).J=J;
            
            %nó 4
            n=n+1;
            x=x;
            y=y+.1;
            z=z;
            joints(n).x=x;
            joints(n).y=y;
            joints(n).z=z;
            joints(n).vr=[0 0 0 0 0 0];
            joints(n).vf=[];
            
            %barra 4
            m=m+1;
            memb(m).b=n-1+info_travessas.UNE;
            memb(m).e=n+info_travessas.UNE;
            memb(m).rb=[];
            memb(m).re=[];
            memb(m).rig=[1];
            memb(m).rig_ex=[khap];
            memb(m).draw_not=[1];
            memb(m).secao=secao;
            memb(m).A=A;
            memb(m).E=E;
            memb(m).G=G;
            memb(m).Iz=Iz;
            memb(m).Iy=Iy;
            memb(m).J=J;

            %barra 5
            m=m+1;
            memb(m).b=n+info_travessas.UNE;
            memb(m).e=info_travessas.vao(k).longarina(g).apoio(a);
            memb(m).rb=[];
            memb(m).re=[];
            memb(m).rig=[1];
            memb(m).rig_ex=[];
            memb(m).draw_not=[1];
            memb(m).secao=secao;
            memb(m).A=A;
            memb(m).E=E;
            memb(m).G=G;
            memb(m).Iz=Iz;
            memb(m).Iy=Iy;
            memb(m).J=J;
            
            
            
        %último nó e barra
        
        if not(or((k==1&a==1),k==viaduto.n_apoios-1&a==2))
            %nó 6
            n=n+1;
            y=y-.05;
            z=cota_pilar;
            joints(n).x=x;
            joints(n).y=y;
            joints(n).z=z;
            joints(n).vr=[0 0 0 0 0 0];
            joints(n).vf=[];

            memb(m).e=n+info_travessas.UNE;
           
            %barra 6
            m=m+1;
            memb(m).b=n+info_travessas.UNE;
            memb(m).e=info_travessas.vao(k).longarina(g).apoio(a);
            memb(m).rb=[];
            memb(m).re=[];
            memb(m).rig=[1];
            memb(m).rig_ex=[];
            memb(m).draw_not=[1];
            memb(m).secao=secao;
            memb(m).A=A;
            memb(m).E=E;
            memb(m).G=G;
            memb(m).Iz=Iz;
            memb(m).Iy=Iy;
            memb(m).J=J;
        end
        
        end
    end
    
end
info.UNE=n+info_travessas.UNE;%último nó estrutura
info.UME=m+info_travessas.UME;%último membro estrutura

% %% Plota nós
% figure(2)
% clf
% hold on
% for i=1:n 
%     plot3(joints(i).x,joints(i).y,joints(i).z,'o','Color','k','MarkerFaceColor','k')
%     text(joints(i).x,joints(i).y,joints(i).z,[' ' num2str(i)],'HorizontalAlignment', 'left','VerticalAlignment', 'top')
% end
% 
% 
% axis  vis3d equal
% hold off

end