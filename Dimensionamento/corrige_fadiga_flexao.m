function [As,situacao,msg_erro]=corrige_fadiga_flexao(delta_sigma_limite,As,As_max,As_min,MCF_max,MCF_min,bwf,d,fck,alfa_e,Es)
% Pontes de concreto armado - Osvaldemar Marchetti. Pagina 94 equações, Pagina 122 exercicio. 
% https://www.youtube.com/watch?v=CKUAP7b8S3k Aula
% https://www.youtube.com/watch?v=r1NAMRA9l3I Exercicio
% https://uenf.br/cct/leciv/files/2016/02/Maria-Fernanda-Citrangulo-Lutterbach-Pereira.pdf - TCC


situacao=true;
msg_erro='sem erro';


if As<As_min
    As=As_min;
end

[Ecs] = calc_Ecs(fck*10^6,alfa_e)/(10^6);%MPa
Es_sobre_Ecs=Es*10/Ecs; % Não utilizado
Es_sobre_Ecs = 10; % NBR 6118:2014 23.5.3 manda usar 10.

delta_sigma=calc_delta_sigma(MCF_max,MCF_min,As,d,Es_sobre_Ecs,bwf);
cont=0;
limite_cont=15;
limite_erro_tensao=1E-3;
if delta_sigma>delta_sigma_limite
    while and((delta_sigma-delta_sigma_limite)/delta_sigma_limite>limite_erro_tensao,cont<limite_cont)
        cont=cont+1;
        delta_sigma=calc_delta_sigma(MCF_max,MCF_min,As,d,Es_sobre_Ecs,bwf);
        As=As*delta_sigma/delta_sigma_limite*1.0001;
    end
    if and(cont>(limite_cont-1),(delta_sigma-delta_sigma_limite)/delta_sigma_limite>limite_erro_tensao)
        situacao=false;
        msg_erro='Correção da área de armadura para fadiga falhou'
        return
    end
end

if As < As_min; As = As_min; end % Por algum motivo o processo iterativo pode determinar armadura menor que a minima.

if As>As_max
    situacao=false;
    msg_erro='Área de armadura maior que a máxima';
    return
end

end

function sigma_s=calc_sigma_s(MCF,As,d,Es_sobre_Ecs,bwf)
A=Es_sobre_Ecs*(As/10^4)/bwf;
x=A*(-1+sqrt(1+2*d/A));
I=bwf*x^3/3+Es_sobre_Ecs*(As/10^4)*(d-x)^2;
sigma_c=MCF/1000*x/I;
sigma_s=Es_sobre_Ecs*sigma_c*(d-x)/x;
end

function delta_sigma=calc_delta_sigma(MCF_max,MCF_min,As,d,Es_sobre_Ecs,bwf)
sigma_s_max=calc_sigma_s(MCF_max,As,d,Es_sobre_Ecs,bwf);
sigma_s_min=calc_sigma_s(MCF_min,As,d,Es_sobre_Ecs,bwf);
delta_sigma=sigma_s_max-sigma_s_min;
end
