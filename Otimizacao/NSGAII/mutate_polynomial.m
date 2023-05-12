function Q = mutate_polynomial(Q, p_m, minvalue, maxvalue, eta_m)
    for i = 1:length(Q)
        if rand <= p_m
            for n = 1:length(Q{i}.variaveis)
                x_old = Q{i}.variaveis(n);
                xl = minvalue{Q{i}.type}(n);
                xu = maxvalue{Q{i}.type}(n);

                Q{i}.variaveis(n) = polynomial_mutation(x_old,xl,xu,eta_m);
            end
        end
    end
end