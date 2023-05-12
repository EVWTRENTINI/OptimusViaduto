function [info,situacao,msg_erro]=dim_blocos(ENVFUS,viaduto,info,config_draw)
%Dimensina todos os blocos do viaduto
situacao=true;
msg_erro='sem erro';

A=cell(1,viaduto.n_apoios);
H=cell(1,viaduto.n_apoios);
Asxy=cell(1,viaduto.n_apoios);
Asxz_yz=cell(1,viaduto.n_apoios);

for k=1:viaduto.n_apoios
    tf=ceil(viaduto.apoio(k).n_pilares/2);%simetria
    A{k}=zeros(1,tf);
    H{k}=zeros(1,tf);
    Asxy{k}=zeros(1,tf);
    for j=1:tf%simetria
        diam_fuste=viaduto.apoio(k).fustes.d;
        diam_pilar=viaduto.apoio(k).pilares.d;
        fi_f=max([diam_fuste diam_pilar]);
        ap=min([diam_fuste diam_pilar]);
        Nsd=-ENVFUS.apoio(k).fuste(j).barra(1).MIN.Nx(1)/1000;%kN

        [A{k}(j),H{k}(j),Asxy{k}(j),Asxz_yz{k}(j)]=dim_bloco(Nsd,fi_f,ap);
        
        info.blocos.apoio(k).bloco(j).A=A{k}(j);
        info.blocos.apoio(k).bloco(viaduto.apoio(k).n_pilares-(j-1)).A=A{k}(j);
        info.blocos.apoio(k).bloco(j).H=H{k}(j);
        info.blocos.apoio(k).bloco(viaduto.apoio(k).n_pilares-(j-1)).H=H{k}(j);
        info.blocos.apoio(k).bloco(j).Asxy=Asxy{k}(j);
        info.blocos.apoio(k).bloco(viaduto.apoio(k).n_pilares-(j-1)).Asxy=Asxy{k}(j);
        info.blocos.apoio(k).bloco(j).Asxz_yz=Asxz_yz{k}(j);
        info.blocos.apoio(k).bloco(viaduto.apoio(k).n_pilares-(j-1)).Asxz_yz=Asxz_yz{k}(j);
    end
    
end


end