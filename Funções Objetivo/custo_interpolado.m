function custo = custo_interpolado(valor,custos)

lista_valores = transpose(custos(:,1));
lista_custos = transpose(custos(:,2));

custo = interp1(lista_valores, lista_custos, valor, 'linear', 'extrap');

end
