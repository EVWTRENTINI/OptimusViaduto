function [info,situacao,msg_erro]=dim_fustes(ENVFUS,viaduto,info,config_draw)
%Dimensina todos os fustes do viaduto
Asl=cell(1,viaduto.n_apoios);
Ast=cell(1,viaduto.n_apoios);
Aslt=cell(1,viaduto.n_apoios);



for k=1:viaduto.n_apoios
    tf=ceil(viaduto.apoio(k).n_pilares/2);%simetria
    tb=length(info.fustes.apoio(k).fuste(1).membros);
    Asl{k}=zeros(tb,tf);
    Ast{k}=zeros(tb,tf);
    Aslt{k}=zeros(tb,tf);
    for j=1:tf%simetria
        fator_amp=info.pilares.apoio(k).pilar(j).fator_amp;
        if not(viaduto.dimensionar_barras_fustes_individualmente)
            % Atribui valor qualquer que existe entre as barras do fuste
            ENVFUSTOTAL.MAX.Mabs = ENVFUS.apoio(k).fuste(j).barra(1).MAX.Mabs;
            ENVFUSTOTAL.MAX.Nx = ENVFUS.apoio(k).fuste(j).barra(1).MAX.Nx(1);
            ENVFUSTOTAL.MIN.Nx = ENVFUS.apoio(k).fuste(j).barra(1).MIN.Nx(1);
            ENVFUSTOTAL.MAX.Vy = ENVFUS.apoio(k).fuste(j).barra(1).MAX.Vy(1);
            ENVFUSTOTAL.MIN.Vy = ENVFUS.apoio(k).fuste(j).barra(1).MIN.Vy(1);
            ENVFUSTOTAL.MAX.Vz = ENVFUS.apoio(k).fuste(j).barra(1).MAX.Vz(1);
            ENVFUSTOTAL.MIN.Vz = ENVFUS.apoio(k).fuste(j).barra(1).MIN.Vz(1);
            ENVFUSTOTAL.MAX.Tx = ENVFUS.apoio(k).fuste(j).barra(1).MAX.Tx(1);
            ENVFUSTOTAL.MIN.Tx = ENVFUS.apoio(k).fuste(j).barra(1).MIN.Tx(1);
        end
        for ib=1:tb
            if not(viaduto.dimensionar_barras_fustes_individualmente)
                % Atribui valor qualquer que existe entre as barras do fuste
                % Subistitui o valor qualquer por o maior entre o existente e o analisado
                if ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Mabs > ENVFUSTOTAL.MAX.Mabs
                    ENVFUSTOTAL.MAX.Mabs = ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Mabs;
                end
                if max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Nx) > ENVFUSTOTAL.MAX.Nx
                    ENVFUSTOTAL.MAX.Nx = max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Nx);
                end
                if min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Nx) < ENVFUSTOTAL.MIN.Nx
                    ENVFUSTOTAL.MIN.Nx = min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Nx);
                end
                if max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Vy) > ENVFUSTOTAL.MAX.Vy
                    ENVFUSTOTAL.MAX.Vy = max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Vy);
                end
                if min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Vy) < ENVFUSTOTAL.MIN.Vy
                    ENVFUSTOTAL.MIN.Vy = min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Vy);
                end
                if max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Vz) > ENVFUSTOTAL.MAX.Vz
                    ENVFUSTOTAL.MAX.Vz = max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Vz);
                end
                if min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Vz) < ENVFUSTOTAL.MIN.Vz
                    ENVFUSTOTAL.MIN.Vz = min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Vz);
                end
                if max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Tx) > ENVFUSTOTAL.MAX.Tx
                    ENVFUSTOTAL.MAX.Tx = max(ENVFUS.apoio(k).fuste(j).barra(ib).MAX.Tx);
                end
                if min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Tx) < ENVFUSTOTAL.MIN.Tx
                    ENVFUSTOTAL.MIN.Tx = min(ENVFUS.apoio(k).fuste(j).barra(ib).MIN.Tx);
                end
            end

            if viaduto.dimensionar_barras_fustes_individualmente
                [Asl{k}(ib,j),Ast{k}(ib,j),Aslt{k}(ib,j),situacao,msg_erro] = dim_fuste(ENVFUS.apoio(k).fuste(j).barra(ib),fator_amp,viaduto.apoio(k).fustes,viaduto,config_draw);
                if not(situacao)
                    msg_erro = [msg_erro '. Apoio ' num2str(k) ', fuste ' num2str(j) ', barra ' num2str(ib)]; 
                    return
                end
            end



        end
                   
        if not(viaduto.dimensionar_barras_fustes_individualmente)
            [Asl_total,Ast_total,Aslt_total,situacao,msg_erro] = dim_fuste(ENVFUSTOTAL,fator_amp,viaduto.apoio(k).fustes,viaduto,config_draw);
            if not(situacao)
                msg_erro = [msg_erro '. Apoio ' num2str(k) ', fuste ' num2str(j) '.'];
                return
            end
            info.fustes.apoio(k).fuste(j).Asl(1:tb)=Asl_total;
            info.fustes.apoio(k).fuste(viaduto.apoio(k).n_pilares-(j-1)).Asl(1:tb)=Asl_total;
            info.fustes.apoio(k).fuste(j).Ast(1:tb)=Ast_total;
            info.fustes.apoio(k).fuste(viaduto.apoio(k).n_pilares-(j-1)).Ast(1:tb)=Ast_total;
            info.fustes.apoio(k).fuste(j).Aslt(1:tb)=Aslt_total;
            info.fustes.apoio(k).fuste(viaduto.apoio(k).n_pilares-(j-1)).Aslt(1:tb)=Aslt_total;

        end


        if viaduto.dimensionar_barras_fustes_individualmente
            info.fustes.apoio(k).fuste(j).Asl=Asl{k}(:,j);
            info.fustes.apoio(k).fuste(viaduto.apoio(k).n_pilares-(j-1)).Asl=Asl{k}(:,j);
            info.fustes.apoio(k).fuste(j).Ast=Ast{k}(:,j);
            info.fustes.apoio(k).fuste(viaduto.apoio(k).n_pilares-(j-1)).Ast=Ast{k}(:,j);
            info.fustes.apoio(k).fuste(j).Aslt=Aslt{k}(:,j);
            info.fustes.apoio(k).fuste(viaduto.apoio(k).n_pilares-(j-1)).Aslt=Aslt{k}(:,j);
        end
    end
end



end