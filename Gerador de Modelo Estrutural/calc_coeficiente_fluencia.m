function [phi] = calc_coeficiente_fluencia(fck,delta_t_ef,Umi,s,h_fic,alfa_flu,Ti,abatimento)
%Calcula o coeficiente de fluencia do concreto
%   De acordo com a NBR 6118:2014 anexo A
if abatimento<5
    mult_abatimento=0.75;
elseif abatimento>9
    mult_abatimento=1.25;
else
    mult_abatimento=1.00;
end


fck_tef_sobre_fck_inf=exp(s*(1-(28/delta_t_ef)^.5))/exp(s);


if fck<50
    phi_a=0.8*(1-fck_tef_sobre_fck_inf);
else
    phi_a=1.4*(1-fck_tef_sobre_fck_inf);
end

phi_1c=4.45-0.035*Umi*mult_abatimento;
phi_2c=(42+h_fic*100)/(20+h_fic*100);
if fck<50
    phi_f_inf=phi_1c*phi_2c;
else
    phi_f_inf=.45*phi_1c*phi_2c;
end

Aflu= 42 *h_fic^3-  350*h_fic^2+ 588* h_fic+113;
Bflu= 768*h_fic^3- 3060*h_fic^2+ 3234*h_fic-23;
Cflu=-200*h_fic^3+   13*h_fic^2+ 1090*h_fic+183;
Dflu=7579*h_fic^3-31916*h_fic^2+35343*h_fic+1931;

t0_flu=alfa_flu*((Ti+10)/30)*delta_t_ef;
beta_f=(t0_flu^2+Aflu*t0_flu+Bflu)/(t0_flu^2+Cflu*t0_flu+Dflu);
phi_f_inf_t0=phi_f_inf*(1-beta_f);
phi_d=.4;

phi=phi_a+phi_f_inf_t0+phi_d;% Em porcentagem!
end

