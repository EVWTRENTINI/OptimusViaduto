function [SN,SM] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,Msd,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd)
%
%
k_pos=(Epap_pos-EpB_pos)/dll/1000;%metros
%% LAJE ou segunda etapa 2e
EpB_tot_lj=EpB_pos;
Epap_tot_lj=Epap_pos;
if not(abs(EpB_tot_lj-Epap_tot_lj)<1E-10)
    xb_lj=-EpB_pos/1000/k_pos;
else
    xb_lj=0;%não existe
end

[SN2e,SM2e] = equacao_equilibrio(fcdt2e,n_conct2e,EpB_tot_lj,xb_lj,Epap_tot_lj,Epcut2e,Epc2t2e,secaolj,vmaxll,aplllj,aalllj,0,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);


%% Longarina ou primeira etapa 1e
EpA_pos=k_pos*1000*(hlj)+EpB_pos;
Epap_tot_lg=Epap_ini+Epap_pos;
EpA_tot_lg=EpA_ini+EpA_pos;
k_tot_lg=(Epap_tot_lg-EpA_tot_lg)/dl/1000;
EpB_tot_lg=-k_tot_lg*1000*hlj+EpA_tot_lg;
if not(abs(EpB_tot_lg-Epap_tot_lg)<1E-10)
    xb_lg=-EpB_tot_lg/1000/k_tot_lg;
else
    xb_lg=0;%não existe
end


[SN1e,SM1e] = equacao_equilibrio(fcdt1e,n_conct1e,EpB_tot_lg,xb_lg,Epap_tot_lg,Epcut1e,Epc2t1e,secaolg,vmaxll,apll,aall,0,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);


%% Total
SN=SN2e+SN1e-Nsd;
SM=SM2e+SM1e-Msd;
end

