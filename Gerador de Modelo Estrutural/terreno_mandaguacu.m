greide.x=[0  45.74];
greide.z=[9.50   8.82];
L=greide.x(end)-greide.x(1);


impedido(1) = struct('xi', 02.10, 'xf', 15.43, 'pista', true);
impedido(2) = struct('xi', 18.94, 'xf', 30.42, 'pista', true);
impedido(3) = struct('xi', 35.72, 'xf', 43.64, 'pista', true);



terreno(1).x=greide.x(1);
terreno(2).x=17.10;
terreno(3).x=33.02;
terreno(4).x=L;
terreno(1).nivel_terreno=0;
terreno(2).nivel_terreno=0;
terreno(3).nivel_terreno=-4.46;
terreno(4).nivel_terreno=-4.94;
terreno(1).delta_z_impacto=0.85;
terreno(2).delta_z_impacto=0.50;
terreno(3).delta_z_impacto=4.50;
terreno(4).delta_z_impacto=3.31;

n=1;
terreno(n).nivel_agua=terreno(n).nivel_terreno-30;
terreno(n).Nspt=[0 08 10 13 16 04 04 05 06 09 14 15 19 25 31 39 70];
% tipo de solo
% 1 para areia ou argila mole e 2 para argila pré-adensada
terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;

n=2;
terreno(n).nivel_agua=terreno(n).nivel_terreno-30;
terreno(n).Nspt=[0 11 18 09 05 05 07 08 10 12 14 17 22 27 35 45 70];
% tipo de solo
% 1 para areia ou argila mole e 2 para argila pré-adensada
terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;

n=3;
terreno(n).nivel_agua=terreno(n).nivel_terreno-30;
terreno(n).Nspt=[0 09 12 14 06 06 07 08 10 12 14 19 27 34 44 51 60 70];
% tipo de solo
% 1 para areia ou argila mole e 2 para argila pré-adensada
terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;

n=4;
terreno(n).nivel_agua=terreno(n).nivel_terreno-30;
terreno(n).Nspt=[0 05 04 06 06 06 08 09 12 14 18 25 41 51 70];
% tipo de solo
% 1 para areia ou argila mole e 2 para argila pré-adensada
terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;