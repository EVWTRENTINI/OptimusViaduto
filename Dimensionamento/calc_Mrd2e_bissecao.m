function [Mrd,situacao,msg_erro]=calc_Mrd2e(secaol,secaoll,secaolg,secaolj,fck,apl,apll,aal,aall,Nsd,Mg2e,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw)
%Calcula o momento resistente da seção em função da normal solicitante
%considerando o processo construitivo de concretagem em duas etapas.
%   Esta função utiliza a integral das tensões do diagrama parabola
%   retangulo da NBR:6118:2014 apresentadas por Leonardo Silva (2015)
parametros_concreto

situacao=true;
msg_erro='sem erro';
mult_fcd=.85;

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

[Mrd_lg,~,situacao,msg_erro] = calc_Mrd(secaol,fck,apl,aal,0,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw);

%% Determina o estado de deformação da longarina
% Se o momento resistente da longarina for maior que a carga da concretagem
if Mrd_lg<=Mg2e
    situacao=false;
    msg_erro=['Longarina sozinha não resiste solicitação de concretagem da laje'];
else
    [EpA_ini,Epap_ini,situacao,msg_erro] = det_estado_deformacao(secaol,fck,apl,aal,Nsd,Mg2e,viaduto,config_draw);
end


%% Encontrar Nrd máximo e Nrd mínimo da seção composta
if situacao
    [Nrdmax,Nrdmin] = Nrdmax_Nrdmin2e(secaolj,secaolg,EpA_ini,Epap_ini,fcd,n_conc,Epcu,Epc2,vmaxll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
end

%% Determinar quais os regiões limites do problema
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
    EpA_pos_min=(-Epcu)-EpA_ini;
    
    k32B=((Epap_pos_max)-(-Epcu))/dll/1000;
    EpA_pos32B=hlj*k32B*1000+(-Epcu);
    k21B=((EpC_pos21)-(-Epcu))/halfall/1000;
    EpA_pos21B=hlj*k21B*1000+(-Epcu);
        
    EpA_ini32B=(-Epcu)-EpA_pos32B;
    EpA_ini21B=(-Epcu)-EpA_pos21B;
    
    k32A=((Epap_pos_max)-(EpA_pos_min))/(dl)/1000;
    k21A=((EpC_pos21)-(EpA_pos_min))/(halfal)/1000;

  
    if EpA_ini>EpA_ini21B
        %Região 3 e 2
        %% Normal no limite da região 3-2
        EpB_pos=(-Epcu);
        Epap_pos=Epap_pos_max;
        [NR32,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcd,n_conc,Epcu,Epc2,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep);
        %% Determina região
        if NR32<0%Se NR32<0, significa que compressão esta ganhando então para comprimir menos a resposta esta na região 3
            %Região 3
            k_sup=((Epap_pos_max)-(EpA_pos_max))/dl/1000;
            k_inf=k32B;
            ypv=dll;
            Eppv=Epap_pos_max;        
        else%SeNão região 2.
            %Região 2 
             k_sup=k32B;
             k_inf=k21B;
             ypv=0;
             Eppv=(-Epcu);
        end
    elseif EpA_ini>EpA_ini32B
        %Região 3, 2 e 2a
        %Calcular normal no limite 3-2
        %% Normal no limite da região 3-2
        EpB_pos=(-Epcu);
        Epap_pos=Epap_pos_max;
        [NR32,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcd,n_conc,Epcu,Epc2,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep);
        %% Normal no limite da região 2-2a
        EpB_pos=(-Epcu);
        k22a=(EpA_pos_min-(-Epcu))/hlj/1000;
        Epap22a=dll*k22a*1000+(-Epcu);
        Epap_pos=Epap22a;
        [NR22a,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcd,n_conc,Epcu,Epc2,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep);
        %% Determina região
        if NR32<0%Se NR32<0 a resposta esta na região 3
            %Região 3
            k_sup=((Epap_pos_max)-(EpA_pos_max))/dl/1000;
            k_inf=k32B;
            ypv=dll;
            Eppv=Epap_pos_max;
        elseif NR22a<0%SeNãoSe NR22a<0 a resposta esta na região 2
            %Região 2
            k_sup=k32B;
            k_inf=k22a;
            ypv=0;
            Eppv=(-Epcu);
        else%SeNão a resposta esta na região 2a
            %Região 2a
            k_sup=k22a;
            k_inf=k21A;
            ypv=hlj;
            Eppv=EpA_pos_min;
        end
    else
        %Região 3 e 2a
        %Calcular normal no limite 3-2a
        %% Normal no limite da região 3-2a
        EpB_pos32A=-hlj*k32A*1000+EpA_pos_min;
        EpB_pos=EpB_pos32A;
        Epap_pos=Epap_pos_max;
        [NR32a,~] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcd,n_conc,Epcu,Epc2,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep);
       
        %% Determina região
        if NR32a<0 %Se NR32a<0 a resposta esta na região 3
            %Região 3
            k_sup=((Epap_pos_max)-(EpA_pos_max))/dll/1000;
            k_inf=k32A;
            ypv=dll;
            Eppv=Epap_pos_max;
        else%SeNão a resposta esta na região 2a
            %Região 2a
            k_sup=k32A;
            k_inf=k21A;
            ypv=hlj;
            Eppv=EpA_pos_min;
        end
    end
    %% Equilibrio das forças e determinação do Mrd
    conttestes=0;
    limite_soma_N=0.0001;
    limite_iteracoes=100;
    Soma_N=limite_soma_N+1;
    
    while (abs(Soma_N)>limite_soma_N && conttestes<limite_iteracoes)
        conttestes=conttestes+1;
        k=(k_sup+k_inf)/2;
        EpB_pos=k*1000*(0-ypv)+Eppv;
        Epap_pos=k*1000*(dll-ypv)+Eppv;
        [Soma_N,Mrd] = equacao_equilibrio2e(EpB_pos,Epap_pos,EpA_ini,Epap_ini,Nsd,0,secaolj,secaolg,fcd,n_conc,Epcu,Epc2,vmaxll,hlj,dl,dll,apll,aall,aplllj,aalllj,Es,fpyd,fptd,Eppu,Ep);
        if Soma_N>=0
            k_sup=k;
        else
            k_inf=k;
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
else
    Mrd=0;
    situacao=false;
    msg_erro=['Esforço normal inadmissível'];
end
end

