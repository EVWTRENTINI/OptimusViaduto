function impacto_ambiental = calc_impacto_ambiental(emissoes, quantitativo, info, viaduto)


%% Tubulões
impacto_ambiental.fundacao.escavacao_fuste = quantitativo.fundacao.volume_escavacao_fuste * emissoes.tubuloes.escavacao_fuste;
impacto_ambiental.fundacao.escavacao_base_alargada = quantitativo.fundacao.volume_base_alargada * emissoes.tubuloes.alargamento_base;
impacto_ambiental.fundacao.CA50_fuste = quantitativo.fundacao.peso_CA50_fuste * emissoes.tubuloes.CA50;
fck = viaduto.apoio(1).fustes.fck / 1E6; % assume que todos os apoios tenham o mesmo fck
impacto_ambiental.fundacao.concreto_base_alargada = quantitativo.fundacao.volume_base_alargada * (custo_interpolado(fck,[transpose([emissoes.concreto(:).fck]),transpose([emissoes.concreto(:).valor])])+emissoes.tubuloes.lancamento_concreto);
impacto_ambiental.fundacao.concreto_fuste = quantitativo.fundacao.volume_concreto_fuste * (custo_interpolado(fck,[transpose([emissoes.concreto(:).fck]),transpose([emissoes.concreto(:).valor])])+emissoes.tubuloes.lancamento_concreto);

%% Blocos
impacto_ambiental.fundacao.forma_bloco = quantitativo.fundacao.forma_bloco * emissoes.blocos.forma;
impacto_ambiental.fundacao.CA50_bloco = quantitativo.fundacao.peso_CA50_bloco * emissoes.blocos.CA50;
impacto_ambiental.fundacao.concreto_bloco = quantitativo.fundacao.volume_bloco * (custo_interpolado(fck,[transpose([emissoes.concreto(:).fck]),transpose([emissoes.concreto(:).valor])])+emissoes.blocos.lancamento_concreto);

z = struct2cell(impacto_ambiental.fundacao(:));
impacto_ambiental.fundacao.TOTAL = sum(reshape([z{:}],size(z)));

%% Pilares
impacto_ambiental.pilares.forma = quantitativo.pilares.forma * emissoes.pilares.forma;
impacto_ambiental.pilares.CA50 = quantitativo.pilares.peso_CA50 * emissoes.pilares.CA50;
fck = viaduto.apoio(1).pilares.fck / 1E6; % assume que todos os apoios tenham o mesmo fck
impacto_ambiental.pilares.concreto = quantitativo.pilares.volume * (custo_interpolado(fck,[transpose([emissoes.concreto(:).fck]),transpose([emissoes.concreto(:).valor])])+emissoes.pilares.lancamento_concreto);

z = struct2cell(impacto_ambiental.pilares(:));
impacto_ambiental.pilares.TOTAL = sum(reshape([z{:}],size(z)));

%% Travessas
impacto_ambiental.travessas.cimbramento = quantitativo.travessas.cimbramento * emissoes.travessas.cimbramento;
impacto_ambiental.travessas.forma = quantitativo.travessas.forma * emissoes.travessas.forma;
impacto_ambiental.travessas.CA50 = quantitativo.travessas.peso_CA50 * emissoes.travessas.CA50;
fck = viaduto.apoio(1).travessa.fck / 1E6; % assume que todos os apoios tenham o mesmo fck
impacto_ambiental.travessas.concreto = quantitativo.travessas.volume * (custo_interpolado(fck,[transpose([emissoes.concreto(:).fck]),transpose([emissoes.concreto(:).valor])])+emissoes.travessas.lancamento_concreto);

z = struct2cell(impacto_ambiental.travessas(:));
impacto_ambiental.travessas.TOTAL = sum(reshape([z{:}],size(z)));

%% Longarinas
impacto_ambiental.longarinas.aparelho_de_apoio = quantitativo.longarinas.volume_aparelho_apoio * emissoes.longarinas.aparelho_de_apoio;
impacto_ambiental.longarinas.forma = quantitativo.longarinas.forma * emissoes.longarinas.forma;
impacto_ambiental.longarinas.CA50 = quantitativo.longarinas.peso_CA50 * emissoes.longarinas.CA50;

if viaduto.tipo_diametro_cordoalha == 1
    impacto_ambiental.longarinas.cordoalha = quantitativo.longarinas.peso_cordoalha * emissoes.longarinas.cordoalha_127;
    emissoes_ancoragens = emissoes.longarinas.ancoragens_127;
elseif viaduto.tipo_diametro_cordoalha == 2
    impacto_ambiental.longarinas.cordoalha = quantitativo.longarinas.peso_cordoalha * emissoes.longarinas.cordoalha_152;
    emissoes_ancoragens = emissoes.longarinas.ancoragens_152;
end

impacto_ambiental.longarinas.bainha = sum(quantitativo.longarinas.bainhas.comprimento * custo_interpolado(viaduto.dcabo*1000,[transpose([emissoes.longarinas.bainha(:).diametro]),transpose([emissoes.longarinas.bainha(:).valor])]));
impacto_ambiental.longarinas.concreto = quantitativo.longarinas.volume_longarinas * (custo_interpolado(fck,[transpose([emissoes.concreto(:).fck]),transpose([emissoes.concreto(:).valor])])+emissoes.longarinas.lancamento_concreto);


impacto_ancoragens = 0;
for i = 1 : viaduto.n_apoios - 1
    n_longarinas = viaduto.vao(i).n_longarinas;
    n_cabos = length(info.longarinas.vao(i).longarina(1).cabos);
    for nc = 1 : n_cabos% assume que todas as longarinas são iguais. Comprimento de cabos em 1 longarina
        n_cordoalhas = info.longarinas.vao(i).longarina(1).aal.ncord(nc);% assume que todas as longarinas são iguais. Comprimento de cabos em 1 longarina
        impacto_ancoragens = impacto_ancoragens + (custo_interpolado(n_cordoalhas,[transpose([emissoes_ancoragens(:).n_cordoalhas]),transpose([emissoes_ancoragens(:).valor])])) * n_longarinas;
    end
end
impacto_ambiental.longarinas.ancoragem = impacto_ancoragens;


impacto_manobra_lancamento = 0;
for i = 1 : viaduto.n_apoios - 1
    peso_longarina = quantitativo.longarinas.manobra_lancamento.peso_longarina(i);
    n_longarinas = viaduto.vao(i).n_longarinas;
    impacto_manobra_lancamento = impacto_manobra_lancamento + custo_interpolado(peso_longarina, [transpose([emissoes.longarinas.manobra_lancamento(:).peso]),transpose([emissoes.longarinas.manobra_lancamento(:).valor])]) * n_longarinas;
end
impacto_ambiental.longarinas.manobra_lancamento = impacto_manobra_lancamento;

z = struct2cell(impacto_ambiental.longarinas(:));
impacto_ambiental.longarinas.TOTAL = sum(reshape([z{:}],size(z)));

%% Lajes
impacto_ambiental.lajes.trelicas = quantitativo.lajes.peso_trelicas * emissoes.lajes.trelicas;
impacto_ambiental.lajes.CA50 = quantitativo.lajes.peso_CA50 * emissoes.lajes.CA50;
fck = viaduto.vao(1).laje.fck / 1E6; % assume que todos os apoios tenham o mesmo fck
impacto_ambiental.lajes.concreto = quantitativo.lajes.volume * (custo_interpolado(fck,[transpose([emissoes.concreto(:).fck]),transpose([emissoes.concreto(:).valor])])+emissoes.lajes.lancamento_concreto);

z = struct2cell(impacto_ambiental.lajes(:));
impacto_ambiental.lajes.TOTAL = sum(reshape([z{:}],size(z)));

%% Total
impacto_ambiental.TOTAL = impacto_ambiental.fundacao.TOTAL + impacto_ambiental.pilares.TOTAL + impacto_ambiental.travessas.TOTAL + impacto_ambiental.longarinas.TOTAL + impacto_ambiental.lajes.TOTAL;
end