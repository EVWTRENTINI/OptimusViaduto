function [joints,memb,info,situacao,msg_erro] = cria_pilares(viaduto,terreno,info_fustes)
%Cria pilares
%   Cria os nós e membros dos pilares
% Para otimização necessita prealocar a memória
lb_pilar_min = 0.05; % Comprimento mínimo da barra do pilar

situacao=true;
msg_erro='sem erro';
joints = struct();
memb = struct();
info = struct();
n=0;
m=0;

W=viaduto.W;
for i=1:viaduto.n_apoios
    
    dp=viaduto.apoio(i).pilares.d;
    fck=viaduto.apoio(i).fustes.fck;
    bl=viaduto.apoio(i).travessa.bl;
    greide=viaduto.apoio(i).cota_greide;
    hpav=viaduto.hpav;
    ht=viaduto.apoio(i).travessa.h;
    A=dp^2*pi()/4;
    E=calc_Ecs(fck,viaduto.alfa_e);
    G=E/2.4;
    Iz=pi()/4*((dp/2)^4);
    Iy=Iz;
    J=Iy*2;
    passo=10;
    [Y,Z]=circulo(dp/2,passo);
    secao=[zeros(passo+1,1) transpose(Y) transpose(Z)];
    switch i %algura da longarina+laje+aprelho de apoio
        case 1
            hlgljap=...
                viaduto.vao(i).laje.h+...
                viaduto.vao(i).longarina.h1+...
                viaduto.vao(i).hap;
        case viaduto.n_apoios
            hlgljap=...
                viaduto.vao(i-1).laje.h+...
                viaduto.vao(i-1).longarina.h1+...
                viaduto.vao(i-1).hap;
        otherwise
            hlgljap=max([viaduto.vao(i).laje.h+viaduto.vao(i).longarina.h1+viaduto.vao(i).hap viaduto.vao(i-1).laje.h+viaduto.vao(i-1).longarina.h1+viaduto.vao(i-1).hap]);
    end
    

    x=info_fustes.apoio(i).fuste(1).x_fundacao;

    for j=1:viaduto.apoio(i).n_pilares
        y=-W/2+bl+dp/2+((j-1)*(W-2*bl-dp)/(viaduto.apoio(i).n_pilares-1));
        %nó 1
        n=n+1;
        z=greide-hpav-hlgljap-ht/2;
        
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        info.apoio(i).pilar(j).primeiro_no=n+info_fustes.UNE;
        info.apoio(i).pilar(j).cota_topo=z;
        %nó 2
        n=n+1;
        z=greide-hpav-hlgljap-ht+.3*ht;%0.3 é da NBR 6118:2014 item 16.6.2.1
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];

        %barra 1
        m=m+1;
        memb(m).b=n-1+info_fustes.UNE;
        memb(m).e=n+info_fustes.UNE;
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
        info.apoio(i).pilar(j).membros(1)=m+info_fustes.UME;
        
        %nó 3 impacto
        n=n+1;
        z=viaduto.apoio(i).cota_topo_bloco+1.25+viaduto.h_bloco_enterrado+interp1([terreno.x],[terreno.delta_z_impacto],x);%NBR:7188 - altura colisão
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        info.apoio(i).pilar(j).no_impacto=n+info_fustes.UNE;
        % Confere tamanho da barra 
        lb_pilar = min(abs(([(joints(n-1).z - joints(n).z) (joints(n).z - info_fustes.apoio(i).fuste(j).cota_primeiro_no)])));
        if lb_pilar < lb_pilar_min
            situacao = false;
            msg_erro = ['Barra do pilar muito curta no apoio ' num2str(i) '.'];
        end
        % Confere se o nó no impacto não esta mais alto que o segundo nó do pilar
        if joints(n).z > joints(n-1).z
            situacao = false;
            msg_erro = ['Nó do impacto esta mais alto que o pilar no apoio ' num2str(i) '.'];
        end
        % Confere se o nó no impacto não esta mais baixo que o ultimo nó do pilar
        if joints(n).z < info_fustes.apoio(i).fuste(j).cota_primeiro_no
            situacao = false;
            msg_erro = ['Nó do impacto esta mais baixo que o pilar no apoio ' num2str(i) '.'];
        end
        %barra 2
        m=m+1;
        memb(m).b=n-1+info_fustes.UNE;
        memb(m).e=n+info_fustes.UNE;
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
        info.apoio(i).pilar(j).membros(2)=m+info_fustes.UME;
        %barra 3
        m=m+1;
        memb(m).b=n+info_fustes.UNE;
        memb(m).e=info_fustes.apoio(i).fuste(j).primeiro_no;
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
        info.apoio(i).pilar(j).membros(3)=m+info_fustes.UME;
    end
end

info.UNE=n+info_fustes.UNE;%ultimo nó estrutura
info.UME=m+info_fustes.UME;%ultimo membro estrutura

end

