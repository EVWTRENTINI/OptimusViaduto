function [Asl,fator_amp,situacao,msg_erro]=dim_pilar_circ_acop_MNK(diam,le,fck,gama_c,alfa_e,gama_f3,alfa_b,Ms1d,Nsd,NQP,MQP,c,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,delta_t_ef,s,alfa_flu,abatimento,Umi,Ti,config_draw)  
Asl=0;
fator_amp=0;
situacao=true;
msg_erro='sem erro';
Ms1d_original=Ms1d;

%% Propriedades da seção transversal
n_pontos_disc_secao=32;% Tem que ser o mesmo de dentro do dimensionador, flexao_circular_segunda_ordem.m
[secaox,secaoy]=circulo(diam/2,n_pontos_disc_secao);
secao(:,1)=secaox;secao(:,2)=secaoy;
[geom,~,~] = polygeom(secao(:,1),secao(:,2));
Ac=diam^2*pi/4;
Ic=pi/4*((diam/2)^4);
Uar=pi*diam;
i=diam/4;
lambda=le/i;

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

%% inicializa alojador de armadura de seção circular

[As_min,As_max,r_min,r_max,situacao,msg_erro]=inicializa_alojador_circ(diam,As_min,As_max,dmag,fi_l_min,fi_l_max,fi_t,c);
if not(situacao); return; end
n_bar_repr_continua=25;% Tem que ser o mesmo de dentro do dimensionador, flexao_circular_segunda_ordem.m

%% Determina a As necessario para possuir a rigidez secante mínima
v=Nsd/(Ac*fck/gama_c*1000);%força normal adimensional
EI_sec_min=lambda^2*v/(120)*(Ac*diam^2*fck/gama_c*1000);

% Aqui é calculada a rigidez secante com armadura mínima, caso ela já seja
% maior que a rigidez minima o processo continua, caso não for suficiente
% aqui é calculada a area de aço minima suficiente para promover a rigidez
% suficiente.
ak=As_min;
[fak,situacao,msg_erro]=    calc_EI_sec(secao,fck,gama_c,gama_f3,ak,Nsd,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
if not(situacao); return; end

if fak<EI_sec_min % Se a rigidez secante com armadura minima for menor que a minima necessária - Cálculo da armadura mínima necessária
    
    bk=As_max;
    [fbk,situacao,msg_erro]=calc_EI_sec(secao,fck,gama_c,gama_f3,bk,Nsd,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
    if not(situacao); return; end
    if fbk<EI_sec_min %Caso mesmo com armadura máxima a rigidez secante não for suficiente, aborta o dimensionamento
        situacao=false;
        msg_erro='Mesmo com armadura máxima a rigidez secante não é maior que a mínima';
        return
    end
    
    limite_iteracoes=20;
    limite_dif_EI_sec=0.001;
    
    contador_de_testes=0;
    while (contador_de_testes<limite_iteracoes)
        contador_de_testes=contador_de_testes+1;
        ck=bk-(((fbk-EI_sec_min)*(bk-ak))/(fbk-fak));
        [ffck,situacao,msg_erro]=calc_EI_sec(secao,fck,gama_c,gama_f3,ck,Nsd,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
        V=[fak ffck];
        ak_ck_mesmo_simal=~any(diff(sign(V(V~=0))));
        if  ak_ck_mesmo_simal
            ak=ck;
            [fak,situacao,msg_erro]=calc_EI_sec(secao,fck,gama_c,gama_f3,ak,Nsd,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
            dif_EI_sec=(fak-EI_sec_min)/EI_sec_min;
            if dif_EI_sec<=limite_dif_EI_sec
                if dif_EI_sec>0
                    break
                end
            end
        else
            bk=ck;
            [fbk,situacao,msg_erro]=calc_EI_sec(secao,fck,gama_c,gama_f3,bk,Nsd,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
            dif_EI_sec=(fbk-EI_sec_min)/EI_sec_min;
            if dif_EI_sec<=limite_dif_EI_sec
                if dif_EI_sec>0
                    break
                end
            end
        end
        
    end
    As_min_EI_sec=ck*1.01;


    if contador_de_testes==limite_iteracoes
        situacao=false;
        msg_erro='Rigidez secante não convergiu dentro do limite de iterações';
        return
    end
    
else
    As_min_EI_sec=0;
end

if As_min_EI_sec >= As_max
    situacao = false;
    msg_erro = 'Armadura mínima corrigida é maior que a máxima';
    return
end
%% Dimensionamento
% acredito que o As_min e As_max deve ser passado para a função flexao_circular_segunda_ordem, conferir!
[As,Ms12d,situacao,msg_erro] = flexao_circular_segunda_ordem(secao,diam,fck,gama_c,Ms1d,alfa_b,-Nsd,aa,c,0,0,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,le,gama_f3,As_min_EI_sec,config_draw);
Asl=As;    
fator_amp=max([1 Ms12d/Ms1d_original]);



%%Dimensionamento antigo
% limite_iteracoes=20;
% limite_dif_Mrd=0.01;
% dif_Mrd=limite_dif_Mrd+1;
% Ms12d=Ms1d;
% conttestes=0;
% 
% while (abs(dif_Mrd)>limite_dif_Mrd && conttestes<limite_iteracoes)
%     conttestes=conttestes+1;
%     Ms12d_ant=Ms12d(conttestes);
%     [As,situacao,msg_erro] = flexao_circular(secao,diam,fck,gama_c,Ms12d(conttestes),-Nsd,aa,c,As_min_EI_sec,0,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
%     if not(situacao); return; end
%     [Ms12d(conttestes+1),situacao,msg_erro]=calc_Ms12d_acop_MNK_circ(Nsd,Ms1d,alfa_b,le,diam,secao,fck,gama_c,gama_f3,As,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
%     if not(situacao); return; end
%     dif_Mrd=abs((Ms12d(conttestes+1)-Ms12d_ant)/Ms12d(conttestes+1));
%     Ms12d_ant=Ms12d(conttestes+1);
%     if dif_Mrd<=limite_dif_Mrd
%         break
%     end
% end
% if conttestes==limite_iteracoes
%     situacao=false;
%     msg_erro='Momento de segunda ordem não convergiu dentro do limite de iterações.';
%     As=0;
%     return
% end
% %%plot(Ms12d)
% Ms12d=Ms12d(conttestes+1);
% Asl=As;
% fator_amp=Ms12d/Ms1d;
end