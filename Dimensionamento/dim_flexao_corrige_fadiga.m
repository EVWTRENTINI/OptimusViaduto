function [As,situacao,msg_erro]=dim_flexao_corrige_fadiga(Msd,MCF_max,MCF_min,h_total,bf,d,fck,gama_c,alfa_e,fyd,Es)
%Dimensiona seção retangular a flexão e corrige a armadura de acordo com a tensão
%limite de fadiga usando o diagrama retangular simplificado
%

As=0;
situacao=true;
msg_erro='sem erro';

As_min=100*h_total*100*0.15/100;
As_max=100*h_total*100*4/100;
if Msd==0
    As=As_min;
    return
end

%% Dimensionamento
[As,x,situacao,msg_erro]=dim_flexao_retetangular_simplificado(Msd,bf,d,fck,gama_c,fyd,Es);
if not(situacao); return; end

%% Correção da área para fadiga, mínima e máxima
delta_sigma_limite=190;%MPa

As_ori=As;
[As,situacao,msg_erro]=corrige_fadiga_flexao(delta_sigma_limite,As,As_max,As_min,MCF_max,MCF_min,bf,d,fck,alfa_e,Es);

end

