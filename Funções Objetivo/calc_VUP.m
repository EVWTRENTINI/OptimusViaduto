function VUP = calc_VUP(dados_cimento, tipo_cimento, fcm, cv_fc, cm, cv_c, CO2m, cv_CO2, URm, cv_UR, ad, kce, pf_target, n)
rng(91259939);
% Dados do cimento
index_tipo_cimento=find(string({dados_cimento.Tipo_de_cimento}) == tipo_cimento);
kc = dados_cimento(index_tipo_cimento).kc;
kfc = dados_cimento(index_tipo_cimento).kfc;
kad = dados_cimento(index_tipo_cimento).kad;
kco2 = dados_cimento(index_tipo_cimento).kco2;
kUR = dados_cimento(index_tipo_cimento).kUR;

% Gera distribuições aleatorias
% Dados do concreto
fc=random('Normal',fcm,fcm*cv_fc,1,n);
indice_valor_negativo = fc < 0;
fc(indice_valor_negativo) = 0;

c=random('Lognormal',log(cm/sqrt(1+cv_c/cm^2)),cv_c,1,n);
indice_valor_negativo = c < 0;
c(indice_valor_negativo) = 0;

% Dados da exposição

CO2=random('Normal',CO2m,CO2m*cv_CO2,1,n);
indice_valor_negativo = CO2 < 0;
CO2(indice_valor_negativo) = 0;

UR=random('Normal',URm,URm*cv_UR,1,n);
indice_valor_negativo = UR < 0;
UR(indice_valor_negativo) = 0;


%% Determina a VUP
%yc=kc.*(20./fc).^kfc .* sqrt(t./20) .* exp((kad.*ad.^(3/2)./(40+fc))+(kco2.*sqrt(CO2)./(60+fc))-(kUR.*(UR.*.01-0.58).^2./(100+fc))).*kce;
t = 20.*(c./(kc.*(20./fc).^kfc .* exp((kad.*ad.^(3/2)./(40+fc))+(kco2.*sqrt(CO2)./(60+fc))-(kUR.*(UR.*.01-0.58).^2./(100+fc))).*kce)).^2;

% Distribuição de probabilidade acumulada
[cdft,tx] = ecdf(t);

VUP = interp1(cdft, tx, pf_target, 'linear', 'extrap');
if VUP < 0
    VUP = 0;
end

rng shuffle
end