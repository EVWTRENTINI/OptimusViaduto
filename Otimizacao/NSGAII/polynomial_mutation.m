function  x = polynomial_mutation(x,xl,xu,eta_m)

%% Versão do professor - https://www.youtube.com/watch?v=7-NPqSvutr0&list=PLwdnzlV3ogoWyi7exLIe26JhueiVQXq_S&index=24&ab_channel=NPTELIITGuwahati
%rnd = rand;
%if rnd < .5
%    delta_i = (2*rnd)^(1/(eta_m+1)) - 1;
%else
%    delta_i = 1 - ((2*(1-rnd))^(1/(eta_m+1)));
%end
%x = x + (xu - xl) * delta_i;

%% Versão do artigo - An effcient constraint handling method for genetic algorithms, Kalyanmoy Deb
%rnd = rand;
%
%delta = min([x-xl xu-x])/(xu-xl);
%
%
%if rnd <= .5
%    delta_i = (2*rnd + (1-2*rnd)*(1-delta)^(eta_m+1))^(1/(eta_m+1)) - 1;
%else
%    delta_i = 1 - ((2*(1-rnd) + 2*(rnd-.5)*(1-delta)^(eta_m+1))^(1/(eta_m+1)));
%end
%
%x = x + (xu - xl) * delta_i;

%% minha versão
rnd = rand;

delta1 = (x-xl)/(xu-xl);
delta2 = (xu-x)/(xu-xl);

if rnd <= .5
    delta_i = (2*rnd + (1-2*rnd)*(1-delta1)^(eta_m+1))^(1/(eta_m+1)) - 1;
else
    delta_i = 1 - ((2*(1-rnd) + 2*(rnd-.5)*(1-delta2)^(eta_m+1))^(1/(eta_m+1)));
end

x_old = x;

x = x + (xu - xl) * delta_i;

if not(isreal(x))
    x = x_old;
end
end





