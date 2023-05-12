function n = aleatorio_entre_arredondado(p)
minimo = p.min;
maximo = p.max;
passo = p.discretizacao;
numero_passos = ceil((maximo-minimo)/passo);
passos_aleatorios = randi([0 numero_passos]);
n=min([maximo (minimo + passos_aleatorios * passo)]);
end