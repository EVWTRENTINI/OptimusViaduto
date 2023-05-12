function [minvalue, maxvalue, discvalue] = define_valores_limites(vaos_unicos, parametros_gerador_modelo, greide)

quantidade_grupos_vao = length(vaos_unicos);
minvalue = cell(1,quantidade_grupos_vao);
maxvalue = cell(1,quantidade_grupos_vao);
discvalue = cell(1,quantidade_grupos_vao);
for g = 1 : quantidade_grupos_vao
    n_vaos = vaos_unicos(g);

    % Variaveis fixas independente do numero de vãos
    minvalue{g} = zeros(1,14+24*n_vaos);
    maxvalue{g} = zeros(1,14+24*n_vaos);
    discvalue{g} = zeros(1,14+24*n_vaos);
    n = 1;
    minvalue{g}(n)  = parametros_gerador_modelo.fundacao.c.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.fundacao.c.max;
    discvalue{g}(n) = parametros_gerador_modelo.fundacao.c.discretizacao;
    n = n + 1;
    minvalue{g}(n)  = parametros_gerador_modelo.pilares.fck.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.pilares.fck.max;
    discvalue{g}(n) = parametros_gerador_modelo.pilares.fck.discretizacao;
    n = n + 1;
    minvalue{g}(n)  = parametros_gerador_modelo.pilares.c.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.pilares.c.max;
    discvalue{g}(n) = parametros_gerador_modelo.pilares.c.discretizacao;
    n = n + 1;
    minvalue{g}(n)  = parametros_gerador_modelo.travessas.fck.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.travessas.fck.max;
    discvalue{g}(n) = parametros_gerador_modelo.travessas.fck.discretizacao;
    n = n + 1;
    minvalue{g}(n)  = parametros_gerador_modelo.travessas.c.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.travessas.c.max;
    discvalue{g}(n) = parametros_gerador_modelo.travessas.c.discretizacao;
    n = n + 1;
    minvalue{g}(n)  = parametros_gerador_modelo.tabuleiro.fck.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.tabuleiro.fck.max;
    discvalue{g}(n) = parametros_gerador_modelo.tabuleiro.fck.discretizacao;
    n = n + 1;
    minvalue{g}(n)  = parametros_gerador_modelo.longarinas.c.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.c.max;
    discvalue{g}(n) = parametros_gerador_modelo.longarinas.c.discretizacao;
    n = n + 1;
    minvalue{g}(n)  = parametros_gerador_modelo.lajes.c.min;
    maxvalue{g}(n)  = parametros_gerador_modelo.lajes.c.max;
    discvalue{g}(n) = parametros_gerador_modelo.lajes.c.discretizacao;

    % Primeiro e ultimo apoio
    for i = [1 n_vaos+1]
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.fundacao.profundidade_fundacao.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.fundacao.profundidade_fundacao.max;
        discvalue{g}(n) = parametros_gerador_modelo.fundacao.profundidade_fundacao.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.pilares.n.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.pilares.n.max;
        discvalue{g}(n) = parametros_gerador_modelo.pilares.n.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.fundacao.d.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.fundacao.d.max;
        discvalue{g}(n) = parametros_gerador_modelo.fundacao.d.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.pilares.d.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.pilares.d.max;
        discvalue{g}(n) = parametros_gerador_modelo.pilares.d.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.travessas.h.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.travessas.h.max;
        discvalue{g}(n) = parametros_gerador_modelo.travessas.h.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.travessas.b.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.travessas.b.max;
        discvalue{g}(n) = parametros_gerador_modelo.travessas.b.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.travessas.bl.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.travessas.bl.max;
        discvalue{g}(n) = parametros_gerador_modelo.travessas.bl.discretizacao;
    end

    % Primeiro vão
    for i = 1
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.n.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.n.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.n.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.hap.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.hap.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.hap.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h1.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h1.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h1.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h2.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h2.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h2.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h3.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h3.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h3.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h4.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h4.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h4.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h5.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h5.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h5.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.b1.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.b1.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.b1.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.b2.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.b2.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.b2.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.b3.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.b3.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.b3.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.enr.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.enr.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.enr.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.benr.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.benr.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.benr.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpc.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpc.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.hpc.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpa.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpa.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.hpa.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.ncp.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.ncp.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.ncp.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.lajes.h.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.lajes.h.max;
        discvalue{g}(n) = parametros_gerador_modelo.lajes.h.discretizacao;
    end

    % Para cada vão adicional
    for i = 2:n_vaos
        % Apoio
        n = n + 1;
        minvalue{g}(n)  = greide.x(1);
        maxvalue{g}(n)  = greide.x(end);
        discvalue{g}(n) = parametros_gerador_modelo.L_vao.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.fundacao.profundidade_fundacao.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.fundacao.profundidade_fundacao.max;
        discvalue{g}(n) = parametros_gerador_modelo.fundacao.profundidade_fundacao.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.pilares.n.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.pilares.n.max;
        discvalue{g}(n) = parametros_gerador_modelo.pilares.n.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.fundacao.d.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.fundacao.d.max;
        discvalue{g}(n) = parametros_gerador_modelo.fundacao.d.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.pilares.d.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.pilares.d.max;
        discvalue{g}(n) = parametros_gerador_modelo.pilares.d.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.travessas.h.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.travessas.h.max;
        discvalue{g}(n) = parametros_gerador_modelo.travessas.h.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.travessas.b.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.travessas.b.max;
        discvalue{g}(n) = parametros_gerador_modelo.travessas.b.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.travessas.bl.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.travessas.bl.max;
        discvalue{g}(n) = parametros_gerador_modelo.travessas.bl.discretizacao;
        % Vao
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.n.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.n.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.n.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.hap.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.hap.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.hap.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h1.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h1.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h1.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h2.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h2.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h2.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h3.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h3.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h3.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h4.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h4.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h4.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.h5.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.h5.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.h5.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.b1.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.b1.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.b1.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.b2.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.b2.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.b2.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.b3.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.b3.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.b3.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.enr.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.enr.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.enr.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.benr.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.benr.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.benr.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpc.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpc.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.hpc.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpa.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.hpa.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.hpa.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.longarinas.ncp.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.longarinas.ncp.max;
        discvalue{g}(n) = parametros_gerador_modelo.longarinas.ncp.discretizacao;
        n = n + 1;
        minvalue{g}(n)  = parametros_gerador_modelo.lajes.h.min;
        maxvalue{g}(n)  = parametros_gerador_modelo.lajes.h.max;
        discvalue{g}(n) = parametros_gerador_modelo.lajes.h.discretizacao;
    end

end


end
























