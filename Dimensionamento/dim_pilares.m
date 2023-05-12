function [info,situacao,msg_erro]=dim_pilares(ENVPIL,viaduto,info,config_draw)
%Dimensina todos os fustes do viaduto
situacao=true;
msg_erro='sem erro';


Asl=cell(1,viaduto.n_apoios);
Ast=cell(1,viaduto.n_apoios);
Aslt=cell(1,viaduto.n_apoios);
fator_amp=cell(1,viaduto.n_apoios);


Es=viaduto.Es;%kN/cm² %modulo de elasticidade aço passivo
fpyd=viaduto.fpyd;%kN/cm² 
fptd=viaduto.fptd;%kN/cm² 
Eppu=viaduto.Eppu;%‰
Ep=viaduto.Ep;%kN/cm² %modulo de elasticidade
fyd=viaduto.fyk/viaduto.gama_s;
abatimento=viaduto.pilares.abatimento;%abatimento do concreto em centimetros;
alfa_flu=viaduto.pilares.alfa_flu;%Endurecimento normal
s=viaduto.pilares.s;% Concreto de cimento CP I e II
delta_t_ef=viaduto.DMLG;%(Data da montagem das longarinas)Período, em dias, durante o qual a temperatura média do ambiente, Ti, pode ser admitida constante.
Umi=viaduto.Umi;%Umidade relativa do ar em %
Ti=viaduto.Ti;%Temperatura média diária do ambiente em graus Celsius

fi_l_max=viaduto.pilares.fi_l_max;%diametro maximo da armadura longitudinal em m
fi_l_min=viaduto.pilares.fi_l_min;%diametro minimo da armadura longitudinal em m
fi_t=viaduto.pilares.fi_t;%diametro da armadura transversal em m


for k=1:viaduto.n_apoios
    nb=length(ENVPIL.apoio(k).pilar(1).barra);
    tp=ceil(viaduto.apoio(k).n_pilares/2);%simetria
    Asl{k}=zeros(tp);
    Ast{k}=zeros(tp);
    Aslt{k}=zeros(tp);
    fator_amp{k}=zeros(tp);
    diam=viaduto.apoio(k).pilares.d;
    fck=viaduto.apoio(k).pilares.fck/1E6;
    gama_c=viaduto.gama_c;
    alfa_e=viaduto.alfa_e;
    gama_f3=viaduto.gama_f3;
    c=viaduto.apoio(k).pilares.c;


    dmag=viaduto.dia_max_agr_grau;

    for j=1:tp%simetria
        %% Esforços
        for i=1:nb
            %ELU
            Nsd_max(i)=max(ENVPIL.apoio(k).pilar(j).barra(i).MAX.Nx);
            Nsd_min(i)=min(ENVPIL.apoio(k).pilar(j).barra(i).MIN.Nx);
            
            Vy_max=max([max(abs(ENVPIL.apoio(k).pilar(j).barra(i).MAX.Vy)) max(abs(ENVPIL.apoio(k).pilar(j).barra(i).MIN.Vy))]);
            Vz_max=max([max(abs(ENVPIL.apoio(k).pilar(j).barra(i).MAX.Vz)) max(abs(ENVPIL.apoio(k).pilar(j).barra(i).MIN.Vz))]);
            Vsd(i)=sqrt(Vy_max^2+Vz_max^2); 
            
            Tx_max(i)=max([max(abs(ENVPIL.apoio(k).pilar(j).barra(i).MAX.Tx)) max(abs(ENVPIL.apoio(k).pilar(j).barra(i).MIN.Tx))]);
            
            Ms1d(i)=max(ENVPIL.apoio(k).pilar(j).barra(i).MAX.Mabs);
            %ELS
            NQP_max(i)=max(ENVPIL.apoio(k).pilar(j).barra(i).MAX.NxQP);
            NQP_min(i)=min(ENVPIL.apoio(k).pilar(j).barra(i).MIN.NxQP);
            
            MQP(i)=max(ENVPIL.apoio(k).pilar(j).barra(i).MAX.MabsQP);
        end
        %ELU
        Nsd_max=-double(max(Nsd_max))/1000;%kN
        Nsd_min=-double(min(Nsd_min))/1000;%kN
        Vsd=double(max(Vsd))/1000;%kN
        Tsd=double(max(Tx_max))/1000;%kN
        Ms1d=double(max(Ms1d))/1000;%kN.m
        %ELS
        NQP_max=-double(max(NQP_max))/1000;%kN
        NQP_min=-double(min(NQP_min))/1000;%kN
        NQP=NQP_min;
        MQP=double(max(MQP))/1000;%kN.m

        %% Dimensionamento a flexão
        metodo_dim_pilar=viaduto.metodo_dim_pilar; 
        
        l=info.pilares.apoio(k).pilar(j).cota_topo-viaduto.apoio(k).cota_topo_bloco;
        l0=l-viaduto.apoio(k).travessa.h/2;
        
        alfa_b=1;%por ser pilar engastado e possuir forças horizontais
        
        
        [Asl{k}(j),Ast{k}(j),Aslt{k}(j),fator_amp{k}(j),situacao,msg_erro] =...
            dim_pilar_engastado_circ(metodo_dim_pilar,diam,l,l0,alfa_b,Ms1d,Vsd,Tsd,Nsd_min,Nsd_max,NQP,MQP,fck,gama_c,alfa_e,gama_f3,c,fi_l_max,fi_l_min,fi_t,dmag,Es,fpyd,fptd,Eppu,Ep,fyd,delta_t_ef,s,alfa_flu,abatimento,Umi,Ti,config_draw);
        if not(situacao)
            msg_erro=[msg_erro '. Apoio ' num2str(k) ', pilar ' num2str(j)];
            return;
        end
        
        

        %% Anotando resultados      
        
        info.pilares.apoio(k).pilar(j).Asl=Asl{k}(j);
        info.pilares.apoio(k).pilar(viaduto.apoio(k).n_pilares-(j-1)).Asl=Asl{k}(j);
        info.pilares.apoio(k).pilar(j).Ast=Ast{k}(j);
        info.pilares.apoio(k).pilar(viaduto.apoio(k).n_pilares-(j-1)).Ast=Ast{k}(j);
        info.pilares.apoio(k).pilar(j).Aslt=Aslt{k}(j);
        info.pilares.apoio(k).pilar(viaduto.apoio(k).n_pilares-(j-1)).Aslt=Aslt{k}(j);
        info.pilares.apoio(k).pilar(j).fator_amp=fator_amp{k}(j);
        info.pilares.apoio(k).pilar(viaduto.apoio(k).n_pilares-(j-1)).fator_amp=fator_amp{k}(j);
    end
end


end