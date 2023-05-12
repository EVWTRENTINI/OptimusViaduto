function [Asl,Ast,Aslt,fator_amp,situacao,msg_erro] = dim_pilar_engastado_circ(metodo_dim_pilar,diam,l,l0,alfa_b,Ms1d,Vsd,Tsd,Nsd_min,Nsd_max,NQP,MQP,fck,gama_c,alfa_e,gama_f3,c,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,delta_t_ef,s,alfa_flu,abatimento,Umi,Ti,config_draw)
%% inicialização das variaveis 
Asl=0;
Ast=0;
Aslt=0;
fator_amp=0;
situacao=true;
msg_erro='sem erro';


%% Dimensionamento a flexão

Asl_minmax=zeros(1,2);
fator_amp_minmax=zeros(1,2);


le = 2 * l; % antigamente estava le=2*min([l0+diam l]); alterado no dia 15/09/22
for i=1:2
    switch i
        case 1; Nsd=Nsd_min;
        case 2; Nsd=Nsd_max;
    end
    switch metodo_dim_pilar
        case 1 %Metodo do pilar padrão com curvatura aproximada
            [Asl_minmax(i),fator_amp_minmax(i),situacao,msg_erro]=dim_pilar_circ_curv_aprox(diam,le,fck,gama_c,alfa_e,alfa_b,Ms1d,Nsd,NQP,MQP,c,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,delta_t_ef,s,alfa_flu,abatimento,Umi,Ti,config_draw);
            
        case 2 %Metodo do pilar padrão acoplado ao diagrama N, M e 1/r
            [Asl_minmax(i),fator_amp_minmax(i),situacao,msg_erro]=dim_pilar_circ_acop_MNK(diam,le,fck,gama_c,alfa_e,gama_f3,alfa_b,Ms1d,Nsd,NQP,MQP,c,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,delta_t_ef,s,alfa_flu,abatimento,Umi,Ti,config_draw);
            
        otherwise
            situacao=false;
            msg_erro='Método selecionado inesistente';
    end
    if not(situacao)
        switch i
            case 1; msg_erro=[msg_erro '. Normal mínima'];
            case 2; msg_erro=[msg_erro '. Normal máxima'];
        end
        return;
    end
end
Asl=max(Asl_minmax)*1E4;
fator_amp=max(fator_amp_minmax);
%% Dimensionamento a cisalhamento

d=.72*diam;%Resistência à força cortante de vigas de concreto armado com seção transversal circular - RIEM 2012
b=diam;%Resistência à força cortante de vigas de concreto armado com seção transversal circular - RIEM 2012
A=diam^2*pi/4;
u=diam*pi;
c1=c+fi_t+fi_l_max/2;
Ae=(diam-c1*2)^2*pi/4;
I=pi*diam^4/64;
ymin=diam/2;


[Ast,Aslt,situacao,msg_erro] = dim_cisalhamento(Vsd,0,0,Tsd,0,0,Nsd_min,d,A,u,Ae,I,b,c1,ymin,Ms1d*fator_amp,fck,gama_c);
if not(situacao);   return;  end

end



