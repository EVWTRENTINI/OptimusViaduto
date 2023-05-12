function n = aleatorio_entre_arredondado_relativo(p, pr, v)
valor_medio = pr.relacao * v;
variacao_min = valor_medio * (1-pr.variacao_aleatoria);
variacao_max = valor_medio * (1+pr.variacao_aleatoria);

if variacao_min > p.min
    % Arredonda dentro da discretização
    if variacao_min < p.max
        variacao_min = p.min + ceil((variacao_min-p.min)/p.discretizacao) * p.discretizacao;
    else
        variacao_min = p.max;
    end
else
    variacao_min = p.min;
end

if variacao_max < p.max
    % Arredonda dentro da discretização
    if variacao_max > p.min
        variacao_max = p.min + floor((variacao_max-p.min)/p.discretizacao) * p.discretizacao;
    else
        variacao_max = p.min;
    end
else
    variacao_max = p.max;
end

p_novo.min = variacao_min;
p_novo.max = variacao_max;
p_novo.discretizacao = p.discretizacao;

n = aleatorio_entre_arredondado(p_novo);

end