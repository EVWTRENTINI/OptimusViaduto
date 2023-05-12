function [pop_size, archive_size, bottom, top, w_min, w_max, c1, c2, c3i, p1, maxgen, mut_prob, eta_m] = individualiza_parametros_MOPSO(parametros_MOPSO)
pop_size = parametros_MOPSO.pop_size;
archive_size = parametros_MOPSO.archive_size;
bottom = parametros_MOPSO.bottom;
top = parametros_MOPSO.top;
w_min = parametros_MOPSO.w_min;
w_max = parametros_MOPSO.w_max;
c1 = parametros_MOPSO.c1;
c2 = parametros_MOPSO.c2;
c3i = parametros_MOPSO.c3i;
p1 = parametros_MOPSO.p1;
maxgen = parametros_MOPSO.maxgen;
mut_prob = parametros_MOPSO.mut_prob;
eta_m = parametros_MOPSO.eta_m;
end