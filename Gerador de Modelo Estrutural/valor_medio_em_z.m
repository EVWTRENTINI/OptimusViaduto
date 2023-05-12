function valor_medio=valor_medio_em_z(valor,x,z_sup,z_inf,nsp)
z_tot=z_sup-z_inf;
delta_z=z_tot/(nsp-1);
spv=zeros(1,nsp);%sample point values;
for i=1:nsp
    zsp=z_inf+delta_z*(i-1);
    spv(i)=valor(x,zsp);
end



valor_medio=mean(spv);
end