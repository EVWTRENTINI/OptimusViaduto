function [As,x,situacao,msg_erro]=dim_flexao_retetangular_simplificado(Msd,bw,d,fck,gama_c,fyd,Es)
As=0;
x=0;
situacao=true;
msg_erro='sem erro';
parametros_concreto
Epyd=fyd/Es*1000;
beta_x_23=Epcu/(Epcu+10);
beta_x_34=Epcu/(Epcu+Epyd);

%% Cálculo da profundidade da linha neutra
x=1/(lambda)*(d*100)*(1-sqrt(1-(((Msd*100)/(alfa_c/2*bw*100*(d*100)^2*fcd/10)))));%cm

%% Determinação do Dominio de deformação
dominio=0;

x23=beta_x_23*d*100;
x34=beta_x_34*d*100;
if x<=x23
    if x>=0
    dominio=2;
    else
        situacao=false;
        msg_erro='Posição da linha neutra, x, na flexão negativo';
        return
    end
elseif x>x23 && x<=x34
    dominio=3;
else
    dominio=4;
    situacao=false;
    msg_erro='Seção transversal em dominio 4';
    return
end

%% Limite do x/d da 6118:2014
beta_x = x / (d*100);

if fck <= 50
    if beta_x > 0.45
        situacao = false;
        msg_erro = 'x/d maior que 0.45';
        return
    end
elseif fck <= 90
    if beta_x > 0.35
        situacao = false;
        msg_erro = 'x/d maior que 0.35';
        return
    end
end

%% Cálculo da armadura
As=Msd*100/(50/1.15*(d*100-lambda/2*x));%cm²/m


end

