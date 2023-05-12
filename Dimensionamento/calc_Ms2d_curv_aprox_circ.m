function [Ms2d,situacao,msg_erro]=calc_Ms2d_curv_aprox_circ(Nsd,le,diam,fck,gama_c)
Ms2d=0;
situacao=true;
msg_erro='sem erro';

fcd=fck/gama_c;

A=pi*diam^2/4;
i=diam/4;
lambda=le/i;
if lambda>90
    situacao=false;
    msg_erro='Lambda maior que 90, inapropriado para o metodo da curvatura aproximada';
    return
end
v=Nsd/(A*fcd*1000);%força normal adimensional
k=.005/(diam*(v+.5));%curvatura
if k>.005/diam
    k=.005/diam;
end
Ms2d=Nsd*le^2/10*k;
end