function coverage = calculateCoverage(A, B)
    % Verificar o tamanho dos conjuntos A e B
    sizeA = size(A, 1);
    sizeB = size(B, 1);

    % Inicializar contador para o número de soluções em B fracamente dominadas por A
    count = 0;

    % Iterar sobre cada solução em B
    for i = 1:sizeB
        % Verificar se existe alguma solução em A que fracamente domina a solução atual em B
        for j = 1:sizeA
            if all(A(j, :) <= B(i, :))
                count = count + 1;
                break;
            end
        end
    end

    % Calcular a cobertura
    coverage = count / sizeB;
end
