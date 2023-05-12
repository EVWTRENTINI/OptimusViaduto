function [Nrdmax,Nrdmin] = Nrdmax_Nrdmin2e(secaolj,secaolg,EpA_ini,Epap_ini,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd)
%Calcula o esforço normal máximo resistido pela seção de duas etapas

dll=vmaxll-min(apll.y);  %metros
hlj=(max(secaolj(:,2))-min(secaolj(:,2)));
dl=dll-hlj;
halfal=(max(secaolg(:,2))-min(secaolg(:,2)));
halfall=halfal+hlj;

%% Calculo na normal máxima
% Considerando que toda a longarina esta deformada em 10‰

EpB_tot=10;
Epap_tot=10;
xb=0;%não existe!

%Fazendo só da primeira etapa pq o concreto estara todo em tração
[SN1e,~] = equacao_equilibrio(fcdt1e,n_conct1e,EpB_tot,xb,Epap_tot,Epcut1e,Epc2t1e,secaolg,vmaxll,apll,aall,0,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
 SN2e=0;%Assumindo que é nulo pois o concreto esta todo em tração (motivo: velocidade de execução da função)
Nrdmax =SN1e+SN2e;

%% Calculo na normal mínima
% Considerando a deformação maxima no concreto ou topo laje ou no topo da
% longarina sendo que a fibra mais tracionada esta com zero de deformação
% Foi utilizada estes parametros por simplificação, sabe-se que a seção
% resiste a um esforço normal maior que este.


k_ini=(Epap_ini-EpA_ini)/dl/1000;%metros
EpC_ini=k_ini*1000*((halfal-dl))+Epap_ini;
EpA_pos_max=(-Epcut1e)-EpA_ini;
EpC_tot=0;
EpC_pos=EpC_tot-EpC_ini;
%Considerando que a def maxima acontece em B
EpB_pos=-Epcut2e;
k_pos=(EpC_pos-EpB_pos)/halfall/1000;%metros
EpA_pos=k_pos*1000*(hlj)+EpB_pos;
%Checando se a def maxima acontece no ponto A ou no ponto B
if EpA_pos<EpA_pos_max
    EpA_pos=EpA_pos_max;
    k_pos=(EpC_pos-EpA_pos)/halfal/1000;
    EpB_pos=-k_pos*1000*(hlj)+EpA_pos;
end
Epap_pos=k_pos*1000*dll+EpB_pos;

%LAJE ou segunda etapa 2e
EpB_tot_lj=EpB_pos;
Epap_tot_lj=Epap_pos;
if not(abs(EpB_tot_lj-Epap_tot_lj)<1E-10)
    xb_lj=-EpB_pos/1000/k_pos;
else
    xb_lj=0;%não existe
end



[SN2e,~] = equacao_equilibrio(fcdt2e,n_conct2e,EpB_tot_lj,xb_lj,Epap_tot_lj,Epcut2e,Epc2t2e,secaolj,vmaxll,aplllj,aalllj,0,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);



%LONGARINA ou primeira etapa 1e
Epap_tot_lg=Epap_ini+Epap_pos;
EpA_tot_lg=EpA_ini+EpA_pos;
k_tot_lg=(Epap_tot_lg-EpA_tot_lg)/dl/1000;
EpB_tot_lg=-k_tot_lg*1000*hlj+EpA_tot_lg;
if not(abs(EpB_tot_lg-Epap_tot_lg)<1E-10)
    xb_lg=-EpB_tot_lg/1000/k_tot_lg;
else
    xb_lg=0;%não existe
end

[SN1e,~] = equacao_equilibrio(fcdt1e,n_conct1e,EpB_tot_lg,xb_lg,Epap_tot_lg,Epcut1e,Epc2t1e,secaolg,vmaxll,apll,aall,0,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);




%SOMA
Nrdmin =SN1e+SN2e;

end

