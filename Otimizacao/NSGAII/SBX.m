function [child1, child2] = SBX(parent1, parent2, yl, yu, eta_c)
% SBX (Simulated Binary Crossover)
rnd = rand;
if (rnd <= 1)   % Variable selected
    if (abs(parent1 - parent2) > 0.000001)
        if (parent2 > parent1)
            y2 = parent2;
            y1 = parent1;
        else
            y2 = parent1;
            y1 = parent2;
        end
        % Find beta value
   

        beta1 = 1.0 + (2.0*(y1-yl)/(y2-y1));
        beta2 = 1.0 + (2.0*(yu-y2)/(y2-y1));

        

        % Find alpha
        alpha1 = 2.0 - (beta1^(-(1.0+eta_c)));
        alpha2 = 2.0 - (beta2^(-(1.0+eta_c)));
        rnd = rand;
        if (rnd <= 1.0/alpha1)
            alpha1 = alpha1*rnd;
            betaq1 = alpha1^(1.0/(1.0+eta_c));
        else   % rnd > 1.0/alpha
            alpha1 = alpha1*rnd;
            alpha1 = 1.0/(2.0-alpha1);
            betaq1 = alpha1^(1.0/(1.0+eta_c));
        end
        if (rnd <= 1.0/alpha2)
            alpha2 = alpha2*rnd;
            betaq2 = alpha2^(1.0/(1.0+eta_c));
        else   % rnd > 1.0/alpha
            alpha2 = alpha2*rnd;
            alpha2 = 1.0/(2.0-alpha2);
            betaq2 = alpha2^(1.0/(1.0+eta_c));
        end
        % Generating two children
        child1 = 0.5*((y1+y2)-betaq1*(y2-y1));
        child2 = 0.5*((y1+y2)+betaq2*(y2-y1));
    else  % abs(parent1 - parent2) <= 0.000001
        betaq = 1.0;
        y1 = parent1;
        y2 = parent2;
        % Generating two children
        child1 = 0.5*((y1+y2)-betaq*(y2-y1));
        child2 = 0.5*((y1+y2)+betaq*(y2-y1));
    end % abs(parent1 - parent2) ends here
    if (child1 > yu)
        child1 = yu;
    elseif (child1 < yl)
        child1 = yl;
    end
    if (child2 > yu)
        child2 = yu;
    elseif (child2 < yl)
        child2 = yl;
    end
else   % Variable NOT selected
    % Copying parents to children
    child1 = parent1;
    child2 = parent2;
end % Variable selection ends here

%% Checa se o resultado é um numero real
if not(isreal(child1))
    child1 = parent1;
end
if not(isreal(child2))
    child2 = parent2;
end


end