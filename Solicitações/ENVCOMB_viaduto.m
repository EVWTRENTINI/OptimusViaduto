function [ENVLONGA,ENVLONGACR,ENVLONGACF,ENVLONGACQP,ENVAPAPOIO,ENVTRAV,ENVPIL,ENVFUS,COMBFUNDA] = ENVCOMB_viaduto(Nx,Vy,Vz,Tx,My,Mz,rb,re,broty,xb,tot_ponto,info,viaduto)
%Calcula a envoltória de esforços e combinações principais, ambos com CNF E CIA.
%   


[ENVLONGA, ENVLONGACR, ENVLONGACF, ENVLONGACQP, ENVAPAPOIO] = ENVCOMB_viaduto_longarinas(info, tot_ponto, xb, Nx, Vz, Tx, My, rb, re, broty, viaduto);

[ENVPIL, ENVFUS, COMBFUNDA] = ENVCOMB_viaduto_exceto_longarinas(viaduto, info, Nx, tot_ponto, Vy, Vz, Tx, Mz, My);

end

