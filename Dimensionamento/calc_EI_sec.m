function [EI_sec,situacao,msg_erro]=calc_EI_sec(secao,fck,gama_c,gama_f3,As,Nsd,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw)
EI_sec=0;
situacao=true;
msg_erro='sem erro';

ap=disc_arm_circ(n_bar_repr_continua,sqrt(As/n_bar_repr_continua*4/pi),interp1([As_min As_max],[r_min r_max],As));

vmax=max(secao(:,2));
d=vmax-min(ap.y);  %metros


[Mrd,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,ap,aa,-Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
if not(situacao); return; end

Mrd_sobre_gama_f3=Mrd/gama_f3;
Nsd_sobre_gama_f3=Nsd/gama_f3;

mult_fcd=1.1;
[EpA,Epap,situacao,msg_erro] = det_estado_deformacao(secao,fck,gama_c,ap,aa,-Nsd_sobre_gama_f3,Mrd_sobre_gama_f3,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw);
if not(situacao); return; end

k=(Epap-EpA)/d/1000;

EI_sec=Mrd_sobre_gama_f3/k;

end