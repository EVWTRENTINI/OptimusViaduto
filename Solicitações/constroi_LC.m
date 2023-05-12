function [LC,info,situacao,msg_erro] = constroi_LC(MA,r,viaduto,impedido,info,config_draw)
%Cria os casos de carregamento CC ou Load Cases LC.   

%% Monta o processo de fauchar pra todos os tabuleiros
for i=1:viaduto.n_apoios-1
[fauchart(i).Kf,fauchart(i).invKfu,fauchart(i).Lf,fauchart(i).Lfacum] = ...
constroi_fauchart(viaduto,info,i);
end


cont=0;

%% Peso Próprio

%Parametros do guarda roda
GR.PP=-.2027*25E3;%n/m - Área*25kN/m³
GR.CG=.1344;%m         - Da face externa reta até centróide
GR.B=.4;%m             - Largura da base do guarda rodas
GR.H=.85;%m            - Altura do guarda rodas

info.LC.PP_ini=cont+1;%anota numero do primeiro

cont=cont+1;
LC(cont).jl=zeros(MA.n.joints*6,1);
LC(cont).cc=[];
LC(cont).cd=PP2cd(MA,r,viaduto,info,fauchart,GR);
LC(cont).ct=[];

info.LC.PP_fim=cont;%anota numero do ultimo

%% Multidão

info.LC.MULT_ini=cont+1;%anota numero do primeiro

%Parametros da discretização
Mny=viaduto.Mny;%numero de faixas de carregamento de multidão
info.Mny=Mny;
dy=(viaduto.W-2*GR.B)/Mny;%tamanho da divisão


%%%%%%%%%%%%%Mesmas faixas carregadas em todos os tabuleiros%%%%%%%%%%%%%%
% % % CONTAR O NUMERO DE CASOS DE CARREGAMENTO
% % nmulti=0;
% % for k=1:viaduto.n_apoios-1
% %     disc_cor_tor=viaduto.vao(k).disc_cor_tor;
% %     [~,ndx]=size(disc_cor_tor);%numero de divisões em x
% %     ntx=ndx-1;%numero de trechos em x
% %     for i=1:Mny
% %         for itx=1:ntx
% %             nmulti=nmulti+1;
% %         end
% %     end
% % end

for i=1:Mny
    MT.b=(-viaduto.W/2+GR.B)+dy*(i-1);
    MT.e=MT.b+dy;
    for k=1:viaduto.n_apoios-1
        disc_cor_tor=viaduto.vao(k).disc_cor_tor;
        [~,ndx]=size(disc_cor_tor);%numero de divisões em x
        ntx=ndx-1;%numero de trechos em x
        
        MT.tabuleiro=k;
        Vlong=info.longarinas.vao(MT.tabuleiro).longarina(1).xe-info.longarinas.vao(MT.tabuleiro).longarina(1).xb;
        CIV=calc_CIV(Vlong);
        MT.m=-5000*CIV;
        
        for itx=1:ntx
            cont=cont+1;
            LC(cont).jl=zeros(MA.n.joints*6,1);
            LC(cont).cc=[];
            LC(cont).cd=[];
            LC(cont).ct=[];

            MT.inix=disc_cor_tor(itx);
            MT.fimx=disc_cor_tor(itx+1);

            if (i==1&&k==1&&itx==1)
                LC(cont).cd=MT2cd(MT,ntx,fauchart,r,viaduto,info);
            else
                LC(cont).cd=[LC(cont).cd;MT2cd(MT,ntx,fauchart,r,viaduto,info)];
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


info.LC.MULT_fim=cont;%anota numero do ultimo

%% Veículo tipo

info.LC.VEIC_ini=cont+1;%anota numero do primeiro

% Parametros do veiculo tipo
v.p=-60E3;%N -Carga por roda - CIV é calculado em "cc_tabuleiro.m"
v.l=6;%m     -Comprimento do VT
v.w=3;%m     -Largura do VT
v.c=.25;%m   -Distancia transversal da borda até centro da roda
v.el=1.5;%m  -Distancia entre eixos longitudinal
v.ew=2;%m    -Distancia

% Parametros da discretização
Vnx=viaduto.Vnx;%numero de intervalos entre divisões em x
info.Vnx=Vnx;
Vny=viaduto.Vny;%numero de intervalos entre divisões em y
info.Vny=Vny;
wu=(viaduto.W-2*(GR.B+v.c+v.ew/2));%largura util de centro de VT
dy=wu/Vny;%tamanho da divisão

% Sobre tabuleiros
for k=1:viaduto.n_apoios-1
    Vlong=info.longarinas.vao(k).longarina(1).xe-info.longarinas.vao(k).longarina(1).xb;
    VT.p=v.p; %- CIV é calculado em "cc_tabuleiro.m"
    lu=Vlong-v.el*2;
    dx=lu/Vnx;
    for j=1:Vnx+1
        limitevao.b=info.longarinas.vao(k).longarina(1).xb;
        VT.X=limitevao.b+v.el+dx*(j-1);
        for i=1:Vny+1
            VT.Y=(-viaduto.W/2+GR.B+v.c+v.ew/2)+dy*(i-1);
            cont=cont+1;
            LC(cont).jl=zeros(MA.n.joints*6,1);
            LC(cont).cc=VT2cc(VT,fauchart,r,viaduto,info);
            LC(cont).cd=[];
            LC(cont).ct=[];
        end
    end
    
    %Veiculo tipo sobre discretizacao de cortante e torção
    disc_cor_tor=viaduto.vao(k).disc_cor_tor;
    [~,ndx]=size(disc_cor_tor);%numero de divisões em x
    for idx=2:ndx-1
        for j=1:2
            switch j
                case 1
                    VT.X=limitevao.b+(Vlong*(disc_cor_tor(idx))+v.el);
                case 2
                    VT.X=limitevao.b+(Vlong*(disc_cor_tor(idx))-v.el);
            end
            
            for i=1:Vny+1
                VT.Y=(-viaduto.W/2+GR.B+v.c+v.ew/2)+dy*(i-1);
                cont=cont+1;
                LC(cont).jl=zeros(MA.n.joints*6,1);
                LC(cont).cc=VT2cc(VT,fauchart,r,viaduto,info);
                LC(cont).cd=[];
                LC(cont).ct=[];
            end
        end
    end
end



% Sobre apoios
for k=1:viaduto.n_apoios
    switch k
        case 1
            VT.X=0;
        case viaduto.n_apoios
            VT.X=VT.X+viaduto.vao(k-1).l;
        otherwise
            VT.X=VT.X+viaduto.vao(k-1).l;
    end
    
    for i=1:Vny+1
        VT.Y=(-viaduto.W/2+GR.B+v.c+v.ew/2)+dy*(i-1);
        cont=cont+1;
        LC(cont).jl=zeros(MA.n.joints*6,1);
        LC(cont).cc=VT2cc(VT,fauchart,r,viaduto,info);
        LC(cont).cd=[];
        LC(cont).ct=[];
    end
end
info.LC.VEIC_fim=cont;%anota numero do ultimo

%% Frenagem

info.LC.FREN_ini=cont+1;%anota numero do primeiro
%Frenagem simultanea em todos os tabuleiros


cont=cont+1;
LC(cont).jl=zeros(MA.n.joints*6,1);
LC(cont).cc=[];
LC(cont).cd=[];
LC(cont).ct=[];

for k=1:viaduto.n_apoios-1
    L=viaduto.vao(k).l;
    B=viaduto.W;
    Ff=0.25E3*L*B;%força de frenagem
    LC(cont).jl = Ff2jl(Ff,k,LC(cont).jl,r,viaduto,info);
end


%Frenagem do veículo tipo sobre cada um dos apoios
% for i=1:viaduto.n_apoios
%     Ff=135E3;%força de frenagem
%     cont=cont+1;
%     LC(cont).jl=zeros(MA.n.joints*6,1);
%     LC(cont).cc=[];
%     LC(cont).cd=[];
%     LC(cont).ct=[];
%     switch i
%         case 1                  %primeiro apoio
%             k=1;
%             LC(cont).jl = Ff2jl(Ff,k,LC(cont).jl,r,viaduto,info);
%         case viaduto.n_apoios   %ultimo apoio
%             k=viaduto.n_apoios-1;
%             LC(cont).jl = Ff2jl(Ff,k,LC(cont).jl,r,viaduto,info);
%         otherwise               %apoios intermediarios
%             for k=i-1:i
%                 LC(cont).jl = Ff2jl(Ff/2,k,LC(cont).jl,r,viaduto,info);
%             end
%     end
%     
% end



info.LC.FREN_fim=cont;%anota numero do ultimo

%% Retração, fluência e temperatura

info.LC.RFT_ini=cont+1;%anota numero do primeiro

cont=cont+1;
LC(cont).jl=zeros(MA.n.joints*6,1);
LC(cont).cc=[];
LC(cont).cd=[];
LC(cont).ct=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:viaduto.n_apoios-1
    n_longa=viaduto.vao(k).n_longarinas;
    for g=1:ceil(viaduto.vao(k).n_longarinas/2)
        [info,situacao,msg_erro]=cria_cabos_e_var_T(k,g,LC(info.LC.PP_ini).cd,viaduto,info,config_draw);
        if not(situacao); return; end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LC(cont).ct=RFT2ct(viaduto,info);

info.LC.RFT_fim=cont;%anota numero do ultimo

%% Vento

info.LC.V90_ini=cont+1;%anota numero do primeiro

for tab=[0 1]
    cont=cont+1;
    
    LC(cont).jl=zeros(MA.n.joints*6,1);
    LC(cont).cc=[];
    LC(cont).cd=[];
    LC(cont).ct=[];
    
  %Vento no tabuleiro
    for k=1:viaduto.n_apoios-1
        hpav=viaduto.hpav;
        hlg=viaduto.vao(k).longarina.h1;
        hlj=viaduto.vao(k).laje.h;
        
        switch tab
            case 0 %tabuleiro carregado
                p=viaduto.V90_tabuleiro_carregado*1000;%N/m²
                H=hlg+hlj+hpav+2;
            case 1 %tabuleiro descarregado
                p=viaduto.V90_tabuleiro_descarregado*1000;%N/m²
                H=hlg+hlj+GR.H;
        end
        h=H/2-(hlg+hlj+hpav);
        L=viaduto.vao(k).l;
        Fv=p*L*H;%força do vento no tabuleiro
        LC(cont).jl = V902jl(Fv,h,k,LC(cont).jl,viaduto,info);
    end
    
    %Vento nos pilares
    n_pilar=sum([viaduto.apoio(:).n_pilares]);
    LC(cont).cd=zeros(n_pilar*2,5);
    cdcont=0;
    for i=1:viaduto.n_apoios
        d=viaduto.apoio(i).pilares.d;
        for j=1:viaduto.apoio(i).n_pilares
            m=info.pilares.apoio(i).pilar(j).membros(2:3);
            for m=m
                cdcont=cdcont+1;
                LC(cont).cd(cdcont,:)=[m 2 0 1 d*p];
            end
        end
    end
end
  info.LC.V90_fim=cont;%anota numero do ultimo
  
%% Colisão em pilares

info.LC.CEP_ini=cont+1;%anota numero do primeiro
C00=1000E3;%NBR 7188
C90=500E3; %NBR 7188
for i=1:viaduto.n_apoios
    n_impementos = length(impedido);
    DPPs = zeros(n_impementos, 2);
    for iimp=1:n_impementos
        if impedido(iimp).pista
            DPPs(iimp, :) = [abs(impedido(iimp).xi - info.fustes.apoio(i).fuste(1).x_fundacao) abs(impedido(iimp).xf - info.fustes.apoio(i).fuste(1).x_fundacao)]; % assume que toda fundacao paralela a y
        else
            DPPs(iimp, :) = [100 100]; % Numero mto alto para zerar a força
        end
    end
    DPP = min(min(DPPs));
    for j=1:viaduto.apoio(i).n_pilares
        for dirloc=[1 2]
            no=info.pilares.apoio(i).pilar(j).no_impacto;
            switch dirloc
                case 1
                    FC=C00;
                    dir=no*6-(6-dirloc);
                case 2
                    FC=C90;
                    dir=no*6-(6-dirloc);
            end
            %Decresce linearmente até zero em 10m NBR 7188
            FC=FC-FC*abs(DPP)/10; 
            if FC<=0
                FC=0;%se for negativo então é zero.
                % break % Esse break remove o caso de carregamento, caso seja nulo a envoltoria esta crashando sem tempo de considerar esse caso
            end
            
            cont=cont+1;
            LC(cont).jl=zeros(MA.n.joints*6,1);
            LC(cont).cc=[];
            LC(cont).cd=[];
            LC(cont).ct=[];

            
            LC(cont).jl(dir)=FC;
            
        end
    end
end

info.LC.CEP_fim=cont;%anota numero do ultimo
end