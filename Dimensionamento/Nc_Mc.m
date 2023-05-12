function [Nc,Mc] = Nc_Mc(fcd,n_conc,EpA,xa,Epap,d,Epcu,Epc2,secao,vmax,mult_fcd)
%Força normal e o momento em relação a origem da região de concreto comprimido
%   Realiza a integral das tensões de acordo com a NBR6118:2014 para cada
%   trecho de reta que compoe a seção transversal. Procedimento semelhante
%   ao desenvolvido por Leonardo Silva (2015) do OblqCalco
%% Encontrar cota das divisões da seção transversal
%Se xa=0 e EpA diferente de 0 - curvatura nula, deformação uniforme igual a EpA
%Se xa=0 e EpA=0 - Usar Epap
%Se

k=(Epap-EpA)/d/1000;
if not(abs(EpA-Epap)<1E-10)
    zln=vmax-xa;%Coordenada da linha neutra
    if EpA==0
        zEpc2=zln-((-Epc2)-EpA)/1000/k;
        zEpcu=zln-((-Epcu)-EpA)/1000/k;
    else
        zEpc2=zln+Epc2/-EpA*xa;
        zEpcu=zln+Epcu/-EpA*xa;
    end
    cortar=[zEpcu zEpc2 zln];%valores em que a poligonal vai ser cortada
    
    %% Dividir poligonal da seção transversal
    
    [z,uc]=corta_pol(secao,cortar);
    
    %% Calcula Força e momento resultante do concreto - Nc e Mc
    
    [~,nvc]=size(z);
    Nc=0;
    Mc=0;
    for i=1:nvc-1
        x1=uc(i);
        y1=z(i);
        x2=uc(i+1);
        y2=z(i+1);
        if abs(y1-y2)<1E-10
            Nc1=0;
            Mc1=0;
            Nc2=0;
            Mc2=0;
        else
            c1=(y1*x2-y2*x1)/(y1-y2);
            c2=(x1-x2)/(y1-y2);
            if k>0%Curvatura positiva
                if and(and(y1>=zEpc2,y2>=zEpc2),and(y1<=zEpcu,y2<=zEpcu))%Retangulo
                    [Nc1,Mc1]=Nctr_Mctr(fcd,c1,c2,y1,mult_fcd);%MN
                    [Nc2,Mc2]=Nctr_Mctr(fcd,c1,c2,y2,mult_fcd);%MN*m
                elseif and(and(y1>=zln,y2>=zln),and(y1<=zEpc2,y2<=zEpc2))%Parabola
                    [Nc1,Mc1]=Nctp_Mctp(fcd,zEpc2-zln,n_conc,c1,c2,y1,vmax,xa,mult_fcd);%MN
                    [Nc2,Mc2]=Nctp_Mctp(fcd,zEpc2-zln,n_conc,c1,c2,y2,vmax,xa,mult_fcd);%MN*m
                else
                    Nc1=0;
                    Mc1=0;
                    Nc2=0;
                    Mc2=0;
                end
            else% Curvatura negativa
                if and(and(y1<=zEpc2,y2<=zEpc2),and(y1>=zEpcu,y2>=zEpcu))%Retangulo
                    [Nc1,Mc1]=Nctr_Mctr(fcd,c1,c2,y1,mult_fcd);%MN
                    [Nc2,Mc2]=Nctr_Mctr(fcd,c1,c2,y2,mult_fcd);%MN*m
                elseif and(and(y1<=zln,y2<=zln),and(y1>=zEpc2,y2>=zEpc2))%Parabola
                    [Nc1,Mc1]=Nctp_Mctp(fcd,zEpc2-zln,n_conc,c1,c2,y1,vmax,xa,mult_fcd);%MN
                    [Nc2,Mc2]=Nctp_Mctp(fcd,zEpc2-zln,n_conc,c1,c2,y2,vmax,xa,mult_fcd);%MN*m
                else
                    Nc1=0;
                    Mc1=0;
                    Nc2=0;
                    Mc2=0;
                end
            end
            Nc=Nc+Nc2-Nc1;%MN
            Mc=Mc+Mc2-Mc1;%MN*m
        end
    end
    Nc=-Nc*1E3;%kN
    Mc=Mc*1E3;%kN*m
else
    EpA=(Epap+EpA)/2;%usamédia quando os dois são mto proximos ou iguais
    Nc=0;
    Mc=0;
    [nvc,~]=size(secao);
    for i=1:nvc-1
        x1=secao(i,1);
        y1=secao(i,2);
        x2=secao(i+1,1);
        y2=secao(i+1,2);
        if abs(y1-y2)<1E-10
            Nc1=0;
            Mc1=0;
            Nc2=0;
            Mc2=0;
        else
            c1=(y1*x2-y2*x1)/(y1-y2);
            c2=(x1-x2)/(y1-y2);
            if and((-EpA)>=0,(-EpA)<=Epcu)
                if (-EpA)>Epc2
                    sig_c=fcd;%sem o *0.85
                else
                    sig_c=fcd*(1-(1-(-EpA)/(Epc2))^n_conc);%sem o *0.85
                end
            else
                sig_c=0;
            end

            [Nc1,Mc1]=Nctr_Mctr(sig_c,c1,c2,y1,mult_fcd);%MN
            [Nc2,Mc2]=Nctr_Mctr(sig_c,c1,c2,y2,mult_fcd);%MN*m
            Nc=Nc+Nc2-Nc1;%MN
            Mc=Mc+Mc2-Mc1;%MN*m
        end
    end
    Nc=-Nc*1E3;%kN
    Mc=Mc*1E3;%kN*m
end
end



