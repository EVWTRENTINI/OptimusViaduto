greide.x=[0  39];
greide.z=[7.95   7.95];
L=greide.x(end)-greide.x(1);

%impedido(1) = struct('xi', 6, 'xf', 15, 'pista', false);
impedido(1) = struct('xi', 1, 'xf', 15, 'pista', false);
impedido(2) = struct('xi', 20, 'xf', 25, 'pista', false);



terreno(1).x=greide.x(1);
terreno(2).x=L/3;
terreno(3).x=L*2/3;
terreno(4).x=L;
terreno(1).nivel_terreno=0;
terreno(2).nivel_terreno=-1.5;
terreno(3).nivel_terreno=-1.5;
terreno(4).nivel_terreno=0;
terreno(1).delta_z_impacto=0;
terreno(2).delta_z_impacto=0;
terreno(3).delta_z_impacto=0;
terreno(4).delta_z_impacto=0;


for n=1:4
    terreno(n).nivel_agua=terreno(n).nivel_terreno-3.1;
    terreno(n).Nspt=[0 2 2 5 17 21 8 10 36 29 38 70];

    %% tipo de solo
    % 1 para areia ou argila mole e 2 para argila pré-adensada
    terreno(n).tipo_solo=ones(1,length(terreno(n).Nspt))*2;

end