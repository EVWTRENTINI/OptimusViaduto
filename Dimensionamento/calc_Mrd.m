function [Mrd,xa,situacao,msg_erro] = calc_Mrd(secao,fck,gama_c,ap,aa,Nsd,Es,fpyd,fptd,Eppu,Ep,fyd,config_draw)
%Calcula o momento resistente da seção em função do Normal solicitante
%   Esta função utiliza a integral das tensões do diagrama parabola 
%   retangulo da NBR:6118:2014 apresentadas por Leonardo Silva (2015)
parametros_concreto
[nv,~]=size(secao);

vmax=max(secao(:,2));
vmin=min(secao(:,2));

halfa=vmax-vmin;
%d=halfa-cgas-c;
d=vmax-min(ap.y);  

dl=halfa-d;%verificar se ainda é utilizado
delta=dl/halfa;%verificar se ainda é utilizado


%% Encontrar Nrd máximo e Nrd mínimo

situacao=true;
msg_erro='sem erro';
mult_fcd=.85;

%tração maxima em kN
%compressão maxima em kN
[Nrdmax,Nrdmin] = Nrdmax_Nrdmin(secao,ap,aa,fcd,Epc2,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);

%% Cálculo do Momento resistente da seção

if and(Nrdmin<=Nsd,Nsd<=Nrdmax)
    % Verifica somatorio de força entre a região 1~2
    xa=halfa;%do nó mais comprimido até a LN em metros
    EpA=-Epcu;% ‰
    k=-EpA/1000/xa;
    Epap=(vmax-min(ap.y))*k*1000+EpA;
    [NR12,~] = equacao_equilibrio(fcd,n_conc,EpA,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
    
    % Verifica somatorio de força entre a região 2~3
    xa=d/(10+Epcu)*Epcu;
    EpA=-Epcu;
    
    [NR23,~] = equacao_equilibrio(fcd,n_conc,EpA,xa,10,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);

    
    
    conttestes=0;
    limite_soma_N=0.001;
    limite_iteracoes=100;
    Soma_N=limite_soma_N+1;
    if NR23<=0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%'REGIÃO 3'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                       Método da Secante
        %A variavel é xa
        x_ant=0;
        %x_atu=x_ant+0.00001;
        x_atu=d/(10+Epcu)*Epcu;
        EpA=0;
        [Soma_N_ant,~] = equacao_equilibrio(fcd,n_conc,EpA,x_ant,10,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
        while (abs(Soma_N)>limite_soma_N && conttestes<limite_iteracoes)
            conttestes=conttestes+1;
            xa=x_atu;
            EpA=-(10/(d-xa)*xa);
            k=-EpA/1000/xa;
            Epap=(vmax-min(ap.y))*k*1000+EpA;
            [Soma_N,Mrd] = equacao_equilibrio(fcd,n_conc,EpA,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            
            x_atu=x_atu-(Soma_N*(x_atu-x_ant))/(Soma_N-Soma_N_ant);
            x_ant=xa;
            if x_ant>d/(10+Epcu)*Epcu
                x_ant=d/(10+Epcu)*Epcu;
            end
            Soma_N_ant=Soma_N;
        end
    elseif NR12<=0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%'REGIAO 2'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                     Método da bisseção
        %A variavel é xa
        ak=d/(10+Epcu)*Epcu;
        EpA=-Epcu;%mesmo nessa regiao
        k=-EpA/1000/ak;
        Epap=(vmax-min(ap.y))*k*1000+EpA;
        [fak,Mrd] = equacao_equilibrio(fcd,n_conc,EpA,ak,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
        bk=halfa;
        %EpA=-Epcu;%mesmo nessa regiao
        k=-EpA/1000/bk;
        Epap=(vmax-min(ap.y))*k*1000+EpA;
        [fbk,Mrd] = equacao_equilibrio(fcd,n_conc,EpA,bk,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
        while (abs(Soma_N)>limite_soma_N && conttestes<limite_iteracoes)
            conttestes=conttestes+1;
            ck=bk-((fbk*(bk-ak))/(fbk-fak));
            %EpA=-Epcu;%mesmo nessa regiao
            k=-EpA/1000/ck;  
            Epap=(vmax-min(ap.y))*k*1000+EpA;
            [Soma_N,Mrd] = equacao_equilibrio(fcd,n_conc,EpA,ck,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            
            V=[fak Soma_N];
            ak_ck_mesmo_simal=~any(diff(sign(V(V~=0))));
            if  ak_ck_mesmo_simal
                ak=ck;
                %EpA=-Epcu;%mesmo nessa regiao
                k=-EpA/1000/ak;
                Epap=(vmax-min(ap.y))*k*1000+EpA;
                [fak,Mrd] = equacao_equilibrio(fcd,n_conc,EpA,ak,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            else
                bk=ck;
                %EpA=-Epcu;%mesmo nessa regiao
                k=-EpA/1000/bk;
                Epap=(vmax-min(ap.y))*k*1000+EpA;
                [fbk,Mrd] = equacao_equilibrio(fcd,n_conc,EpA,bk,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            end
        end
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%'REGIAO 1'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %            Método da bisseção em EpA entre Epcu e Epc2
        
        %A variavel é EpA
        C=(Epcu-Epc2)*halfa/Epcu;
        
        ak=-Epc2;
        xa=-ak*C/(-ak-Epc2);
        k=-ak/1000/xa;
        Epap=(vmax-min(ap.y))*k*1000+ak;
        [fak,Mrd] = equacao_equilibrio(fcd,n_conc,ak,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
        
        bk=-Epcu;
        xa=-bk*C/(-bk-Epc2);
        k=-bk/1000/xa;
        Epap=(vmax-min(ap.y))*k*1000+bk;
        [fbk,Mrd] = equacao_equilibrio(fcd,n_conc,bk,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
        
        while (abs(Soma_N)>limite_soma_N && conttestes<limite_iteracoes)
            
            conttestes=conttestes+1;
            ck=bk-((fbk*(bk-ak))/(fbk-fak));
            xa=-ck*C/(-ck-Epc2);
            k=-ck/1000/xa;
            Epap=(vmax-min(ap.y))*k*1000+ck;
            [Soma_N,Mrd] = equacao_equilibrio(fcd,n_conc,ck,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            
            V=[fak Soma_N];
            ak_ck_mesmo_simal=~any(diff(sign(V(V~=0))));
            if ak_ck_mesmo_simal
                ak=ck;
                xa=-ak*C/(-ak-Epc2);
                k=-ak/1000/xa;
                Epap=(vmax-min(ap.y))*k*1000+ak;
                [fak,Mrd] = equacao_equilibrio(fcd,n_conc,ak,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            else
                bk=ck;
                xa=-bk*C/(-bk-Epc2);
                k=-bk/1000/xa;
                Epap=(vmax-min(ap.y))*k*1000+bk;
                [fbk,Mrd] = equacao_equilibrio(fcd,n_conc,bk,xa,Epap,Epcu,Epc2,secao,vmax,ap,aa,Nsd,0,Es,fpyd,fptd,Eppu,Ep,fyd,mult_fcd);
            end
        end
    end
    if isnan(Soma_N)
        situacao=false;
        msg_erro=['Somatorio de normal não é um numero'];
    end
    if conttestes==limite_iteracoes
        situacao=false;
        msg_erro=['Equação de equilibrio não convergiu dentro do limite de iterações.'];
    end
    
    
    
    
else
    Mrd='erro!';
    xa=0;
    situacao=false;
    msg_erro=['Esforço normal inadmissível.'];
end
%conttestes
if config_draw.def_especifica
    draw_def_especifica_v2
end
% draw_def_especifica_v2
end

