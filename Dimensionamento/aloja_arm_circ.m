function [ap,r,situacao,msg_erro]=aloja_arm_circ(As,diam,dmag,fi_l,fi_t,c)
%Aloja armadura real na seção circular

situacao=true;
msg_erro='sem erro';

ap=0;
r=0;

n_max_camada=3;

ah=max([.02 fi_l 1.2*dmag]);
av=max([.02 fi_l .5*dmag]);

n_bar_necessario=ceil(As/(pi*fi_l^2/4));

camadas_armadas=0;
n_bar_necessario_ainda=n_bar_necessario;
for i=1:n_max_camada
    camada(i).r=diam/2-c-fi_t-fi_l/2-(i-1)*(fi_l+av);
    camada(i).p=camada(i).r*2*pi;
    camada(i).n_bar_max=floor(camada(i).p/(ah+fi_l));
    if camada(i).r <= 0
        camada(i).n_bar_max = 0;
    end
    if n_bar_necessario_ainda>0
        if n_bar_necessario_ainda>=camada(i).n_bar_max
            camada(i).n_bar=camada(i).n_bar_max;
        else
            camada(i).n_bar=n_bar_necessario_ainda;
        end
    else
        camada(i).n_bar=0;
    end
    if camada(i).n_bar>0
        camadas_armadas=camadas_armadas+1;
    end
    n_bar_necessario_ainda=n_bar_necessario_ainda-camada(i).n_bar;
    
end
if n_bar_necessario_ainda>0
    situacao=false;
    msg_erro='Alojamento impossivel da armadura na seção circular.';
    return
end



for i=1:camadas_armadas
    ap_novo=disc_arm_circ(camada(i).n_bar,fi_l,camada(i).r);
    if i==1
        ap=ap_novo;
    else
        ap=join_ap(ap,ap_novo);
    end
end

r=(sum([camada.r].*[camada.n_bar]))/sum([camada.n_bar]);


end