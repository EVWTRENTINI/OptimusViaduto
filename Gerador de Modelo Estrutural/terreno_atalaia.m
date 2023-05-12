greide.x=[0  31];
greide.z=[8.40   8.40];
L=greide.x(end)-greide.x(1);

impedido(1) = struct('xi', 2, 'xf', 13.2, 'pista', true);
impedido(2) = struct('xi', 17.7, 'xf', 29, 'pista', true);



terreno(1).x=greide.x(1);
terreno(2).x=L/2;
terreno(3).x=L;
terreno(1).nivel_terreno=0;
terreno(2).nivel_terreno=0;
terreno(3).nivel_terreno=0;
terreno(1).delta_z_impacto=0;
terreno(2).delta_z_impacto=0;
terreno(3).delta_z_impacto=0;


n=1;
terreno(n).nivel_agua=terreno(n).nivel_terreno-30;
terreno(n).Nspt=[0 12 12 10 07 06 06 06 06 08 10 12 14 20 23 29 34 46 70];
% tipo de solo
% 1 para areia ou argila mole e 2 para argila pré-adensada
terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;

n=2;
terreno(n).nivel_agua=terreno(n).nivel_terreno-30;
terreno(n).Nspt=[0 16 14 08 06 05 04 04 04 04 06 10 12 12 21 26 31 36 48 70];
% tipo de solo
% 1 para areia ou argila mole e 2 para argila pré-adensada
terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;

n=3;
terreno(n).nivel_agua=terreno(n).nivel_terreno-30;
terreno(n).Nspt=[0 08 08 07 06 06 06 06 08 08 11 11 12 16 17 19 24 35 47 70];
% tipo de solo
% 1 para areia ou argila mole e 2 para argila pré-adensada
terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;