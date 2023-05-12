function viaduto = cria_viaduto_baseado_pai(apoios_possiveis, n_vaos_possiveis, viaduto_pai, terreno, greide, pgm, ot)
% Cria viaduto aleatorio baseado nos parametros estipulados
viaduto = viaduto_pai;

pr.variacao_aleatoria = ot.amplitude_mutacao;
pr.relacao = 1;

for grupo = ["pilares" "travessas" "tabuleiro"]
    pgm.(grupo).fck.discretizacao = pgm.(grupo).fck.discretizacao * (1E6);
    pgm.(grupo).fck.min = pgm.(grupo).fck.min * (1E6);
    pgm.(grupo).fck.max = pgm.(grupo).fck.max * (1E6);
end


if rand <= ot.taxa_mutacao % Muta
    viaduto.x_apoio = muta_x_apoio(n_vaos_possiveis, apoios_possiveis, viaduto.n_apoios, viaduto.x_apoio, ot.taxa_mutacao);
end

grupo = 'fundacao';
propriedade = 'c';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));


grupo = 'pilares';
propriedade = 'fck';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));
propriedade = 'c';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));


grupo = 'travessas';
propriedade = 'fck';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));
propriedade = 'c';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));

grupo = 'tabuleiro';
propriedade = 'fck';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));

viaduto.longarinas.fck = viaduto.tabuleiro.fck;
grupo = 'longarinas';
propriedade = 'c';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));

viaduto.lajes.fck = viaduto.tabuleiro.fck;
grupo = 'lajes';
propriedade = 'c';
viaduto.(grupo).(propriedade) = muta_propriedade(viaduto.(grupo).(propriedade), ot, pr, pgm.(grupo).(propriedade));



for i=1:viaduto.n_apoios
    viaduto.apoio(i).profundidade_fundacao = muta_propriedade(viaduto.apoio(i).profundidade_fundacao, ot, pr, pgm.fundacao.profundidade_fundacao);

    viaduto.apoio(i).n_pilares = muta_propriedade(viaduto.apoio(i).n_pilares, ot, pr, pgm.pilares.n);    
  
    viaduto.apoio(i).fustes.d = muta_propriedade(viaduto.apoio(i).fustes.d, ot, pr, pgm.fundacao.d);
    viaduto.apoio(i).fustes.fck = viaduto.fundacao.fck;%Pa
    viaduto.apoio(i).fustes.c = viaduto.fundacao.c;


    viaduto.apoio(i).pilares.d = muta_propriedade(viaduto.apoio(i).pilares.d, ot, pr, pgm.pilares.d);

    viaduto.apoio(i).pilares.fck = viaduto.pilares.fck;%Pa
    viaduto.apoio(i).pilares.c = viaduto.pilares.c;%cobrimento em m


    viaduto.apoio(i).travessa.h = muta_propriedade(viaduto.apoio(i).travessa.h, ot, pr, pgm.travessas.h);
    viaduto.apoio(i).travessa.b = muta_propriedade(viaduto.apoio(i).travessa.b, ot, pr, pgm.travessas.b);
    viaduto.apoio(i).travessa.bl = muta_propriedade(viaduto.apoio(i).travessa.bl, ot, pr, pgm.travessas.bl);

    viaduto.apoio(i).travessa.fck = viaduto.travessas.fck;%Pa
    viaduto.apoio(i).travessa.c = viaduto.travessas.c;%m
end

for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l=(viaduto.x_apoio(i+1)-viaduto.x_apoio(i));%m
    viaduto.vao(i).n_longarinas = muta_propriedade(viaduto.vao(i).n_longarinas, ot, pr, pgm.longarinas.n);
    viaduto.vao(i).hap = muta_propriedade(viaduto.vao(i).hap, ot, pr, pgm.longarinas.hap);

    viaduto.vao(i).longarina.h1 = muta_propriedade(viaduto.vao(i).longarina.h1, ot, pr, pgm.longarinas.h1);
    viaduto.vao(i).longarina.h2 = muta_propriedade(viaduto.vao(i).longarina.h2, ot, pr, pgm.longarinas.h2);
    viaduto.vao(i).longarina.h3 = muta_propriedade(viaduto.vao(i).longarina.h3, ot, pr, pgm.longarinas.h3);
    viaduto.vao(i).longarina.h4 = muta_propriedade(viaduto.vao(i).longarina.h4, ot, pr, pgm.longarinas.h4);
    viaduto.vao(i).longarina.h5 = muta_propriedade(viaduto.vao(i).longarina.h5, ot, pr, pgm.longarinas.h5);
    
    viaduto.vao(i).longarina.b1 = muta_propriedade(viaduto.vao(i).longarina.b1, ot, pr, pgm.longarinas.b1);
    viaduto.vao(i).longarina.b2 = muta_propriedade(viaduto.vao(i).longarina.b2, ot, pr, pgm.longarinas.b2);
    viaduto.vao(i).longarina.b3 = muta_propriedade(viaduto.vao(i).longarina.b3, ot, pr, pgm.longarinas.b3);
    
    viaduto.vao(i).longarina.enr = muta_propriedade(viaduto.vao(i).longarina.enr, ot, pr, pgm.longarinas.enr);

    pgm.longarinas.benr_alterado = rearranja_limites_benr(pgm.longarinas.benr,viaduto.vao(i).longarina.b1,viaduto.vao(i).longarina.b2,viaduto.vao(i).longarina.b3);
    viaduto.vao(i).longarina.benr = muta_propriedade(viaduto.vao(i).longarina.benr, ot, pr, pgm.longarinas.benr_alterado);

    % Caso altere b1, b2 e/ou b3 e precise alterar o benr
    if viaduto.vao(i).longarina.benr < pgm.longarinas.benr_alterado.min
        viaduto.vao(i).longarina.benr = pgm.longarinas.benr_alterado.min;
    end
    if viaduto.vao(i).longarina.benr > pgm.longarinas.benr_alterado.max
        viaduto.vao(i).longarina.benr = pgm.longarinas.benr_alterado.max;
    end


    viaduto.vao(i).longarina.fck = viaduto.longarinas.fck;%Pa %deve ser o mesmo da laje
    viaduto.vao(i).longarina.c = viaduto.longarinas.c;%m

    viaduto.vao(i).amp = muta_propriedade(viaduto.vao(i).amp, ot, pr, pgm.longarinas.hpc);
    viaduto.vao(i).aap = muta_propriedade(viaduto.vao(i).aap, ot, pr, pgm.longarinas.hpa);

    viaduto.vao(i).ntcord = muta_propriedade(viaduto.vao(i).ntcord, ot, pr, pgm.longarinas.ncp);

    viaduto.vao(i).laje.h = muta_propriedade(viaduto.vao(i).laje.h, ot, pr, pgm.lajes.h);

    viaduto.vao(i).laje.fck = viaduto.lajes.fck;%Pa %deve ser o mesmo da longarina
    viaduto.vao(i).laje.c = viaduto.lajes.c;%m
end


end

function limites_benr = rearranja_limites_benr(limites_benr,b1,b2,b3)
min_b1_b3 = min([b1 b3]);

if min_b1_b3 < b2
    limites_benr.min = b2;
    limites_benr.max = b2;
else
    if limites_benr.min < b2
        limites_benr.min = b2;
    end

    if limites_benr.max < b2
        limites_benr.max = b2;
    end

    if limites_benr.max > min_b1_b3
        limites_benr.max = min_b1_b3;
    end

    if limites_benr.min > min_b1_b3
        limites_benr.min = min_b1_b3;
    end
end

end






function x_apoio = muta_x_apoio(n_vaos_possiveis, apoios_possiveis, n_apoios, x_apoio_pai, taxa_mutacao)
    n_vaos_desejados = n_apoios - 1;
    apoios_possiveis_para_teste_n_vaos = [apoios_possiveis{n_vaos_possiveis==n_vaos_desejados}];
    apoios_possiveis_selecionados = transpose(reshape(apoios_possiveis_para_teste_n_vaos,n_vaos_desejados+1,[]));
    vaos_pai = x_apoio_pai(2:end) - x_apoio_pai(1:end-1);
    vaos_possiveis = apoios_possiveis_selecionados(:,2:end) - apoios_possiveis_selecionados(:,1:end-1);
    
    quadrado_da_diferenca = 0;
    for i = 1:length(vaos_pai)
        quadrado_da_diferenca = quadrado_da_diferenca + (vaos_pai(i) - vaos_possiveis(:,i)).^2;
    end
    diferenca = sqrt(quadrado_da_diferenca);
    [~,indice]=sort(diferenca);
    apoios_possiveis_organizados = apoios_possiveis_selecionados(indice(2:end),:);
    [n_apoios_viaveis, ~] = size(apoios_possiveis_organizados);
    indice_apoios_proximos = min([ceil(n_apoios_viaveis * taxa_mutacao) n_apoios_viaveis]);

    if isempty(apoios_possiveis_organizados)
        x_apoio = apoios_possiveis_selecionados(1,:);
    else
        x_apoio = apoios_possiveis_organizados(randi(indice_apoios_proximos),:);
    end

end


function valor_mutado = muta_propriedade(valor_original, ot, pr, pgm)
if rand <= ot.taxa_mutacao
    valor_mutado = aleatorio_entre_arredondado_relativo(pgm, pr, valor_original);
    if valor_mutado == valor_original
        if rand <= .5
            valor_mutado = valor_mutado + pgm.discretizacao;
        else
            valor_mutado = valor_mutado - pgm.discretizacao;
        end
        if valor_mutado > pgm.max
            valor_mutado = pgm.max;
        end
        if valor_mutado < pgm.min
            valor_mutado = pgm.min;
        end
    end
else
    valor_mutado = valor_original;
end
end



