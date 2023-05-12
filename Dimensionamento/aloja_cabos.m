function [aa,situacao,msg_erro] = aloja_cabos(secao,b2,ntcord,nmcc,dcabo,amp,area1cord,c,fi_t,config_draw)
%Aloja cabos de protensão
%   

situacao=true;
msg_erro='sem erro';

ntc=ceil(ntcord/nmcc);
ncord_int=floor(ntcord/ntc);

aa.x(1:ntc)=0;%metros
aa.y(1:ntc)=0;%metros
aa.A(1:ntc)=0;%cm²
aa.Epp(1:ntc)=0;%por mil
aa.dcabo(1:ntc)=dcabo;%metros
aa.ncord(1:ntc)=ncord_int;%numero de cordoalhas corrigido logo em seguida
aa.n=ntc;

for cont=1:(ntcord-ncord_int*ntc)
    aa.ncord(cont)=aa.ncord(cont)+1;
end
for cont=1:ntc
    aa.A(cont)=aa.ncord(cont)*area1cord;
end

av=max([.05 dcabo]);
ah=max([.04 dcabo]);


secao_transformada=secao;%secao transformada pois o offset horizontal não é igual ao vertical
[~,ind_t]=mink(secao_transformada(:,2),2);%indice dos nós mais baixos
secao_transformada(ind_t,2)=secao_transformada(ind_t,2)-1;%folga pra cortar em cima


offset=max([ah+dcabo/2 c+fi_t+dcabo/2]);

secao_transformada=secao_transformada(2:11,:);% Tira o talão superior da longarina
if offset>b2/2
    secao_transformada=secao_transformada(2:9,:);
end

[offs_l.x,offs_l.y] = offsetCurve(transpose(secao_transformada(1:end,1)),transpose(secao_transformada(1:end,2)), offset,[],false);


[yc1,ind]=mink(offs_l.y,2);%y da primeira camada e indice

yc1=yc1(1);


cont=0;
offs_cort=([transpose(offs_l.x) transpose(offs_l.y)]);%offset para o corte
%[~,ind]=mink(offs_cort(:,2),2);%y da primeira camada e indice
%offs_cort(ind,2)=offs_cort(ind,2)-1;%folga pra cortar em cima
%camada.x=zeros(nmc);
%camada.y=zeros(nmc);


ultima_camada=min([max(offs_cort(:,2)) max(secao(:,2)-offset)]);
if ultima_camada > 0
    ultima_camada = ultima_camada * 0.999;
else
    ultima_camada = ultima_camada * 1.001;
end

for cortar=min(secao(:,2))+amp+dcabo/2:av+dcabo:ultima_camada
    cont=cont+1;
    [camada(cont).x,camada(cont).y,situacao,msg_erro] =  corta_pol_1linha(offs_cort,cortar);
    if not(situacao); aa='erro'; return; end
end

if cont==0
    situacao=false;
    msg_erro=['Numero de camadas de armadura ativa menor que 1'];
    aa='erro';
    return
end

if situacao
    nmc_real=cont;
    l=zeros(1,nmc_real);
    n_bar_necessarias=ntc;
    for i=1:nmc_real
        l(i)=camada(i).x(2)-camada(i).x(1);
        if l(i)>0
            if l(i)>=ah+dcabo
                camada(i).nmax_bar=2+floor((camada(i).x(2)-camada(i).x(1)-ah-dcabo)/(dcabo+ah));
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
    situacao=false;
    msg_erro=['Alojamento impossivel do numero de cabos de protensão'];
    aa='erro';
    return
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
    

    j=0;
    for i=1:nn_camadas
        for n=1:camada(i).n_bar
            j=j+1;
            aa.y(j)=camada(i).y(1);
            m=(camada(i).n_bar-1)*(dcabo+ah);
            aa.x(j)=camada(i).x(1)+(l(i)-m)/2+(n-1)*(dcabo+ah);
        end
    end
    
     if config_draw.alojamento_cabos
         draw_alojamento_cabos
     end
     
end
end

