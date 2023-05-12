function [ENVTRAV, ENVPIL, ENVFUS, COMBFUNDA] = ENVCOMB_viaduto_exceto_longarinas(viaduto, info, Nx, tot_ponto, Vy, Vz, Tx, Mz, My)
CNF=1-.05*(viaduto.nfaixa-2);
if CNF<0.9
    CNF=0.9;
end

CIA=1.25;



[~,nvao]=size(info.longarinas.vao);

config_Mc;


%% Envoltória Especifica para travessas
Mctrav=Mc;
Mctrav(:,2)=Mctrav(:,2)*CIA;

for k=1:viaduto.n_apoios
    barras=info.travessas.apoio(k).membros;
    %Caso necessite de otimização, pode se aproveitar da simetria da
    %travessa e realizar a envoltória de apenas metade da travessa
   
    for n=barras
        % O certo seria substituir (n-barras(1)+1) por um contador 18/08/2021
        %[ENV] = smartENV(Fk,sp,Mc,info)
        ENVbar=smartENV(Vz(1:tot_ponto(n),n,:),tot_ponto(n),Mctrav,info);
        ENVTRAV.apoio(k).barra(n-barras(1)+1).MAX.Vz(1:tot_ponto(n))=ENVbar.MAX;
        ENVTRAV.apoio(k).barra(n-barras(1)+1).MIN.Vz(1:tot_ponto(n))=ENVbar.MIN;
        
        ENVbar=smartENV(Tx(1:tot_ponto(n),n,:),tot_ponto(n),Mctrav,info);
        ENVTRAV.apoio(k).barra(n-barras(1)+1).MAX.Tx(1:tot_ponto(n))=ENVbar.MAX;
        ENVTRAV.apoio(k).barra(n-barras(1)+1).MIN.Tx(1:tot_ponto(n))=ENVbar.MIN;
       
        ENVbar=smartENV(My(1:tot_ponto(n),n,:),tot_ponto(n),Mctrav,info);
        ENVTRAV.apoio(k).barra(n-barras(1)+1).MAX.My(1:tot_ponto(n))=ENVbar.MAX;
        ENVTRAV.apoio(k).barra(n-barras(1)+1).MIN.My(1:tot_ponto(n))=ENVbar.MIN;
    end
end

%% Combinações ELU para pilares
%Resolvendo só para metade pois esta usando a simetria

[sMc,~]=size(Mc);
Mcpil=Mc;
Mcpil(:,2)=Mcpil(:,2)*CIA*CNF;%É NECESSARIO INCLUIR CNF?

% Envoltória de esforço
for k=1:viaduto.n_apoios
    for j=1:ceil(viaduto.apoio(k).n_pilares/2)%simetria
        barras=info.pilares.apoio(k).pilar(j).membros;
        barras=barras(2:end);% Primeira barra é excluida pq é rigida
        for n=barras
            ENVbar=smartENV(Nx(1:tot_ponto(n),n,:),tot_ponto(n),Mcpil,info);
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MAX.Nx(1:tot_ponto(n))=ENVbar.MAX;
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MIN.Nx(1:tot_ponto(n))=ENVbar.MIN;
            
            ENVbar=smartENV(Vy(1:tot_ponto(n),n,:),tot_ponto(n),Mcpil,info);
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MAX.Vy(1:tot_ponto(n))=ENVbar.MAX;
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MIN.Vy(1:tot_ponto(n))=ENVbar.MIN;
            
            ENVbar=smartENV(Vz(1:tot_ponto(n),n,:),tot_ponto(n),Mcpil,info);
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MAX.Vz(1:tot_ponto(n))=ENVbar.MAX;
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MIN.Vz(1:tot_ponto(n))=ENVbar.MIN;
            
            ENVbar=smartENV(Tx(1:tot_ponto(n),n,:),tot_ponto(n),Mcpil,info);
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MAX.Tx(1:tot_ponto(n))=ENVbar.MAX;
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MIN.Tx(1:tot_ponto(n))=ENVbar.MIN;
            
        end
    end
end

% Envoltória de momento absoluto máximo

margem_refinamento=5*pi/180;
n_pontos_refinamento=8;%NECESSARIAMENTE PAR
for k=1:viaduto.n_apoios
    for j=1:ceil(viaduto.apoio(k).n_pilares/2)%simetria
        barras=info.pilares.apoio(k).pilar(j).membros;
        barras=barras(2:end);% Primeira barra é excluida pq é rigida
        Msd=zeros(viaduto.n_apoios,ceil(viaduto.apoio(k).n_pilares/2),length(barras),2);%(apoio,pilar,barra,nó)
        theta=zeros(viaduto.n_apoios,ceil(viaduto.apoio(k).n_pilares/2),length(barras));
        for ib=1:length(barras)
            nos=[1 tot_ponto(barras(ib))];
            for in=1:2
                Mzk=reshape(Mz(nos(in),barras(ib),:),1,[]);
                Myk=reshape(My(nos(in),barras(ib),:),1,[]);
                
                %Primeira passada grosseira
                theta_proc=0:30*pi/180:360*pi/180;
                [Msd(k,j,ib,in),theta(k,j,ib)] = momento_max_abs(theta_proc,Mzk,Myk,Mcpil,info.LC);
                
                %Segunda passada refinada
                theta_proc=theta(k,j,ib)-margem_refinamento/2:margem_refinamento/n_pontos_refinamento:theta(k,j,ib)+margem_refinamento/2;
                [Msd(k,j,ib,in),theta(k,j,ib)] = momento_max_abs(theta_proc,Mzk,Myk,Mcpil,info.LC);
            end
            ENVPIL.apoio(k).pilar(j).barra(ib).MAX.Mabs=reshape((Msd(k,j,ib,:)),1,[]);
        end
    end
end

%% Combinações ELS para pilares
        %PP %VT_MULT %RFT %VT  %CEP
McpilQP=[1.00  0.30  0.30 0.00 0.00];
% Envoltória de esforço normal
for k=1:viaduto.n_apoios
    for j=1:ceil(viaduto.apoio(k).n_pilares/2)%simetria
        barras=info.pilares.apoio(k).pilar(j).membros;
        barras=barras(2:end);% Primeira barra é excluida pq é rigida
        for n=barras
            ENVbar=smartENV(Nx(1:tot_ponto(n),n,:),tot_ponto(n),McpilQP,info);
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MAX.NxQP(1:tot_ponto(n))=ENVbar.MAX;
            ENVPIL.apoio(k).pilar(j).barra(n-barras(1)+1).MIN.NxQP(1:tot_ponto(n))=ENVbar.MIN;
        end
    end
end

margem_refinamento=5*pi/180;
n_pontos_refinamento=8;%NECESSARIAMENTE PAR
for k=1:viaduto.n_apoios
    for j=1:ceil(viaduto.apoio(k).n_pilares/2)%simetria
        barras=info.pilares.apoio(k).pilar(j).membros;
        barras=barras(2:end);% Primeira barra é excluida pq é rigida
        Msd=zeros(viaduto.n_apoios,ceil(viaduto.apoio(k).n_pilares/2),length(barras),2);%(apoio,pilar,barra,nó)
        theta=zeros(viaduto.n_apoios,ceil(viaduto.apoio(k).n_pilares/2),length(barras));
        for ib=1:length(barras)
            nos=[1 tot_ponto(barras(ib))];
            for in=1:2
                Mzk=reshape(Mz(nos(in),barras(ib),:),1,[]);
                Myk=reshape(My(nos(in),barras(ib),:),1,[]);
                
                %Primeira passada grosseira
                theta_proc=0:30*pi/180:360*pi/180;
                [Msd(k,j,ib,in),theta(k,j,ib)] = momento_max_abs(theta_proc,Mzk,Myk,McpilQP,info.LC);
                
                %Segunda passada refinada
                theta_proc=theta(k,j,ib)-margem_refinamento/2:margem_refinamento/n_pontos_refinamento:theta(k,j,ib)+margem_refinamento/2;
                [Msd(k,j,ib,in),theta(k,j,ib)] = momento_max_abs(theta_proc,Mzk,Myk,McpilQP,info.LC);
            end
            ENVPIL.apoio(k).pilar(j).barra(ib).MAX.MabsQP=reshape((Msd(k,j,ib,:)),1,[]);
        end
    end
end



%% Combinações para Fustes
%Resolvendo só para metade pois esta usando a simetria
[sMc,~]=size(Mc);
Mcfuste=Mc;
Mcfuste(:,2)=Mcfuste(:,2)*CIA*CNF;%É NECESSARIO INCLUIR CNF?

for k=1:viaduto.n_apoios
    for j=1:ceil(viaduto.apoio(k).n_pilares/2)%simetria
        barras=info.fustes.apoio(k).fuste(j).membros;
        for n=barras
            % O certo seria substituir (n-barras(1)+1) por um contador 18/08/2021
            %[ENV] = smartENV(Fk,sp,Mc,info)
            ENVbar=smartENV(Nx(1:tot_ponto(n),n,:),tot_ponto(n),Mcfuste,info);
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MAX.Nx(1:tot_ponto(n))=ENVbar.MAX;
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MIN.Nx(1:tot_ponto(n))=ENVbar.MIN;
            
            ENVbar=smartENV(Vy(1:tot_ponto(n),n,:),tot_ponto(n),Mcfuste,info);
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MAX.Vy(1:tot_ponto(n))=ENVbar.MAX;
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MIN.Vy(1:tot_ponto(n))=ENVbar.MIN;
            
            ENVbar=smartENV(Vz(1:tot_ponto(n),n,:),tot_ponto(n),Mcfuste,info);
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MAX.Vz(1:tot_ponto(n))=ENVbar.MAX;
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MIN.Vz(1:tot_ponto(n))=ENVbar.MIN;
            
            ENVbar=smartENV(Tx(1:tot_ponto(n),n,:),tot_ponto(n),Mcfuste,info);
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MAX.Tx(1:tot_ponto(n))=ENVbar.MAX;
            ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MIN.Tx(1:tot_ponto(n))=ENVbar.MIN;
            
%              ENVbar=smartENV(My(1:tot_ponto(n),n,:),tot_ponto(n),Mcfuste,info);
%              ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MAX.My(1:tot_ponto(n))=ENVbar.MAX;
%              ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MIN.My(1:tot_ponto(n))=ENVbar.MIN;
%              
%              ENVbar=smartENV(Mz(1:tot_ponto(n),n,:),tot_ponto(n),Mcfuste,info);
%              ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MAX.Mz(1:tot_ponto(n))=ENVbar.MAX;
%              ENVFUS.apoio(k).fuste(j).barra(n-barras(1)+1).MIN.Mz(1:tot_ponto(n))=ENVbar.MIN;
             
        end
    end
end

% Momento máximo
margem_refinamento=5*pi/180;
n_pontos_refinamento=8;%NECESSARIAMENTE PAR
for k=1:viaduto.n_apoios
    for j=1:ceil(viaduto.apoio(k).n_pilares/2)%simetria
        barras=info.fustes.apoio(k).fuste(j).membros;
        Msd=zeros(viaduto.n_apoios,ceil(viaduto.apoio(k).n_pilares/2),length(barras));
        theta=zeros(viaduto.n_apoios,ceil(viaduto.apoio(k).n_pilares/2),length(barras));
        for ib=1:length(barras)
            %['Travessa ' num2str(k) ', fuste ' num2str(j) ', barra ' num2str(ib) '.']
            Mzk=reshape(Mz(1,barras(ib),:),1,[]);
            Myk=reshape(My(1,barras(ib),:),1,[]);
            theta_proc=0:30*pi/180:360*pi/180;
            [Msd(k,j,ib),theta(k,j,ib)] = momento_max_abs(theta_proc,Mzk,Myk,Mcfuste,info.LC);
            
            theta_proc=theta(k,j,ib)-margem_refinamento/2:margem_refinamento/n_pontos_refinamento:theta(k,j,ib)+margem_refinamento/2;
            [Msd(k,j,ib),theta(k,j,ib)] = momento_max_abs(theta_proc,Mzk,Myk,Mcfuste,info.LC);
            ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Mabs=Msd(k,j,ib);
        end
    end
end

%% Fundação

Mcfunda=[1 1 1 1 1];
[sMc,~]=size(Mcfunda);


for k=1:viaduto.n_apoios
    for j=1:ceil(viaduto.apoio(k).n_pilares/2)%simetria
        barras=info.fustes.apoio(k).fuste(j).membros;
        [~,n_barras_fundacao]=size(barras);
        [lista_LC_fundacao] = detec_contr_esf(-Nx(tot_ponto(barras(n_barras_fundacao)),barras(n_barras_fundacao),:),info);
        cont=0;
        for iMc=1:sMc
            cont=cont+1;
            COMBFUNDA(cont).apoio(k).fundacao(j).Nx=lista_LC2COMB(Nx(tot_ponto(barras(n_barras_fundacao)),barras(n_barras_fundacao),:),lista_LC_fundacao,Mcfunda(iMc,:),info);
        end
    end
end
end