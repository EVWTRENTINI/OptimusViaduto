function [As,Ms12d,situacao,msg_erro] = flexao_circular_segunda_ordem(secao,diam,fck,gama_c,Ms1d,alfa_b,Nsd,aa,c,As_min,As_max,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,le,gama_f3,As_min_EI_sec,config_draw)
%Determina a armadura longitudinal para resistir ao esforço de flexão
%combinada com normal seções transversais circulares.
%   Caso As min e max for menor ou igual a zero é calculado em função da
%   área
As=0;
Ms12d=0;
situacao=true;
msg_erro='sem erro';
n_bar_repr_continua=25;


%% Alojamento das armaduras maximas e minimas
[As_min,As_max,r_min,r_max,situacao,msg_erro]=inicializa_alojador_circ(diam,As_min,As_max,dmag,fi_l_min,fi_l_max,fi_t,c);
if not(situacao); return; end

% clf
% plot(secao(:,1),secao(:,2))
% hold on
% for i=1:ap_max.n
% [Xas,Yas] = circulo(fi_l_max/2,16);
% plot(ap_max.x(i)+Xas,ap_max.y(i)+Yas,'b');
% end
% axis equal

%% Determinação do As_min_normal
Ac=pi*diam^2/4;%m²
parametros_concreto
Nap=Nsd-Ac*fcd*.85*-1E3;%kN

As_min_normal_e_EI_sec=max([Nap/ap_relacao_constitutiva(-Epc2,Es,fyd)*1.01*(10^-4) As_min_EI_sec]);%m²


if As_min>As_min_normal_e_EI_sec
    As_min_normal_e_EI_sec=As_min;
    if As_min_normal_e_EI_sec>=As_max
        situacao=false;
        msg_erro='Esforço normal maior do que a seção resiste com As máximo';
        return
    end
end

%% Cálculo do Mrd_min
As=As_min_normal_e_EI_sec;

[Mrd_As_min,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,...
    disc_arm_circ(n_bar_repr_continua,sqrt(As/n_bar_repr_continua*4/pi),interp1([As_min As_max],[r_min r_max],As))...
    ,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
if not(situacao); return; end

[Ms12d_As_min,situacao,msg_erro]=calc_Ms12d_acop_MNK_circ(-Nsd,Ms1d,alfa_b,le,diam,secao,fck,gama_c,gama_f3,As,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
if not(situacao); return; end


%% Cálculo do Mrd_max
As=As_max;

[Mrd_As_max,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,...
    disc_arm_circ(n_bar_repr_continua,sqrt(As/n_bar_repr_continua*4/pi),interp1([As_min As_max],[r_min r_max],As))...
    ,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
if not(situacao); return; end

[Ms12d_As_max,situacao,msg_erro]=calc_Ms12d_acop_MNK_circ(-Nsd,Ms1d,alfa_b,le,diam,secao,fck,gama_c,gama_f3,As,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
if not(situacao); return; end

%% Dimensionamento


if Ms12d_As_min<=Mrd_As_min
    As=As_min_normal_e_EI_sec;
    Ms12d=Ms12d_As_min;
elseif Ms12d_As_max<=Mrd_As_max
    
    %Método da Secante
    conttestes=0;
    limite_dif_Mrd=0.001;
    limite_iteracoes=50;
    dif_Mrd=limite_dif_Mrd+1;
    
    As_ant=As_min_normal_e_EI_sec;
    As_atu=As_max;
    
    dif_Mrd_ant=Mrd_As_min-Ms12d_As_min;
    
    while (abs(dif_Mrd)>limite_dif_Mrd && conttestes<limite_iteracoes)
        conttestes=conttestes+1;
        As=As_atu;
        
        [Mrd,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,...
            disc_arm_circ(n_bar_repr_continua,sqrt(As/n_bar_repr_continua*4/pi),interp1([As_min As_max],[r_min r_max],As))...
            ,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
        if not(situacao); return; end
        
        [Ms12d,situacao,msg_erro]=calc_Ms12d_acop_MNK_circ(-Nsd,Ms1d,alfa_b,le,diam,secao,fck,gama_c,gama_f3,As,aa,Es,fpyd,fptd,Eppu,Ep,fyd,As_min,As_max,r_min,r_max,n_bar_repr_continua,config_draw);
        if not(situacao); return; end
        
        dif_Mrd=Mrd-Ms12d;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         figure(100)
%         hold on
%         if conttestes==1
%             
%             scatter([As_min_normal_e_EI_sec As_max],[dif_Mrd_ant Mrd_As_max-Ms12d_As_max])
%             
%            
%             
%         end
%         text(As,dif_Mrd,[' ' num2str(conttestes)],'HorizontalAlignment','left','VerticalAlignment','bottom')
%         scatter(As,dif_Mrd)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        As_atu=As_atu-(dif_Mrd*(As_atu-As_ant))/(dif_Mrd-dif_Mrd_ant);%Secante
        
        if As_atu<As_min_normal_e_EI_sec
            As_atu=As_min_normal_e_EI_sec;
        elseif As_atu>As_max
            As_atu=As_max;
        end
        
        As_ant=As;
        dif_Mrd_ant=dif_Mrd;
        
        if conttestes==limite_iteracoes
            situacao=false;
            msg_erro='Momento resistente e momento solicitantes de segunda ordem não são iguais dentro do limite de iterações.';
            As=0;
            return
        end
    end
    
elseif Ms12d_As_max>Mrd_As_max
    situacao=false;
    msg_erro='Momento solicitante é maior que o resistente com As máximo.';
    As=0;
    return
end



end












