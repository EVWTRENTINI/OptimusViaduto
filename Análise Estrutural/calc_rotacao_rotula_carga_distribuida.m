function [rb, re] = calc_rotacao_rotula_carga_distribuida(q,a,b,L,E,I)
rb = -(q*L^3/(24*E*I)) +(q*a^2*(2*L-a)^2/(24*L*E*I)) +(q*b^2*(2*L^2-b^2)/(24*L*E*I));
re = +(q*L^3/(24*E*I)) -(q*b^2*(2*L-b)^2/(24*L*E*I)) -(q*a^2*(2*L^2-a^2)/(24*L*E*I));
end