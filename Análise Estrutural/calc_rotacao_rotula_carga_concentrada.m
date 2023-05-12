function [rb, re] = calc_rotacao_rotula_carga_concentrada(P,a,b,L,E,I)
rb = -(P*a*b*(L + b)/(6*L*E*I));
re = +(P*a*b*(L + a)/(6*L*E*I));
end