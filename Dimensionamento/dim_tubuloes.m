function [info,situacao,msg_erro]=dim_tubuloes(COMBFUNDA,Nspt,peso_especifico_solo,viaduto,info,config_draw)

diam=cell(1,viaduto.n_apoios);    %diamtro da base do tubulão em emtros
ht=cell(1,viaduto.n_apoios);      %altura total da base do tubulão incluindo o roda-pé

for k=1:viaduto.n_apoios
    tf=ceil(viaduto.apoio(k).n_pilares/2);%simetria
    diam{k}=zeros(1,tf);
    ht{k}=zeros(1,tf);
    
    for j=1:tf%simetria
        diam_fuste=viaduto.apoio(k).fustes.d;
        x_fund=info.fustes.apoio(k).fuste(j).x_fundacao;
        y_fund=info.fustes.apoio(k).fuste(j).y_fundacao;
        z_fund=info.fustes.apoio(k).fuste(j).z_fundacao;
        z_superficie=viaduto.apoio(k).cota_topo_bloco;

        Nsk=-COMBFUNDA.apoio(k).fundacao(j).Nx/1000;% Esfoço característico em kN
        
        [diam{k}(j),ht{k}(j),tensao_adm,Nspt_bulbo,situacao,msg_erro]=dim_tubulao(Nsk,Nspt,peso_especifico_solo,x_fund,z_fund,diam_fuste,z_superficie);
        if not(situacao) 
            msg_erro=[msg_erro '. Apoio ' num2str(k) ', tubulão ' num2str(j)];
            return; 
        end
        info.tubuloes.apoio(k).tubulao(j).diam=diam{k}(j);
        info.tubuloes.apoio(k).tubulao(viaduto.apoio(k).n_pilares-(j-1)).diam=diam{k}(j);
        info.tubuloes.apoio(k).tubulao(j).ht=ht{k}(j);
        info.tubuloes.apoio(k).tubulao(viaduto.apoio(k).n_pilares-(j-1)).ht=ht{k}(j);
        
        %% desenho
%         hold on
%         text(x_fund+2,y_fund,z_fund,[num2str(Nspt_bulbo) ' golpes, ' num2str(tensao_adm/100) ' kgf/cm²'])
%         text(x_fund+2,y_fund,z_fund,[num2str(tensao_adm/100) ' kgf/cm²'])
        
%         hold off
        
    end
end







end