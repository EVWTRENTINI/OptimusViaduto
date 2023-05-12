function [ap,ah,av,situacao,msg_erro,alojamento_completo] = aloja_armadura(secao,As,folga_ver,fi_l,fi_t,dmag,nmc,c,amp,config_draw)
%Aloja armadura real na seção transversal
%   As entra em m² e sai em cm²

situacao=true;
msg_erro='sem erro';

offset=c+fi_t+fi_l/2;
[offs_l.x,offs_l.y] = offsetCurve(transpose(secao(1:end-1,1)),transpose(secao(1:end-1,2)), offset);


[yc1,ind]=mink(offs_l.y,2);%y da primeira camada e indice

yc1=yc1(1)+folga_ver;

av=max([.02 fi_l .5*dmag]);
ah=max([.02 fi_l 1.2*dmag]);




cont=0;
offs_cort=([transpose(offs_l.x) transpose(offs_l.y)]);%offset para o corte
[~,ind]=mink(offs_cort(:,2),2);%y da primeira camada e indice
offs_cort(ind,2)=offs_cort(ind,2)-.1;%folga pra cortar em cima
%camada.x=zeros(nmc);
%camada.y=zeros(nmc);


ultima_camada=min([yc1+(av+fi_l)*(nmc-1) (max(secao(:,2))+min(secao(:,2)))/2 min(secao(:,2))+amp-ah-fi_l/2]);

if ultima_camada > 0
    ultima_camada = ultima_camada * 0.999;
else
    ultima_camada = ultima_camada * 1.001;
end


for cortar=yc1:av+fi_l:ultima_camada
    cont=cont+1;
    [camada(cont).x,camada(cont).y,situacao,msg_erro] =  corta_pol_1linha(offs_cort,cortar);
    if not(situacao); ap='erro'; alojamento_completo=false; return; end
end

if cont==0
    situacao=false;
    msg_erro=['Numero de camadas menor que 1'];% se essa msg mudar, mudar o codigo em def_parametros_faixas_armadura.m
    ap='erro';
    alojamento_completo=false;
end

if situacao
    nmc_real=cont;
    
    As_1bar=fi_l^2*pi()/4;
    n_bar_necessarias=ceil(As/As_1bar);
    
    
    for i=1:nmc_real
        l=camada(i).x(2)-camada(i).x(1);
        if l>0
            if l>=ah+fi_l
                camada(i).nmax_bar=2+floor((camada(i).x(2)-camada(i).x(1)-ah-fi_l)/(fi_l+ah));
            else
                camada(i).nmax_bar=1;
            end
        else
            camada(i).nmax_bar=0;
        end
    end
    n_barras_alojaveis=sum([camada(1:nmc_real).nmax_bar]);


alojamento_completo=true;
if n_barras_alojaveis<n_bar_necessarias
    n_bar_necessarias=n_barras_alojaveis;
    alojamento_completo=false;
end


barras_restantes=n_bar_necessarias;
transicao=true;
end
if situacao
    for i=1:nmc_real
        barras_restantes=barras_restantes-camada(i).nmax_bar;
        camada(i).n_bar=camada(i).nmax_bar;
        if barras_restantes<=0
            if transicao
                transicao=false;
                if sum([camada(1:i-1).n_bar])==n_bar_necessarias
                    camada(i).n_bar=0;
                    nn_camadas=i-1;
                else
                    camada(i).n_bar=camada(i).nmax_bar+barras_restantes;
                    nn_camadas=i;%numero necessario de camadas
                end
            else
                camada(i).n_bar=0;
            end
        end
    end
    
    
    
    
    ap.x=zeros(1,n_bar_necessarias);
    ap.y=zeros(1,n_bar_necessarias);
    ap.A=ones(1,n_bar_necessarias)*As_1bar*1E4;%cm²;
    ap.n=n_bar_necessarias;
    j=0;
    for i=1:nn_camadas
        for n=1:camada(i).n_bar
            j=j+1;
            ap.y(j)=camada(i).y(1);
            switch camada(i).n_bar
                case 1
                    ap.x(j)=camada(i).x(n);
                case 2
                    ap.x(j)=camada(i).x(n);
                otherwise
                    espa=(camada(i).x(2)-camada(i).x(1))/(camada(i).n_bar-1);
                    ap.x(j)=camada(i).x(1)+(espa*(n-1));
            end
        end
    end
    
    if config_draw.alojamento_longa
        draw_alojamento_longa
    end
    
    
    
    
    
    
end
end

