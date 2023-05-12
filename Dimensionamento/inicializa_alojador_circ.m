function [As_min,As_max,r_min,r_max,situacao,msg_erro]=inicializa_alojador_circ(diam,As_min,As_max,dmag,fi_l_min,fi_l_max,fi_t,c)
% Alojamento das armaduras maximas e minimas

r_min = 0;
r_max = 0;

if As_max<=0
    Ac=pi*diam^2/4;
    As_max=Ac*4/100;%máximo
end
if As_min<=0
    Ac=pi*diam^2/4;
    As_min=Ac*.4/100;%minima
end

[ap_min,r_min,situacao,msg_erro]=aloja_arm_circ(As_min,diam,dmag,fi_l_min,fi_t,c);
if not(situacao)
    msg_erro=[msg_erro ' Armadura mínima'];
    return
end

[ap_max,r_max,situacao,msg_erro]=aloja_arm_circ(As_max,diam,dmag,fi_l_max,fi_t,c);
if not(situacao)
    msg_erro=[msg_erro ' Armadura máxima'];
    return
end

As_min=sum(ap_min.A)*(10^-4);%corrigindo
As_max=sum(ap_max.A)*(10^-4);%corrigindo
end