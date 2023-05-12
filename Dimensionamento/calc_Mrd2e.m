function [Mrd,situacao,msg_erro]=calc_Mrd2e(secaol,secaoll,secaolg,secaolj,fcki,fckt1e,fckt2e,gama_c,apl,apll,aal,aall,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw)
%Calcula o momento resistente da seção em função da normal solicitante considerando o processo construitivo de concretagem em duas etapas.
%   Esta função utiliza a integral das tensões do diagrama parabola
%   retangulo da NBR:6118:2014 apresentadas por Leonardo Silva (2015)
% inputs:   secaol - Poligonal da secao da primeira etapa [x1 y1;x2 y2...], com origem no cg da primeira etapa em metros
%           secaoll - Poligonal da seção composta [x1 y1;x2 y2...], com origem no cg da seção composta em metros
%           secaolg - Poligonal da secao da primeira etapa [x1 y1;x2 y2...], com origem no cg da seção composta em metros
%           secaolj - Poligonal da secao da segunda etapa [x1 y1;x2 y2...], com origem no cg da seção composta em metros
%           fcki -   Resisistencia caracteristica do concreto da primeira etapa na etapa inicial em MPa
%           fckt1e - Resisistencia caracteristica do concreto da primeira etapa na etapa total em MPa
%           fckt2e - Resisistencia caracteristica do concreto da segunda  etapa na etapa total em MPa
%           gama_c - Coeficiente de ponderação da resistencia do concreto
%           apl - Dados da armadura passiva da primeira etapa em coordenadas do cg da primeira etapa
%               apl.x - Vetor linha de coordenadas x da armadura em metros
%               apl.y - Vetor linha de coordenadas y da armadura em metros
%               apl.A - Vetor linha de áreas de armadura em cm²
%               apl.n - numero total de barras
%           apll - Dados da armadura passiva da primeira etapa em coordenadas do cg da seção composta
%               apll.x - Vetor linha de coordenadas x da armadura em metros
%               apll.y - Vetor linha de coordenadas y da armadura em metros
%               apll.A - Vetor linha de áreas de armadura em cm²
%               apll.n - numero total de barras
%           aal_ime - Dados da armadura ativa da primeira etapa em coordenadas do cg da primeira etapa
%               aal.x - Vetor de coordenadas x da armadura em metros
%               aal.y - Vetor de coordenadas y da armadura em metros
%               aal.A - Vetor de áreas de armadura em cm²
%               aal.Epp - Vetor de pré alongamento no momento da concretagem da segunda etapa em ‰ - por mil
%               aal.dcabo - Diametro do cabos em metros em metros (não obrigatorio)
%               aal.ncord - Vetor numero de cordoalhas por cabo (não obrigatorio)
%               aal.n - numero total de cabos
%           aall - Dados da armadura ativa da primeira etapa em coordenadas do cg da seção composta
%               aall.x - Vetor linha de coordenadas x da armadura em metros
%               aall.y - Vetor linha de coordenadas y da armadura em metros
%               aall.A - Vetor linha de áreas de armadura em cm²
%               aall.Epp - Vetor linha de pré alongamento no infinito em ‰ - por mil
%               aall.dcabo - Diametro do cabos em metros em metros (não obrigatorio)
%               aall.ncord - Vetor linha de numero de cordoalhas por cabo (não obrigatorio)
%               aall.n - numero total de cabos
%           Nsd - Normal solicitante de projeto em kN (o mesmo durante a concretagem e em ELU)
%           Mg2e - Momento solicitante de projeto atuante na primeira etapa que precede solidarização com a segunda etapa em kN.m
%           Es - Modulo de elasticidade do aço passivo em kN/cm²
%           fpyd - Tensão de escoamento de projeto do aço ativo em kN/cm²
%           fptd - Tensão de ultima de projeto do aço ativo em kN/cm²
%           Eppu - Deformação máxima no aço ativo em ‰ - por mil
%           Es - Modulo de elasticidade do aço ativo em kN/cm²
%           fyd - Tensão de escoamento de projeto do aço passivo em kN/cm²
%           mult_fcd - fator do efeito de Rüsch, multiplica o fcd na relação constitutiva
%           config_draw.def_especifica - desenha deformação especifica do momento maximo ma primeira etapa, false or true
%           config_draw.estado_def - desenha deformação inicial, false or true
%           config_draw.def_ini_pos_tot - desenha deformação inicial, posterior e final, false or true


[alfa_ci,lambdai,Epcui,n_conci,Epc2i,fcdi]             = func_parametros_concreto(fcki,gama_c);
[alfa_ct1e,lambdat1e,Epcut1e,n_conct1e,Epc2t1e,fcdt1e] = func_parametros_concreto(fckt1e,gama_c);
[alfa_ct2e,lambdat2e,Epcut2e,n_conct2e,Epc2t2e,fcdt2e] = func_parametros_concreto(fckt2e,gama_c);


situacao=true;
msg_erro='sem erro';


Mrd=0;

vmaxl=max(secaol(:,2));
vminl=min(secaol(:,2));
vmaxll=max(secaoll(:,2));
vminll=min(secaoll(:,2));
dif_cg=vminll-vminl;

dll=vmaxll-min(apll.y);  %metros
hlj=(max(secaolj(:,2))-min(secaolj(:,2)));
dl=dll-hlj;
halfal=(max(secaolg(:,2))-min(secaolg(:,2)));
halfall=halfal+hlj;

%Zerando area de aço ativo da laje - Colocar uma barra só de área nula
aalllj=aall;
aalllj.A(:)=0;
%Zerando area de aço passivo da laje - Colocar uma barra só de área nula
aplllj=apll;
aplllj.A(:)=0;
for i=1:1:aplllj.n
    aplllj.camada(i).As=0;
end

%% Determina o momento resistente da longarina

[Mrd_lg,~,situacao,msg_erro] = calc_Mrd(secaol,fcki,gama_c,apl,aal,0,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);

%% Determina o estado de deformação da longarina
% Se o momento resistente da longarina for maior que a carga da concretagem

if Mrd_lg<=Mg2e
    situacao=false;
    msg_erro=['Longarina sozinha não resiste solicitação de concretagem da laje'];
else
    [EpA_ini,Epap_ini,situacao,msg_erro] = det_estado_deformacao(secaol,fcki,gama_c,apl,aal,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd,config_draw);
end



%% Encontrar Nrd máximo e Nrd mínimo da seção composta
if situacao
    [Nrdmax,Nrdmin] = Nrdmax_Nrdmin2e(secaolj,secaolg,EpA_ini,Epap_ini,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
end

%% Determinar quais os regiões limites do problema
if situacao
    if and(Nrdmin<=Nsd,Nsd<=Nrdmax)
        
        %Cálculo do EpC_pos21, ou seja, deformação posterior no posto C que
        %nulifica as deformações na situação de deformação total
        k_ini=(Epap_ini-EpA_ini)/dl/1000;%metros
        EpC_ini=k_ini*1000*((halfal-dl))+Epap_ini;
        EpC_tot21=0;%limite região 2-1
        EpC_pos21=EpC_tot21-EpC_ini;
        %Calculo das deformações EpA_ini32B e EpA_ini21B, ou seja, deformações na
        %interface longarina-laje do limite das regiões 3-2 e 2-1 para o ponto B
        EpA_pos_max=10-EpA_ini;
        Epap_pos_max=10-Epap_ini;
        EpA_pos_min=(-Epcut1e)-EpA_ini;
        
        k32B=((Epap_pos_max)-(-Epcut2e))/dll/1000;
        EpA_pos32B=hlj*k32B*1000+(-Epcut2e);
        k21B=((EpC_pos21)-(-Epcut2e))/halfall/1000;
        EpA_pos21B=hlj*k21B*1000+(-Epcut2e);
        
        EpA_ini32B=(-Epcut1e)-EpA_pos32B;
        EpA_ini21B=(-Epcut1e)-EpA_pos21B;
        
        k32A=((Epap_pos_max)-(EpA_pos_min))/(dl)/1000;
        k21A=((EpC_pos21)-(EpA_pos_min))/(halfal)/1000;
        
        
        if EpA_ini>EpA_ini21B
            %Região 3 e 2
            %% Normal no limite da região 3-2
            EpB_pos=(-Epcut2e);
            Epap_pos=Epap_pos_max;
            [NR32,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            %% Determina região
            if NR32<0%Se NR32<0, significa que compressão esta ganhando então para comprimir menos a resposta esta na região 3
                %Região 3
                k_sup=((Epap_pos_max)-(EpA_pos_max))/dl/1000;
                k_inf=k32B;
                ypv=dll;
                Eppv=Epap_pos_max;
                %Soma_N_ant=Nrdmax;
            else%SeNão região 2.
                %Região 2
                k_sup=k32B;
                k_inf=k21B;
                ypv=0;
                Eppv=(-Epcut2e);
                %Soma_N_ant=NR32;
            end
        elseif EpA_ini>EpA_ini32B
            %Região 3, 2 e 2a
            %Calcular normal no limite 3-2
            %% Normal no limite da região 3-2
            EpB_pos=(-Epcut2e);
            Epap_pos=Epap_pos_max;
            [NR32,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            %% Normal no limite da região 2-2a
            EpB_pos=(-Epcut2e);
            k22a=(EpA_pos_min-(-Epcut2e))/hlj/1000;
            Epap22a=dll*k22a*1000+(-Epcut2e);
            Epap_pos=Epap22a;
            [NR22a,~] =equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            %% Determina região
            if NR32<0%Se NR32<0 a resposta esta na região 3
                %Região 3
                k_sup=((Epap_pos_max)-(EpA_pos_max))/dl/1000;
                k_inf=k32B;
                ypv=dll;
                Eppv=Epap_pos_max;
                %Soma_N_ant=Nrdmax;
            elseif NR22a<0%SeNãoSe NR22a<0 a resposta esta na região 2
                %Região 2
                k_sup=k32B;
                k_inf=k22a;
                ypv=0;
                Eppv=(-Epcut2e);
                %Soma_N_ant=NR32;
            else%SeNão a resposta esta na região 2a
                %Região 2a
                k_sup=k22a;
                k_inf=k21A;
                ypv=hlj;
                Eppv=EpA_pos_min;
                %Soma_N_ant=NR22a;
            end
        else
            %Região 3 e 2a
            %Calcular normal no limite 3-2a
            %% Normal no limite da região 3-2a
            EpB_pos32A=-hlj*k32A*1000+EpA_pos_min;
            EpB_pos=EpB_pos32A;
            Epap_pos=Epap_pos_max;
            [NR32a,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            
            %% Determina região
            if NR32a<0 %Se NR32a<0 a resposta esta na região 3
                %Região 3
                k_sup=((Epap_pos_max)-(EpA_pos_max))/dll/1000;
                k_inf=k32A;
                ypv=dll;
                Eppv=Epap_pos_max;
                %Soma_N_ant=Nrdmax;
            else%SeNão a resposta esta na região 2a
                %Região 2a
                k_sup=k32A;
                k_inf=k21A;
                ypv=hlj;
                Eppv=EpA_pos_min;
                %Soma_N_ant=NR32a;
            end
        end
        %% Equilibrio das forças e determinação do Mrd
        conttestes=0;
        limite_soma_N=0.001;
        limite_iteracoes=200;
        Soma_N=limite_soma_N+1;
        ak=min([k_inf k_sup]);
        EpB_pos=ak*1000*(0-ypv)+Eppv;
        Epap_pos=ak*1000*(dll-ypv)+Eppv;
        [fak,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
        bk=max([k_inf k_sup]);
        EpB_pos=bk*1000*(0-ypv)+Eppv;
        Epap_pos=bk*1000*(dll-ypv)+Eppv;
        [fbk,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
        while (abs(Soma_N)>limite_soma_N && conttestes<limite_iteracoes)
            conttestes=conttestes+1;
            ck=bk-((fbk*(bk-ak))/(fbk-fak));
            EpB_pos=ck*1000*(0-ypv)+Eppv;
            Epap_pos=ck*1000*(dll-ypv)+Eppv;
            [Soma_N,Mrd] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            
            V=[fak Soma_N];
            ak_ck_mesmo_simal=~any(diff(sign(V(V~=0))));
            if ak_ck_mesmo_simal
                ak=ck;
                k_pos=ck;
                EpB_pos=ak*1000*(0-ypv)+Eppv;
                Epap_pos=ak*1000*(dll-ypv)+Eppv;
                [fak,Mrd] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            else
                bk=ck;
                k_pos=ck;
                EpB_pos=bk*1000*(0-ypv)+Eppv;
                Epap_pos=bk*1000*(dll-ypv)+Eppv;
                [fbk,Mrd] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcdt1e,n_conct1e,Epcut1e,Epc2t1e,fcdt2e,n_conct2e,Epcut2e,Epc2t2e,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            end
        end
        if isnan(Soma_N)
            situacao=false;
            msg_erro=['Somatorio de normal não é um numero'];
        end
        if conttestes==limite_iteracoes
            situacao=false;
            msg_erro=['Equação de equilibrio não convergiu dentro do limite de iterações'];
        end
        %% Desenho
        
        if situacao
            if config_draw.def_ini_pos_tot
                figure
                
                ax1=subplot(1,3,1);
                ax1.Position=[.05/3 0.0400 .9/3 0.9500];
                ax2=subplot(1,3,2);
                ax2.Position=[1/3+.05/3 0.0400 .9/3 0.9500];
                ax3=subplot(1,3,3);
                ax3.Position=[2/3+.05/3 0.0400 .9/3 0.9500];
                fa=ax1;
                draw_def_especifica_ini
                fa=ax2;
                draw_def_especifica_pos
                fa=ax3;
                draw_def_especifica_tot
                drawnow
            end
        end
        
    else
        Mrd=0;
        situacao=false;
        msg_erro=['Esforço normal inadmissível'];
    end
end

end

