function dominancia = confere_dominancia(fitness1, fitness2, min_or_max)
%CONFERE_DOMINANCIA Confere se 1 domina 2.
%   CONFERE_DOMINANCIA(fitness1, fitness2, min_or_max) 
%   Caso 1 domine 2 o resultado é 3.
%   Caso 1 seja dominado por 2 o resultado é 1.
%   Caso 1 seja indiferente a 2 o resultado é 2.
soma = 0;
for i = 1:length(min_or_max)

    if fitness1(i)*min_or_max(i) <= fitness2(i)*min_or_max(i)
        soma = soma + 1;
    end
end
if soma == length(min_or_max)
    dominancia = 3; % 1 domina 2
elseif soma == 0
%    soma = 0;
%    for i = 1:length(min_or_max)
% 
%        if fitness1(i)*min_or_max(i) == fitness2(i)*min_or_max(i)
%            soma = soma + 1;
%        end
%    end
% 
%    if soma >= 1
%        dominancia = 2; % 1 é indiferente a 2
%    else
       dominancia = 1; % 1 é dominado por 2
       %    end
else
    soma = 0;
    for i = 1:length(min_or_max)

        if fitness2(i)*min_or_max(i) <= fitness1(i)*min_or_max(i)
            soma = soma + 1;
        end
    end
    if soma == length(min_or_max)
        dominancia = 1; % 2 é dominada por 1
    else
        dominancia = 2; % 1 é indiferente a 2
    end
    
end

end