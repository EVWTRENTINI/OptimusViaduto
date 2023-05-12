function [As,situacao,msg_erro] =flexao_As2e(secaol,secaoll,fck,s_cim,tclj,gama_c,Msd,Nsd,Mg2e,aall,aall_ime,ap_supll,c,amp,hlj,blj,As_min_original,As_max_original,viaduto,config_draw)
%Determina a armadura longitudinal para resistir ao esforço de flexão
%combinada com normal para peças construidas duas etapa de concretagem.
%   Caso As min e max for menor ou igual a zero é calculado em função da
%   área
As=0;

% Propriedade dos materiais
Es=viaduto.Es;%kN/cm² %modulo de elasticidade aço passivo
fpyd=viaduto.fpyd;%kN/cm² 
fptd=viaduto.fptd;%kN/cm² 
Eppu=viaduto.Eppu;%‰
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade
fyd=viaduto.fyk/viaduto.gama_s;

mult_fcd=.85;%fator de Rusch na relação constitutiva

fcki=calc_fct(fck,s_cim,tclj);    %Resisistencia caracteristica do concreto da primeira etapa na etapa inicial em MPa
fckt1e=fck;                       %Resisistencia caracteristica do concreto da primeira etapa na etapa total em MPa
fckt2e=fck;                       %Resisistencia caracteristica do concreto da segunda  etapa na etapa total em MPa

vmaxl=max(secaol(:,2));
vminl=min(secaol(:,2));
vmaxll=max(secaoll(:,2));
vminll=min(secaoll(:,2));
dif_cg=vminll-vminl;

%Seção da laje com cg do conjunto
secaolj=[-blj/2 0;-blj/2 -hlj;blj/2 -hlj;blj/2 0;-blj/2 0];
secaolj(:,2)=secaolj(:,2)+vmaxll;


%seção da longarina com cg do conjunto
secaolg=secaol;
secaolg(:,2)=secaolg(:,2)+dif_cg;

%Armadura passiva superior da longarina
ap_supl=ap_supll;
ap_supl.y=ap_supll.y-dif_cg;
for i=1:1:length(ap_supll.camada)
    ap_supl.camada(i).y=ap_supll.camada(i).y-dif_cg;
end

%Armadura ativa da longarina
aal=aall;
aal.y=aall.y-dif_cg;

aal_ime=aall_ime;
aal_ime.y=aall_ime.y-dif_cg;


%% Alojamento das armaduras maximas e minimas
situacao=true;
msg_erro='sem erro';
fi_t=viaduto.longa_fi_tran;
dmag=viaduto.dia_max_agr_grau;
nmc=viaduto.n_max_camadas;
Ac=area(secaoll(:,1),secaoll(:,2));
if As_max_original<=0
	As_max_original=Ac*4/100;%máximo
end
if As_min_original<=0
    As_min_original=Ac*.15/100;%minima
end
longa_fi_long_min=viaduto.longa_fi_long_min;
longa_fi_long_max=viaduto.longa_fi_long_max;
dr_As=viaduto.disc_rep_as;



if situacao
    [ap_min,ap_max,Asmin_y_i,Asmin_y_f,Asmax_y_i,...
        Asmax_y_f,longa_fi_long_max,situacao,msg_erro] = ...
        def_parametros_faixas_armadura(secaol,As_max_original,...
        As_min_original,0,longa_fi_long_min,longa_fi_long_max,...
        fi_t,dmag,nmc,c,amp,config_draw);
    if situacao
        As_min=sum(ap_min.A)*(10^-4);
        As_max=sum(ap_max.A)*(10^-4);
    end
    if not(situacao)
        As=0;
    end
    
end

%% Calculo da armadura mínima
if situacao
    [As_min_lg_2e,situacao,msg_erro] = flexao_As(secaol,fcki,gama_c,Mg2e,Nsd,aal_ime,ap_supl,c,amp,As_min_original,As_max_original,viaduto,config_draw);
end
if situacao
    if As_min_lg_2e*1.01>As_min
        As=As_min_lg_2e*1.01;
    else
        As=As_min;
    end
end

%% Cálculo do Mrd_min
if situacao
    [ap_min_inf,situacao,msg_erro] = aloja_faixas_armadura(secaol,As,0,fi_t,dr_As,c,Asmin_y_i,Asmin_y_f,Asmax_y_i,Asmax_y_f,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw);
    apl=join_ap(ap_min_inf,ap_supl);
    
    %Armadura passiva em coordenadas do conjunto longarina laje
    apll=apl;
    apll.y=apl.y+dif_cg;
    for i=1:1:length(apl.camada)
        apll.camada(i).y=apl.camada(i).y+dif_cg;
    end
    
    if config_draw.alojamento_faixas_longa_joined
        secao=secaol;
        ap=apl;
        aa=aal;
        draw_alojamento_faixas_joined
    end
    
end

if situacao
    [Mrd_min,situacao,msg_erro]=calc_Mrd2e(secaol,secaoll,secaolg,secaolj,fcki,fckt1e,fckt2e,gama_c,apl,apll,aal_ime,aall,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw);
end

%% Cálculo do Mrd_max

if situacao
    As=As_max;
    [ap_max_inf,situacao,msg_erro] = aloja_faixas_armadura(secaol,As,0,fi_t,dr_As,c,Asmin_y_i,Asmin_y_f,Asmax_y_i,Asmax_y_f,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw);
    apl=join_ap(ap_max_inf,ap_supl);
    
    %Armadura passiva em coordenadas do conjunto longarina laje
    apll=apl;
    apll.y=apl.y+dif_cg;
    for i=1:1:length(apl.camada)
        apll.camada(i).y=apl.camada(i).y+dif_cg;
    end
    
    if config_draw.alojamento_faixas_longa_joined
        secao=secaol;
        ap=apl;
        aa=aal;
        draw_alojamento_faixas_joined
    end
    
end

if situacao
    [Mrd_max,situacao,msg_erro]=calc_Mrd2e(secaol,secaoll,secaolg,secaolj,fcki,fckt1e,fckt2e,gama_c,apl,apll,aal_ime,aall,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw);
end



%% Dimensionamento
if situacao
    if Msd<=Mrd_min
        As=As_min;
        %%%%DESENHO DA DO MOMENTO MINIMO%%%%%%
        if config_draw.def_ini_pos_tot_final
            apl=join_ap(ap_min_inf,ap_supl);
            
            %Armadura passiva em coordenadas do conjunto longarina laje
            apll=apl;
            apll.y=apl.y+dif_cg;
            for i=1:1:length(apl.camada)
                apll.camada(i).y=apl.camada(i).y+dif_cg;
            end
            config_draw_temporario=config_draw;
            config_draw_temporario.def_ini_pos_tot=true;
            [~,~,~]=calc_Mrd2e(secaol,secaoll,secaolg,secaolj,fcki,fckt1e,fckt2e,gama_c,apl,apll,aal_ime,aall,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw_temporario);
        end
        %%%%%%%%%%%%FIM DO DESENHO%%%%%%%%%%%%
        
        
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
                if situacao
                    [ap_inf,situacao,msg_erro] = aloja_faixas_armadura(secaol,As,0,fi_t,dr_As,c,Asmin_y_i,Asmin_y_f,Asmax_y_i,Asmax_y_f,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw);
                    apl=join_ap(ap_inf,ap_supl);
                    
                    %Armadura passiva em coordenadas do conjunto longarina laje
                    apll=apl;
                    apll.y=apl.y+dif_cg;
                    for i=1:1:length(apl.camada)
                        apll.camada(i).y=apl.camada(i).y+dif_cg;
                    end
                    
                    if config_draw.alojamento_faixas_longa_joined
                        secao=secaol;
                        ap=apl;
                        aa=aal;
                        draw_alojamento_faixas_joined
                    end
                end
                
                if situacao
                    [Mrd,situacao,msg_erro]=calc_Mrd2e(secaol,secaoll,secaolg,secaolj,fcki,fckt1e,fckt2e,gama_c,apl,apll,aal_ime,aall,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw);
                end
                
                dif_Mrd=Mrd-Msd;
                
%                                  figure(100)
%                                  hold on
%                                  if conttestes==1
%                                      scatter([As_min As_max],[Mrd_min Mrd_max])
%                                      plot([As_min As_max],[Msd Msd])
%                                  end
%                                  text(As,Mrd,[' ' num2str(conttestes)],'HorizontalAlignment','left','VerticalAlignment','bottom')
%                                  scatter(As,Mrd)

                                 
                if As_atu==As_ant
                    situacao=false;
                    msg_erro='As da iteração passada é igual da iteração atual.';
                    As=0;
                end
                As_atu=As_atu-(dif_Mrd*(As_atu-As_ant))/(Mrd-Mrd_ant);%Secante
                if As_atu<sum(ap_min_inf.A)/10000
                    As_atu=sum(ap_min_inf.A)/10000*1.0001;
                elseif As_atu>sum(ap_max_inf.A)/10000
                    As_atu=sum(ap_max_inf.A)/10000*.9999;
                end
                
                As_ant=As;
                Mrd_ant=Mrd;
                
                
                if conttestes==limite_iteracoes
                    situacao=false;
                    msg_erro='Momento resistente e momento solicitantes não são iguais dentro do limite de iterações.';
                    As=0;
                end
            end
            
        end
        
        %%%%%%%%DESENHO DA DO MSD=MRD%%%%%&&%%
        if situacao
            if config_draw.def_ini_pos_tot_final
                config_draw_temporario=config_draw;
                config_draw_temporario.def_ini_pos_tot=true;
                [~,~,~]=calc_Mrd2e(secaol,secaoll,secaolg,secaolj,fcki,fckt1e,fckt2e,gama_c,apl,apll,aal_ime,aall,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw_temporario);
            end
            if config_draw.alojamento_final
                secao=secaoll;
                ap=apll;
                aa=aall;
                draw_alojamento_final
            end
        end
        %%%%%%%%%%%%FIM DO DESENHO%%%%%%%%%%%%
        
    elseif Msd>Mrd_max
        situacao=false;
        msg_erro='Momento solicitante no conjunto longarina laje é maior que o resistente com As máximo.';
        As=0;
    end
  
end

end

