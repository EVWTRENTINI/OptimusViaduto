function [ap,situacao,msg_erro] = aloja_faixas_armadura_superior(secao,As,As_min,As_max,hlj,c,viaduto,config_draw)
%
%
amp=(max(secao(:,2))-min(secao(:,2)))/2; % altura minima do cabo de protensão, aqui ele assume metade do tamanho da viga
situacao=true;
msg_erro='sem erro';

ap=0;

fi_t=viaduto.longa_fi_tran;
dmag=viaduto.dia_max_agr_grau;
nmc=viaduto.n_max_camadas;
longa_fi_long_min=viaduto.longa_fi_long_min;
longa_fi_long_max=viaduto.longa_fi_long_max;
dr_As=viaduto.disc_rep_as;

secao(:,2)=secao(:,2)*-1;
secao=flip(secao);
secao(end,:)=[];
[~,ind1]=maxk(secao(:,2),2);
[~,ind2]=mink(secao(ind1,1),1);
secao=circshift(secao,length(secao)-ind1(ind2)+1,1);
secao(end+1,:)=secao(1,:);


if situacao
    [ap_min,ap_max,Asmin_y_i,Asmin_y_f,Asmax_y_i,...
        Asmax_y_f,longa_fi_long_max,situacao,msg_erro] = ...
        def_parametros_faixas_armadura(secao,As_max,...
        As_min,hlj,longa_fi_long_min,longa_fi_long_max,...
        fi_t,dmag,nmc,c,amp,config_draw);
    if situacao
        As_min=sum(ap_min.A)*(10^-4);
        As_max=sum(ap_max.A)*(10^-4);
    end
    if not(situacao)
        As=0;
    end
end

% Esta correção foi adicionada em 18/01/2023 por conta de um crash.
% Acontece que a armadura mínima possivel de ser alojada com barras reais
% (As_min=sum(ap_min.A)*(10^-4);) é maior que a minima geometrica teórica.
% Por conta disso o alojador de faixas calculava uma posição fora dos
% limites uma vez que a área de armadura desejada estava é menor que o
% limite As_min.
% Por conta disso quando for alojada uma área de armadura menor que a
% minima na realidade é alojada uma área de armadura IGUAL a mínima.

if As <= As_min
    As = As_min * 1.00001;
end 

if situacao
    [ap,situacao,msg_erro] = aloja_faixas_armadura(secao,As,hlj,fi_t,dr_As,c,Asmin_y_i,Asmin_y_f,Asmax_y_i,Asmax_y_f,sum(ap_max.A)*(10^-4),sum(ap_min.A)*(10^-4),longa_fi_long_min,longa_fi_long_max,config_draw);
end
if situacao
    ap.y=ap.y*-1;
    for i=1:1:length(ap.camada)
        ap.camada(i).y=ap.camada(i).y*-1;
    end
end
end

