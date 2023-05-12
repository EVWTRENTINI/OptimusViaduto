function [info,todas_as_falhas_foram_por_n_cabos,situacao,msg_erro]=dim_longarinas(ENVLONGA,ENVLONGACR,ENVLONGACF,ENVLONGACQP, MFLECHA, ENVAPAPOIO,viaduto,MA,info,xb,tot_ponto,LC,config_draw)
%Dimensiona todas as longarinas do viaduto

todas_as_falhas_foram_por_n_cabos = true;
corrigir_n_cabos = false;

for vao_i=1:viaduto.n_apoios-1
    for long_i=1:ceil(viaduto.vao(vao_i).n_longarinas/2)
        mlong=info.longarinas.vao(vao_i).longarina(long_i).membros;
        [info,situacao,msg_erro] = dim_longarina(ENVLONGA.vao(vao_i).longarina(long_i),ENVLONGACR.vao(vao_i).longarina(long_i),ENVLONGACF.vao(vao_i).longarina(long_i),ENVLONGACQP.vao(vao_i).longarina(long_i), MFLECHA.vao(vao_i).longarina(long_i).MFLECHA,ENVAPAPOIO.vao(vao_i).longarina(long_i),vao_i,long_i,viaduto,MA.memb(mlong).secao,info,xb,tot_ponto,LC(info.LC.PP_ini).cd,config_draw);
        if not(situacao) % Caso falhe
            if not(info.longarinas.vao(vao_i).longarina(long_i).recalcular_protensao) % Caso NÃO falhe por conta de falta de protensão
                msg_erro=[msg_erro ' Vão ' num2str(vao_i) ', longarina ' num2str(long_i) '.'];
                todas_as_falhas_foram_por_n_cabos = false;
                return;
            else % Caso falhe por conta de falta de protensão
                corrigir_n_cabos = true;
                % Continua para estimativa do numero de cordoalhas de todas
                % as longarinas em todos os vãos
            end
        end

    end
end
if corrigir_n_cabos
    situacao = false;
    msg_erro=['Não atingiu o nível de protensão exigido. Vão ' num2str(vao_i) ', longarina ' num2str(long_i)];
end
end