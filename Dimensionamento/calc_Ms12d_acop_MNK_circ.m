function [Ms12d,situacao,msg_erro]=calc_Ms12d_acop_MNK_circ(Nsd,Ms1d,alfa_b,le,diam,secao,fck,gama_c,gama_f3,As,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw)
Ms12d=0;
situacao=true;
msg_erro='sem erro';

fcd=fck/gama_c;

A=pi*diam^2/4;
i=diam/4;
lambda=le/i;
if lambda>140
    situacao=false;
    msg_erro='Lambda maior que 140, inapropriado para o metodo acoplado com diagrama momento, normal e curvatura';
    return
end

[EI_sec,situacao,msg_erro]=calc_EI_sec(secao,fck,gama_c,gama_f3,As,Nsd,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
if not(situacao); return; end

v=Nsd/(A*fcd*1000);%força normal adimensional

k_sec=EI_sec/(A*diam^2*fcd*1000);

if lambda^2/(120*k_sec/v)>=1
    situacao=false;
    msg_erro='Relação entre lambda, rigidez secante e força normal admensinal maior que 1';
    return
end

Ms12d=alfa_b*Ms1d/(1-lambda^2/(120*k_sec/v));
if Ms12d<Ms1d*alfa_b
    Ms12d=Ms1d*alfa_b;
end

end