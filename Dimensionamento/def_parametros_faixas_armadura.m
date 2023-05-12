function [ap_min,ap_max,Asmin_y_i,Asmin_y_f,Asmax_y_i,Asmax_y_f,longa_fi_long_max,situacao,msg_erro] = def_parametros_faixas_armadura(secao,As_max,As_min,folga_ver,longa_fi_long_min,longa_fi_long_max,fi_t,dmag,nmc,c,amp,config_draw)
%Define os parametros para definição das faixas de armadura
%   Define os limites maximos e minimos para posterior interação linear

situacao=true;
msg_erro='sem erro';

Asmin_y_i=0;
Asmin_y_f=0;
Asmax_y_i=0;
Asmax_y_f=0;

%Alojamento da armadura mínima

if situacao
    [ap_min,~,~,situacao,msg_erro,alojamento_completo] = aloja_armadura(secao,As_min,folga_ver,longa_fi_long_min,fi_t,dmag,nmc,c,amp,config_draw);
    if not(alojamento_completo)
        situacao=false;
        msg_erro='Alojamento da armadura minima incompleto';
        ap_min='erro';
    end
    
else
    ap_min='erro';
end

%Alojamento da armadura máxima

if situacao
    [ap_max,~,~,situacao,msg_erro,alojamento_completo] =     aloja_armadura(secao,As_max,folga_ver,longa_fi_long_max,fi_t,dmag,nmc,c,amp,config_draw);
    if strcmp(msg_erro,'Numero de camadas menor que 1')% caso falhe o maximo mas o minimo deu certo, tenta com o diametro minimo
        longa_fi_long_max=longa_fi_long_min;
        [ap_max,~,~,situacao,msg_erro,alojamento_completo] = aloja_armadura(secao,As_max,folga_ver,longa_fi_long_max,fi_t,dmag,nmc,c,amp,config_draw);
    end
    if situacao
        if sum(ap_max.A)<=sum(ap_min.A)
            situacao=false;
            msg_erro='As máximo menor ou igual As mínimo';
        end
    end

else
    ap_max='erro';
end

%Prepara para alojamento de faixas representativas
if situacao
    Asmin_y_i=min(ap_min.y);
    Asmin_y_f=max(ap_min.y);
    Asmax_y_i=min(ap_max.y);
    Asmax_y_f=max(ap_max.y);
end



end

