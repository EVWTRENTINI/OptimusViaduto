function [As,situacao,msg_erro] = flexao_circular(secao,diam,fck,gama_c,Msd,Nsd,aa,c,As_min,As_max,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw)
%Determina a armadura longitudinal para resistir ao esforço de flexão
%combinada com normal seções transversais circulares.
%   Caso As min e max for menor ou igual a zero é calculado em função da
%   área
As=0;
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
Ac=area(secao(:,1),secao(:,2)); % m²
parametros_concreto
Nap=Nsd-Ac*fcd*.85*-1E3;%kN

As_min_normal=Nap/ap_relacao_constitutiva(-Epc2,Es,fyd)*1.01*(10^-4);%m²

if As_min>As_min_normal
    As_min_normal=As_min;
end
if As_min_normal>=As_max
    situacao=false;
    msg_erro='Esforço normal maior do que a seção resiste com As máximo';
    return
end

%% Cálculo do Mrd_min
As=As_min_normal;

[Mrd_min,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,...
    disc_arm_circ(n_bar_repr_continua,sqrt(As/n_bar_repr_continua*4/pi),interp1([As_min As_max],[r_min r_max],As))...
    ,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
if not(situacao); return; end

%% Cálculo do Mrd_max
As=As_max;

[Mrd_max,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,...
    disc_arm_circ(n_bar_repr_continua,sqrt(As/n_bar_repr_continua*4/pi),interp1([As_min As_max],[r_min r_max],As))...
    ,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
if not(situacao); return; end

%% Dimensionamento


if Msd<=Mrd_min
    As=As_min_normal;
elseif Msd<=Mrd_max
    
    %Método da Secante
    conttestes=0;
    limite_dif_Mrd=0.001;
    limite_iteracoes=50;
    dif_Mrd=limite_dif_Mrd+1;
    
    As_ant=As_min_normal;
    As_atu=As_max;
    
    Mrd_ant=Mrd_min;
    
    while (abs(dif_Mrd)>limite_dif_Mrd && conttestes<limite_iteracoes)
        conttestes=conttestes+1;
        As=As_atu;
        
        [Mrd,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,...
            disc_arm_circ(n_bar_repr_continua,sqrt(As/n_bar_repr_continua*4/pi),interp1([As_min As_max],[r_min r_max],As))...
            ,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
        if not(situacao); return; end
        
        dif_Mrd=Mrd-Msd;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         figure(100)
%         hold on
%         if conttestes==1
%             
%             scatter([As_min As_max],[Mrd_min Mrd_max])
%             plot([As_min As_max],[Msd Msd])
%         end
%         text(As,Mrd,[' ' num2str(conttestes)],'HorizontalAlignment','left','VerticalAlignment','bottom')
%         scatter(As,Mrd)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        As_atu=As_atu-(dif_Mrd*(As_atu-As_ant))/(Mrd-Mrd_ant);%Secante
        
        if As_atu<As_min_normal
            As_atu=As_min_normal;
        elseif As_atu>As_max
            As_atu=As_max;
        end
        
        As_ant=As;
        Mrd_ant=Mrd;
        
        if conttestes==limite_iteracoes
            situacao=false;
            msg_erro='Momento resistente e momento solicitantes não são iguais dentro do limite de iterações.';
            As='erro!';
            return
        end
    end
    
elseif Msd>Mrd_max
    situacao=false;
    msg_erro='Momento solicitante é maior que o resistente com As máximo.';
    As=0;
end



end












