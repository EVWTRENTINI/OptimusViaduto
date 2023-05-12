function [Asl,fator_amp,situacao,msg_erro]=dim_pilar_circ_curv_aprox(diam,le,fck,gama_c,alfa_e,alfa_b,Ms1d,Nsd,NQP,MQP,c,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,delta_t_ef,s,alfa_flu,abatimento,Umi,Ti,config_draw)  
Asl=0;
fator_amp=0;
situacao=true;
msg_erro='sem erro';
Ms1d_original=Ms1d;

%% Propriedades da seção transversal
n_pontos_disc_secao=32;
[secaox,secaoy]=circulo(diam/2,n_pontos_disc_secao);
secao(:,1)=secaox;secao(:,2)=secaoy;
[geom,~,~] = polygeom(secao(:,1),secao(:,2));
Ac=diam^2*pi/4;
Ic=pi/4*((diam/2)^4);
Uar=pi*diam;

%% Propriedades da armadura ativa (nula)
aa.x=0; aa.y=0; aa.A=0; aa.Epp=0; aa.dcabo=0; aa.ncord=0; aa.n=0;


%% Propriedades do pilar
teta1=1/200;
As_min=Ac*.4/100;%minima 
As_max=Ac*4/100;%máxima

%% Exentricidade acidental e Momento mínimo
[ea,Ms1d]=ea_Ms1d_min(le,teta1,diam,Nsd,Ms1d);

%% Exentricidade adicional de fluência

ecc = calc_excentricidade_de_fluencia(Uar,Umi,Ac,fck,delta_t_ef,s,alfa_flu,Ti,abatimento,alfa_e,le,Ic,MQP,NQP,ea);
Ms1d=Ms1d+ecc*Nsd;

%% Cálculo do momento de segunda ordem
[Ms2d,situacao,msg_erro]=calc_Ms2d_curv_aprox_circ(Nsd,le,diam,fck,gama_c);
if not(situacao); return; end

Msd=Ms1d*alfa_b+Ms2d;
if Msd<Ms1d*alfa_b
    Msd=Ms1d*alfa_b;
end
fator_amp=Msd/Ms1d_original;

%% Dimensionamento
[Asl,situacao,msg_erro] = flexao_circular(secao,diam,fck,gama_c,Msd,-Nsd,aa,c,As_min,As_max,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);



end