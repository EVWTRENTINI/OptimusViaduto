function [joints,memb,info] = cria_longarinas(viaduto,info_pilares,info_fustes)
%Cria Longarinas
%   Cria os nós e membros das longarinas
% Para otimização necessita prealocar a memória

folga=viaduto.folga;%m folga total

n=0;
m=0;

W=viaduto.W;
l_ac=info_fustes.apoio(1).fuste(1).x_fundacao;%l acumulado
hpav=viaduto.hpav;
for k=1:viaduto.n_apoios-1
    b1=viaduto.vao(k).longarina.b1;
    b2=viaduto.vao(k).longarina.b2;
    b3=viaduto.vao(k).longarina.b3;
    benr=viaduto.vao(k).longarina.benr;
    h1=viaduto.vao(k).longarina.h1;
    h2=viaduto.vao(k).longarina.h2;
    h3=viaduto.vao(k).longarina.h3;
    h4=viaduto.vao(k).longarina.h4;
    h5=viaduto.vao(k).longarina.h5;
    hlj=viaduto.vao(k).laje.h;
    fck=viaduto.vao(k).longarina.fck;
    n_longa=viaduto.vao(k).n_longarinas;
    
    %bmax = max([b1 b2 b3 benr]);
    bmax = b1;
    c_bf=min([h2+h3 b1/2-b2/2]); % menor entre 45 graus ou o proprio b1/2-b2/2 - item 14.6.2.2 da 6118:2014
    
    
    %equação pra y
    zapb=viaduto.apoio(k).cota_greide-hpav;
    zape=viaduto.apoio(k+1).cota_greide-hpav;
    l=viaduto.vao(k).l;
    switch k
        case 1
            folgab=0;
            folgae=-folga/2;
            if viaduto.n_apoios==2
                folgae=0;
            end
        case viaduto.n_apoios-1
            folgab=folga/2;
            folgae=0;
        otherwise
            folgab=folga/2;
            folgae=-folga/2;   
    end
    
    
    for g=1:n_longa
        % item 14.6.2.2 da 6118:2014
        bf_por_2_maximo=(((W-b1))/(n_longa-1))/2;
        if bf_por_2_maximo-b2/2-c_bf>.1*l
            bf_por_2=.1*l+c_bf+b2/2;
        else
            bf_por_2=bf_por_2_maximo;
        end
        info.vao(k).longarina(g).fresta_ate_meio=bf_por_2_maximo-bf_por_2;
        info.vao(k).longarina(g).bf_por_2=bf_por_2;

        switch g
            case 1
                info.vao(k).longarina(g).laje_sup=bf_por_2_maximo-bf_por_2;
            case n_longa
                info.vao(k).longarina(g).laje_sup=bf_por_2_maximo-bf_por_2;
            otherwise
                info.vao(k).longarina(g).laje_sup=(bf_por_2_maximo-bf_por_2)*2;
        end
        switch g
            
            %NUNCA TROCAR A ORDEM DOS PONTOS, MUITAS FUNÇÕES DEPENDEM DISSO
            case 1   %1     2     3         4           5           6          7         8        9            10         11       12      13             14                      15                16
                Y=[-b1/2 -b1/2  -b1/2     -b2/2      -b2/2       -b3/2      -b3/2      b3/2      b3/2         b2/2       b2/2      b1/2   b1/2          bf_por_2                bf_por_2          -b1/2];
                Z=[  0    -hlj -hlj-h2 -hlj-h2-h3 -h1-hlj+h5+h4 -h1-hlj+h5  -h1-hlj  -h1-hlj  -h1-hlj+h5 -h1-hlj+h5+h4 -hlj-h2-h3 -hlj-h2 -hlj           -hlj                      0                0  ];
                [~,ZCG]=centroide(Y,Z);
                Z=Z-ZCG;
                
                Yenr=Y;
                Zenr=Z;
                Yenr(4)=-benr/2;
                Yenr(5)=-benr/2;
                Yenr(10)=benr/2;
                Yenr(11)=benr/2;
                if (Y(10)-Y(9)) == 0
                    Zenr(10) = Zenr(9);
                else
                    Zenr(10)=Zenr(9)+((Z(10)-Z(9))/(Y(10)-Y(9)))*(Yenr(10)-Y(9));
                end
                Zenr(5) =Zenr(10);
                if (Y(12)-Y(11)) == 0
                    Zenr(11) = Z(11);
                else
                    Zenr(11)=Z(11)+(Z(12)-Z(11))/(Y(12)-Y(11))*(Yenr(11)-Y(11));
                end
                Zenr(4)=Zenr(11);
                if benr>b3
                    Zenr(10)=Z(10);
                    Zenr(5)=Z(10);
                end
                if benr>b1
                    Zenr(11)=Z(11);
                    Zenr(4)=Z(11);
                end
                
            case n_longa
                Y=[b1/2   b1/2   b1/2     b2/2         b2/2        b3/2       b3/2    -b3/2      -b3/2       -b2/2       -b2/2      -b1/2  -b1/2        -bf_por_2              -bf_por_2             b1/2];
                Z=[  0    -hlj -hlj-h2 -hlj-h2-h3 -h1-hlj+h5+h4 -h1-hlj+h5  -h1-hlj  -h1-hlj  -h1-hlj+h5 -h1-hlj+h5+h4 -hlj-h2-h3 -hlj-h2   -hlj           -hlj                      0                0  ];
                [~,ZCG]=centroide(Y,Z);
                Z=Z-ZCG;
                
                Yenr=Y;
                Zenr=Z;
                Yenr(4)=  benr/2;
                Yenr(5)=  benr/2;
                Yenr(10)=-benr/2;
                Yenr(11)=-benr/2;
                if (Y(10)-Y(9)) == 0
                     Zenr(10)=Zenr(9);
                else
                    Zenr(10)=Zenr(9)+((Z(10)-Z(9))/(Y(10)-Y(9)))*(Yenr(10)-Y(9));
                end
                Zenr(5) =Zenr(10);
                if (Y(12)-Y(11)) == 0
                    Zenr(11)=Z(11);
                else
                    Zenr(11)=Z(11)+(Z(12)-Z(11))/(Y(12)-Y(11))*(Yenr(11)-Y(11));
                end
                Zenr(4)=Zenr(11);
                if benr>b3
                    Zenr(10)=Z(10);
                    Zenr(5)=Z(10);
                end
                if benr>b1
                    Zenr(11)=Z(11);
                    Zenr(4)=Z(11);
                end
                
            otherwise
                Y=[-bf_por_2 -bf_por_2 -b1/2  -b1/2    -b2/2        -b2/2       -b3/2      -b3/2     b3/2      b3/2       b2/2          b2/2     b1/2    b1/2   bf_por_2 bf_por_2 -bf_por_2];
                Z=[0           -hlj     -hlj -hlj-h2 -hlj-h2-h3 -h1-hlj+h5+h4 -h1-hlj+h5  -h1-hlj  -h1-hlj  -h1-hlj+h5 -h1-hlj+h5+h4 -hlj-h2-h3 -hlj-h2 -hlj     -hlj       0           0  ];
                [~,ZCG]=centroide(Y,Z);
                Z=Z-ZCG;

                Yenr=Y;
                Zenr=Z;
                Yenr(5)=-benr/2;
                Yenr(6)=-benr/2;
                Yenr(11)=benr/2;
                Yenr(12)=benr/2;
                if (Y(11)-Y(10)) == 0
                    Zenr(11)=Zenr(10);
                else
                    Zenr(11)=Zenr(10)+((Z(11)-Z(10))/(Y(11)-Y(10)))*(Yenr(11)-Y(10));
                end
                Zenr(6) =Zenr(11);
                if (Y(13)-Y(12)) == 0
                    Zenr(12)=Z(12);
                else
                    Zenr(12)=Z(12)+(Z(13)-Z(12))/(Y(13)-Y(12))*(Yenr(12)-Y(12));
                end
                Zenr(5)=Zenr(12);
                if benr>b3
                    Zenr(11)=Z(11);
                    Zenr(6)=Z(11);
                end
                if benr>b1
                    Zenr(12)=Z(12);
                    Zenr(5)=Z(12);
                end
                
        end
        info.vao(k).longarina(g).ZCG=ZCG;
%  [ GEOM, INER, CPMO ] = POLYGEOM( X, Y ) returns
%   area, centroid, perimeter and area moments of 
%   inertia for the polygon.
%   GEOM = [ area   X_cen  Y_cen  perimeter ]
%   INER = [ Ixx    Iyy    Ixy    Iuu    Ivv    Iuv ]
%     u,v are centroidal axes parallel to x,y axes.
%   CPMO = [ I1     ang1   I2     ang2   J ]
%     I1,I2 are centroidal principal moments about axes
%         at angles ang1,ang2.
%     ang1 and ang2 are in radians.
%     J is centroidal polar moment.  J = I1 + I2 = Iuu + Ivv
        [ geom, iner, ~ ] = polygeom(Y,Z) ;
        A=geom(1);
        info.vao(k).longarina(g).A=A;
        info.vao(k).longarina(g).u=geom(4);
        E=calc_Ecs(fck,viaduto.alfa_e);
        G=E/2.4;
        Iy=iner(1);
        Iz=iner(2);
        J=((abs(Y(15)-Y(1)))*(hlj)^3+(h1+hlj/2)*(b2)^3)/3;
        
        [~,ZCGenr]=centroide(Yenr,Zenr);
        Zenr=Zenr-ZCGenr;
        [ geomenr, inerenr, ~ ] = polygeom(Yenr,Zenr);
        info.vao(k).longarina(g).Aenr=geomenr(1);
        info.vao(k).longarina(g).uenr=geomenr(4);
        info.vao(k).longarina(g).Ienr=inerenr(1);
        info.vao(k).longarina(g).secao_enr=[transpose(Yenr) transpose(Zenr)];
        
        %nó inicial
        n=n+1;
        x=l_ac+folgab;
        y=-W/2+bmax/2+(g-1)*((W-bmax))/(n_longa-1);
        z=zapb+(x-l_ac)*(zape-zapb)/l+ZCG;
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        info.vao(k).longarina(g).primeiro_no=n+info_pilares.UNE;
        info.vao(k).longarina(g).xb=x;
        info.vao(k).longarina(g).yb=y;
        info.vao(k).longarina(g).zb=z;

%        %nó intermediario
%        n=n+1;
%        x=l_ac+(l+folgab+folgae)/2;
%        y=-W/2+b1/2+(g-1)*((W-b1))/(n_longa-1);
%        z=zapb+(x-l_ac)*(zape-zapb)/l;
%        joints(n).x=x;
%        joints(n).y=y;
%        joints(n).z=z;
%        joints(n).vr=[0 0 0 0 0 0];
%        joints(n).vf=[];
%        info.vao(k).longarina(g).centro_no=n+info_pilares.UNE;
%        %barra 1
%        m=m+1;
%        memb(m).b=n-1+info_pilares.UNE;
%        memb(m).e=n+info_pilares.UNE;
%        memb(m).rb=[1];
%        memb(m).re=[0];
%        memb(m).rig=[];
%        memb(m).rig_ex=[];
%        memb(m).draw_not=[];

        %nó final
        n=n+1;
        x=l_ac+l+folgae;
        y=-W/2+bmax/2+(g-1)*((W-bmax))/(n_longa-1);
        z=zapb+(x-l_ac)*(zape-zapb)/l+ZCG;
        joints(n).x=x;
        joints(n).y=y;
        joints(n).z=z;
        joints(n).vr=[0 0 0 0 0 0];
        joints(n).vf=[];
        info.vao(k).longarina(g).ultimo_no=n+info_pilares.UNE;
        info.vao(k).longarina(g).xe=x;
        info.vao(k).longarina(g).ye=y;
        info.vao(k).longarina(g).ze=z;
        %barra 2
        m=m+1;
        memb(m).b=n-1+info_pilares.UNE;
        memb(m).e=n+info_pilares.UNE;
        memb(m).rb=[1];
        memb(m).re=[1];
        memb(m).rig=[];
        memb(m).rig_ex=[];
        memb(m).draw_not=[];
        info.vao(k).longarina(g).membros=m+info_pilares.UME;
        switch g
            case 1   
                memb(m).secao=[zeros(16,1) transpose(Y) transpose(Z)];        
            case n_longa
                memb(m).secao=[zeros(16,1) transpose(Y) transpose(Z)]; 
            otherwise
                memb(m).secao=[zeros(17,1) transpose(Y) transpose(Z)]; 
        end
        info.vao(k).longarina(g).secao=memb(m).secao;
        memb(m).A=A;
        memb(m).E=E;
        memb(m).G=G;
        memb(m).Iz=Iz;
        memb(m).Iy=Iy;
        memb(m).J=J;
        info.vao(k).longarina(g).Iy=Iy;
        info.vao(k).longarina(g).J=J;
    end
    l_ac=l_ac+l;
end
info.UNE=n+info_pilares.UNE;%ultimo nó estrutura
info.UME=m+info_pilares.UME;%ultimo membro estrutura
end