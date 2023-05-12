function [flecha_ativa, flecha_diferida,situacao,msg_erro] = confere_limite_flecha(lx, Mg1, fck, tPP, s_cim, alfa_e, Iyl, Iyll, Mg23, lxp, MP, tP, MMULT, MVEIC, psi_2, limite_l_sobre_flecha_ativa, mult_flecha_protensao, mult_flecha_peso_proprio, mult_flecha_acoes_permanentes, mult_flecha_acoes_variaveis, limite_l_sobre_flecha_diferida)
flecha_ativa = 0;
flecha_diferida = 0;
situacao=true;
msg_erro='sem erro';

yg1 = momento2deformacao(lx,  Mg1, calc_Eci_t(fck,tPP,s_cim,alfa_e)*Iyl/1000);
yg1ll = momento2deformacao(lx,  Mg1, calc_Eci(fck*1E6,alfa_e)*Iyll/1000);
yg23 = momento2deformacao(lx,  Mg23, calc_Eci(fck*1E6,alfa_e)*Iyll/1000);
yP  = momento2deformacao(lxp, MP,  calc_Eci_t(fck,tP, s_cim,alfa_e)*Iyl/1000);
yq  = momento2deformacao(lx, MMULT+MVEIC, calc_Eci(fck*1E6,alfa_e)*Iyll/1000);

ymg1=interp1(lx,yg1,max(lx/2));
ymgll1=interp1(lx,yg1ll,max(lx/2));
ymg23=interp1(lx,yg23,max(lx/2));
ymP=interp1(lxp,yP,max(lxp/2));
ymq=interp1(lx,yq,max(lx/2));

flecha_ativa = ymq/psi_2;
limite_flecha_ativa = max(lx)/limite_l_sobre_flecha_ativa;

if flecha_ativa > limite_flecha_ativa
    situacao=false;
    msg_erro=['Flecha ativa maior que a limite. ' num2str(flecha_ativa*100) ' cm > ' num2str(limite_flecha_ativa*100) ' cm.'];
    return
end

flecha_diferida = ymP*mult_flecha_protensao + ymg1 + ymgll1*(mult_flecha_peso_proprio-1) + ymg23*mult_flecha_acoes_permanentes + (ymq/psi_2 + ymq*mult_flecha_acoes_variaveis);
limite_flecha_diferida = max(lx)/limite_l_sobre_flecha_diferida;

if flecha_diferida > limite_flecha_diferida
    situacao=false;
    msg_erro=['Flecha diferida maior que a limite. ' num2str(flecha_diferida*100) ' cm > ' num2str(limite_flecha_diferida*100) ' cm.'];
    return
end
end