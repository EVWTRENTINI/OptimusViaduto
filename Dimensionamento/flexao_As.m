function [As,situacao,msg_erro] = flexao_As(secao,fck,gama_c,Msd,Nsd,aa,ap_sup,c,amp,As_min,As_max,viaduto,config_draw)
%Determina a armadura longitudinal para resistir ao esforço de flexão
%combinada com normal para peças construidas em apenas uma etapa de concretagem.
%   Caso As min e max for menor ou igual a zero é calculado em função da
%   área
As = 0; % 05/03/2023
situacao=true;
msg_erro='sem erro';

%% Propriedade dos materiais
Es=viaduto.Es;%kN/cm² %modulo de elasticidade aço passivo
fpyd=viaduto.fpyd;%kN/cm² 
fptd=viaduto.fptd;%kN/cm² 
Eppu=viaduto.Eppu;%‰
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade
fyd=viaduto.fyk/viaduto.gama_s;


%% Alojamento das armaduras maximas e minimas
fi_t=viaduto.longa_fi_tran;
dmag=viaduto.dia_max_agr_grau;
nmc=viaduto.n_max_camadas;
Ac=area(secao(:,1),secao(:,2)); 
if As_max<=0
	As_max=Ac*4/100;%máximo
end
if As_min<=0
    As_min=Ac*.15/100;%minima
end
longa_fi_long_min=viaduto.longa_fi_long_min;
longa_fi_long_max=viaduto.longa_fi_long_max;
dr_As=viaduto.disc_rep_as;

if situacao
    [ap_min_inf,ap_max_inf,Asmin_y_i_inf,Asmin_y_f_inf,Asmax_y_i_inf,...
        Asmax_y_f_inf,longa_fi_long_max,situacao,msg_erro] = ...
        def_parametros_faixas_armadura(secao,As_max,...
        As_min,0,longa_fi_long_min,longa_fi_long_max,...
        fi_t,dmag,nmc,c,amp,config_draw);
    if situacao
        As_min=sum(ap_min_inf.A)*(10^-4);
        As_max=sum(ap_max_inf.A)*(10^-4);
    end
    if not(situacao)
        As=0;
    end
end

%% Cálculo do Mrd_min

if situacao
    [ap_inf,situacao,msg_erro] = aloja_faixas_armadura(secao,sum(ap_min_inf.A)/10000,0,fi_t,dr_As,c,Asmin_y_i_inf,Asmin_y_f_inf,Asmax_y_i_inf,Asmax_y_f_inf,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw);
    ap=join_ap(ap_inf,ap_sup);
    if config_draw.alojamento_faixas_longa_joined
        draw_alojamento_faixas_joined
    end
    if situacao
        [Mrd_min,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,ap,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
    end
end
%disp('Calcular momento mínimo, pagina  130 da NBR 6118:2014');

%% Calculo do Mrd_max

if situacao
    [ap_inf,situacao,msg_erro] = aloja_faixas_armadura(secao,sum(ap_max_inf.A)/10000,0,fi_t,dr_As,c,Asmin_y_i_inf,Asmin_y_f_inf,Asmax_y_i_inf,Asmax_y_f_inf,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw);
    ap=join_ap(ap_inf,ap_sup);
    if config_draw.alojamento_faixas_longa_joined
        draw_alojamento_faixas_joined
    end
    if situacao
        [Mrd_max,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,ap,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
    end
end

% for Ass=sum(ap_min.A)/10000:(sum(ap_max.A)/10000-sum(ap_min.A)/10000)/10:sum(ap_max.A)/10000
%     [ap,situacao,msg_erro] = aloja_faixas_armadura(secaoll,Ass,0,fi_t,dr_As,c,Asmin_y_i,Asmin_y_f,Asmax_y_i,Asmax_y_f,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw);
%     if situacao
%         [Mrd,~,situacao,msg_erro] = calc_Mrd(secaoll,fck,ap,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
%     end
%     figure(101)
%     hold on
%     scatter(Ass,Mrd)
% end




%% Dimensionamento

if situacao
    if Msd<=Mrd_min
        As=As_min;
    elseif Msd<=Mrd_max
        %Método da Secante
        conttestes=0;
        limite_dif_Mrd=0.0001;
        limite_iteracoes=50;
        dif_Mrd=limite_dif_Mrd+1;
        
        As_ant=sum(ap_min_inf.A)/10000;
        As_atu=sum(ap_max_inf.A)/10000;
        
        Mrd_ant=Mrd_min;
        
        if situacao
            while (abs(dif_Mrd)>limite_dif_Mrd && conttestes<limite_iteracoes)
                conttestes=conttestes+1;
                As=As_atu;
                
                [ap_inf,situacao,msg_erro] = aloja_faixas_armadura(secao,As,0,fi_t,dr_As,c,Asmin_y_i_inf,Asmin_y_f_inf,Asmax_y_i_inf,Asmax_y_f_inf,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw);
                ap=join_ap(ap_inf,ap_sup);
                if config_draw.alojamento_faixas_longa_joined
                    draw_alojamento_faixas_joined
                end
                if situacao
                    [Mrd,~,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,ap,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);
                end
                if not(situacao); return; end
                dif_Mrd=Mrd-Msd;
%                                   figure(100)
%                                   hold on
%                                   if conttestes==1
% 
%                                       scatter([As_min As_max],[Mrd_min Mrd_max])
%                                       plot([As_min As_max],[Msd Msd])
%                                   end
%                                   text(As,Mrd,[' ' num2str(conttestes)],'HorizontalAlignment','left','VerticalAlignment','bottom')
%                                   scatter(As,Mrd)
                
                As_atu=As_atu-(dif_Mrd*(As_atu-As_ant))/(Mrd-Mrd_ant);%Secante
                
                if As_atu<sum(ap_min_inf.A)/10000
                    As_atu=sum(ap_min_inf.A)/10000;
                elseif As_atu>sum(ap_max_inf.A)/10000
                    As_atu=sum(ap_min_inf.A)/10000;
                end

                As_ant=As;
                Mrd_ant=Mrd;
                
                
                if conttestes==limite_iteracoes
                    situacao=false;
                    msg_erro='Momento resistente e momento solicitantes não são iguais dentro do limite de iterações';
                    As=0;
                end
            end
        end
        
        
    elseif Msd>Mrd_max
        situacao=false;
        msg_erro='Momento solicitante na longarina é maior que o resistente com As máximo';
        As=0;
    end
end
end

