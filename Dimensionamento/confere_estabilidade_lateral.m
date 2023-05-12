function [situacao,msg_erro] = confere_estabilidade_lateral(l,secao,e,P,gama_pc,gama_gc,Nsd,Mg0k,Mg2ek,q_lg_k,q_lj_k,fck,s_cim,t_m,t_c,alfa_e,fs_c,fs_r,fs_pcrit,hap,ktap,cdl,ex_ap,ex_lg,mT_lg_livre,mT_lg_travada,b1,b2,b3,h1,h2,h5,config_draw)
%Verifica estabilidade da longarina sobre aparelho de apoio flexiveis
%   Baseado no livro Pontes de concreto - Mounir Khalil El Debs e Pablo Krahl

situacao=true;
msg_erro='sem erro';

nn=length(secao);%Numero de nós
tensao=zeros(1,nn);


%% Cálculo das resistencias do concreto
gama_c_esp=1.2;% Coeficientes de ponderação das resistências no estado-limite último - Especiais ou de construção

t=t_m;

fck_t = calc_fct(fck,s_cim,t);%MPa
fcd_t=fck_t/gama_c_esp;%MPa

[~,fctkinf_t,~] = calc_fctm(fck_t);%MPa
fctf_t=fctkinf_t*1.2;%MPa 1.2 é resistencia a tração na flexão de seções transversais I.

fctd_t=fctf_t/gama_c_esp;%MPa

%% Cálculo do módulo de elasticidade
Eci = calc_Eci(fck*1E6,alfa_e);%Pa

if fck<=50
    Eci_t=Eci*(fck_t/fck)^.5;%Pa
else
    Eci_t=Eci*(fck_t/fck)^.3;%Pa
end

E=Eci_t/1000;%kPa

%% Propriedades da seção transversal
[geon,iner,~] = polygeom(secao(:,1),secao(:,2));
A=geon(1);%m^2
Iy=iner(1);%m^4
Iz=iner(2);%m^4
yb=abs(min(secao(:,2)))+hap/2;%m


%% Rigidez aparelho de apoio
kt=ktap;%kN*m/rad


%% Imperfeições iniciais
% Temperatura

%multiplicador do quadrado do vão Jong-Han Lee (2012). Def_lateral_temperatura=mT_lg*cdl*l^2
%Behavior of precast prestressed concrete bridge girders involving thermal effects and initial imperfections during construction

%Ideal seria:
%Lee, J.-H., & Kalkan, I. (2012). 
%Analysis of Thermal Environmental Effects on Precast, Prestressed Concrete Bridge Girders: Temperature Differentials and Thermal Deformations.
%doi:10.1260/1369-4332.15.3.447
%delta_T=mT_lg/100*cdl*l^2;% metros
delta_T_livre=mT_lg_livre/100*cdl*l^2;

% Desvio lateral inicial
lambda0=delta_T_livre+l*ex_lg;

% Rotação inicial
phi0=0;

%% Confere estabilidade lateral da longarina - longarina sobre aparelhos de apoio de acordo com o artigo Pablo



% Inclinação
%sinal trocado pra fmin retornar o máximo.
%Mesma equação soh que em linha ----- calcq=@(phi1) -((E*Iz*pi^3*(cos(2*phi0 + 2*phi1) + 1)*(2*2^(1/2)*((1024*kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) - 128*lambda0*pi^2 - 16*pi^3*yb*sin(2*phi0 + 3*phi1) + 2*2^(1/2)*cos(2*phi0)*((1024*kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) + 2*2^(1/2)*cos(2*phi1)*((1024*kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) + 2^(1/2)*cos(2*phi0 - 2*phi1)*((1024*kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) + 2^(1/2)*cos(2*phi0 + 2*phi1)*((1024*kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) - 32*pi^3*yb*sin(phi1) + 16*pi^3*yb*sin(2*phi0 + phi1)))/(2048*l^4*tan(phi0 + phi1)*cos(phi0)^2*cos(phi1)^2*(tan(phi0)*tan(phi1) - 1)^2));

calcq=@(phi1) -((E*Iz*pi^3*(cos(2*phi0 + 2*phi1) + 1)*(2*2^(1/2)*((1024*...
    kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*...
    pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*...
    phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*...
    cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*Iz*...
    pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*phi1)...
    + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*lambda0*...
    pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + phi1))/(E*...
    Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) - 128*lambda0*pi^2 - 16*pi^3*yb*...
    sin(2*phi0 + 3*phi1) + 2*2^(1/2)*cos(2*phi0)*((1024*kt*l^3*phi1*...
    sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - ...
    4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*...
    Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + ...
    4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*Iz*pi^6*yb^2*...
    cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*phi1) + 32*E*...
    Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*lambda0*pi^5*yb*...
    sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + phi1))/(E*Iz*...
    cos(phi0)^4*cos(phi1)^4))^(1/2) + 2*2^(1/2)*cos(2*phi1)*((1024*kt*...
    l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*lambda0^2*pi^4 + 6*E*Iz*...
    pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - 6*E*Iz*pi^6*yb^2*cos(2*...
    phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1) - 4*E*Iz*pi^6*yb^2*...
    cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 2*phi1) + 2*E*...
    Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 + 6*...
    phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) + 64*E*Iz*...
    lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 +...
    phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) + 2^(1/2)*cos(2*phi0 - ...
    2*phi1)*((1024*kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*...
    lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - ...
    6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1)...
    - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 ...
    + 2*phi1) + 2*E*Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*...
    cos(4*phi0 + 6*phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) ...
    + 64*E*Iz*lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*...
    phi0 + phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) + 2^(1/2)*cos(2*...
    phi0 + 2*phi1)*((1024*kt*l^3*phi1*sin(2*phi0 + 2*phi1) + 128*E*Iz*...
    lambda0^2*pi^4 + 6*E*Iz*pi^6*yb^2 - 4*E*Iz*pi^6*yb^2*cos(2*phi0) - ...
    6*E*Iz*pi^6*yb^2*cos(2*phi1) + 8*E*Iz*pi^6*yb^2*cos(2*phi0 + 2*phi1)...
    - 4*E*Iz*pi^6*yb^2*cos(2*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*cos(4*phi0 ...
    + 2*phi1) + 2*E*Iz*pi^6*yb^2*cos(4*phi0 + 4*phi1) - E*Iz*pi^6*yb^2*...
    cos(4*phi0 + 6*phi1) + 32*E*Iz*lambda0*pi^5*yb*sin(2*phi0 + 3*phi1) ...
    + 64*E*Iz*lambda0*pi^5*yb*sin(phi1) - 32*E*Iz*lambda0*pi^5*yb*sin(2*...
    phi0 + phi1))/(E*Iz*cos(phi0)^4*cos(phi1)^4))^(1/2) - 32*pi^3*yb*...
    sin(phi1) + 16*pi^3*yb*sin(2*phi0 + phi1)))/(2048*l^4*tan(phi0 + ...
    phi1)*cos(phi0)^2*cos(phi1)^2*(tan(phi0)*tan(phi1) - 1)^2));


%% Verificação do tombamento - roll over
[phi1max,qmax]=fminbnd(calcq,0,pi/2);
qmax=-qmax;% Destrocando o sinal.



q0d=q_lg_k*max(gama_gc);

if qmax/q0d<fs_r
    situacao=false;
    msg_erro='Fator de segurança contra tombamento menor que o especificado';
    return
end

%% Determinação do angulo de equilíbrio

calcphif=@(phi1) -calcq(phi1)-q0d;% O sinal de menos calcq é para desenverter o calcq
valor_inicial=0.0001;
if calcphif(valor_inicial)*calcphif(phi1max)>0 % Checa se os 2 tem o mesmo sinal pois a função fzero precisa que os 2 pontos iniciais tenham sinais diferentes
    phif=0; % Caso tenham o mesmo sinal consirada que equilibra n zaro
else
    phif=fzero(calcphif,[valor_inicial phi1max]); % Caso tenham o mesmo sinal diferente calcula o equilíbrio
end


%% Desenho

%%%%%% DESENHO
% figure
% hold on
% 
% cont=0;
% for phi1=.0001:.01:pi/2*.99-phi0
%     cont=cont+1;
%     qplot=-calcq(phi1);
%     phi1i(cont)=phi1;
%     qi(cont)=qplot;
% end
% 
% plot(phi1i+phi0,qi)
% scatter(phi1max+phi0,qmax)
% scatter(phif,q0d)
% hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIM DESENHO


%% Verificação das tensões no concreto

for gama_p=gama_pc
    Pd=-P*gama_p;
    Mpyd=-Pd*e;
    for gama_g=gama_gc
        Msyd=Mg0k*gama_g;
        for ni=1:nn
            y=secao(ni,1);
            z=secao(ni,2);
            
            tN=Nsd/A/1000;%MPa
            tMy=-Msyd*z/Iy/1000*cos(phif);%MPa
            tMz=+Msyd*y/Iz/1000*sin(phif);%MPa
            tPN=Pd/A/1000;%MPa
            tPMy=-Mpyd*z/Iy/1000;%MPa
            tensao(ni)=(tN+tMy+tMz+tPN+tPMy);%MPa
        end
        
        tensao_max=max(tensao);
        tensao_min=min(tensao);
        
        %draw_tensao_estab_lat(secao,tensao,1/50,1)
        %['Tensão máxima ' num2str(max(tensao),4) ' MPa']
        %['Tensão mínima ' num2str(min(tensao),4) ' MPa']
        
        if tensao_max/fctd_t>fs_c
            situacao=false;
            msg_erro='Tensão de tração maior que a resistência quando a longarina esta sobre os apoios';
            return
        end
        if tensao_min/-fcd_t>fs_c
            situacao=false;
            msg_erro='Tensão de compressão maior que a resistência quando a longarina esta sobre os apoios';
            return
        end
    end
end




%% Confere estabilidade lateral da longarina - situação com travamento nos apoios

%% Cálculo das resistencias do concreto

t=t_c;% Data da concretagem da laje em dias

fck_t = calc_fct(fck,s_cim,t);%MPa
fcd_t=fck_t/gama_c_esp;%MPa

[~,fctkinf_t,~] = calc_fctm(fck_t);%MPa
fctf_t=fctkinf_t*1.2;%MPa 1.2 é resistencia a tração na flexão de seções transversais I.

fctd_t=fctf_t/gama_c_esp;%MPa

%% Cálculo do módulo de elasticidade
Eci = calc_Eci(fck*1E6,alfa_e);%Pa

if fck<=50
    Eci_t=Eci*(fck_t/fck)^.5;%Pa
else
    Eci_t=Eci*(fck_t/fck)^.3;%Pa
end

E=Eci_t/1000;%kPa

%% Imperfeições iniciais

% Temperatura
delta_T_travada=mT_lg_travada/100*cdl*l^2;

% Desvio lateral inicial
lambda0=delta_T_travada+l*ex_lg;

% Rotação inicial
phi0=0;

%% Verificação da carga critica

J=(b1*h2^3+(h1-h2/2-h5/2)*b2^3+b3*h5^3)/3;%m^4
G=E*.4;%kPa

w_crit=50/(l^3)*sqrt(E*Iz*G*J);% Livro do Pontes de concreto %Lima (1995)

wd=(q_lg_k+q_lj_k)*max(gama_gc);

if w_crit/wd<fs_pcrit
    situacao=false;
    msg_erro='Fator de segurança contra carga critica menor que o especificado durante a concretagem da laje';
    return
end

% %% Determinação do angulo de equilíbrio
% 
% phi0_fic=phi0+(0+2/pi*(lambda0))/yb;
% 
% phif=phi0_fic/(1-wd/w_crit);
% 
% 
% % %%% Verificação das tensões no concreto
% % figure
% % for gama_p=gama_pc
% %     Pd=-P*gama_p;
% %     Mpyd=-Pd*e;
% %     for gama_g=gama_gc
% %         Msyd=Mg2ek*gama_g;
% %         for ni=1:nn
% %             y=secao(ni,1);
% %             z=secao(ni,2);
% %             
% %             tN=Nsd/A/1000;%MPa
% %             tMy=-Msyd*z/Iy/1000*cos(phif);%MPa
% %             tMz=+Msyd*y/Iz/1000*sin(phif);%MPa
% %             tPN=Pd/A/1000;%MPa
% %             tPMy=-Mpyd*z/Iy/1000;%MPa
% %             tensao(ni)=(tN+tMy+tMz+tPN+tPMy);%MPa
% %         end
% %         
% %         tensao_max=max(tensao);
% %         tensao_min=min(tensao);
% %         
% %         draw_tensao_estab_lat(secao,tensao,1/50,.8)
% %         %['Tensão máxima ' num2str(max(tensao),4) ' MPa']
% %         %['Tensão mínima ' num2str(min(tensao),4) ' MPa']
% %         
% %         if tensao_max/fctd_t>fs_c
% %             situacao=false;
% %             msg_erro='Tensão de tração maior que a resistência quando a longarina esta sobre os apoios';
% %             return
% %         end
% %         if tensao_min/-fcd_t>fs_c
% %             situacao=false;
% %             msg_erro='Tensão de compressão maior que a resistência quando a longarina esta sobre os apoios';
% %             return
% %         end
% %     end
% % end

end