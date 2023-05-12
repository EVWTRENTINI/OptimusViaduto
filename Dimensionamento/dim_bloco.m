function [A,H,Asxy,Asxz_yz]=dim_bloco(Nsd,fi_f,ap)
% Dimensiona de acordo com apostila de blocos do Paulo Sergio Bastos
A=fi_f+.2;
H=max([1.1*fi_f 1.5*(fi_f-ap)]);

ro_min = .15/100; % Taxa de armadura mínima
txyd=.29*Nsd*((fi_f-ap)/fi_f);%kN

%50/1.15 kN/cm²
fyd=43.478260869565217391304347826087;%kN/cm² 

Asxy=txyd/fyd;%cm²
Asxy_min=A*100*H*100*ro_min;
if Asxy<Asxy_min
    Asxy=Asxy_min;
end

Asxz_yz=A*100*A*100*ro_min; % Armadura mínima na forma de estribos na vertical

end