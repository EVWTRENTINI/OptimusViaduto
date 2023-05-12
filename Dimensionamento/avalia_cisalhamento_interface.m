function [situacao,msg_erro] = avalia_cisalhamento_interface(Ast_int, delta_x, fck, gama_c, fyd, MSd_ext, d, av, b)
situacao = true;
msg_erro = 'sem erro';

n_disc = length(Ast_int);

tauRd_trecho = zeros(1,n_disc);

for i = 1:n_disc
    ro = (Ast_int(i)/(100*(b*100)))*100; % taxa em porcentagem
    tauRd_trecho(i) = calc_tauRd(ro, fck, gama_c, fyd);
end

tauRd = sum(tauRd_trecho .* delta_x) / sum(delta_x);

tauSd = calc_tauSd(MSd_ext, d, av, b);

if tauRd < tauSd
    situacao = false;
    msg_erro = 'Falha por cisalhamento na interface entre a longarina e laje.';
end
end



function tauSd = calc_tauSd(MSd_ext, d, av, b)
MSd_ext = MSd_ext / 1000; % MN.m
z_cloc = 0.87 * d;
Fmd = MSd_ext / z_cloc; % MN
tauSd = Fmd/av/b; % MPa
end

function tauRd = calc_tauRd(ro, fck, gama_c, fyd)
if ro < 0.2
    beta_s = 0;
    beta_c = 0.3;
elseif ro > 0.5
    beta_s = 0.9;
    beta_c = 0.6;
else
    beta_s = interp1([.2 .5],[.0 .9],ro);
    beta_c = interp1([.2 .5],[.3 .6],ro);
end

fcd=fck/gama_c;
[~,fctkinf,~] = calc_fctm(fck);
fctd = fctkinf / gama_c; % MPa

tauRd = min([(beta_s*ro/100*fyd + beta_c*fctd) (0.25 * fcd)]);
end