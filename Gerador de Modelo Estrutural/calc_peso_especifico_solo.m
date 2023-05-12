function peso_especifico_solo=calc_peso_especifico_solo(sondagem)
n_furos=length(sondagem);


cont=0;
for i=1:n_furos
    n_niveis(i)=length(sondagem(i).Nspt);
    for j=1:n_niveis(i)
        cont=cont+1;
        profundidade=(j-1);
        x(cont)=sondagem(i).x;
        z(cont)=sondagem(i).nivel_terreno-profundidade;
        switch sondagem(i).tipo_solo(j)  % 1 para areia e 2 para argila
            case 1 % Areia
                if sondagem(i).Nspt(j)<=8
                    peso_especifico_solo(cont)=16;%kN/m^3
                elseif and(sondagem(i).Nspt(j)>8,sondagem(i).Nspt(j)<=18)
                    peso_especifico_solo(cont)=17;%kN/m^3
                elseif sondagem(i).Nspt(j)>18
                    peso_especifico_solo(cont)=18;%kN/m^3
                end
            case 2 % Argila
                if sondagem(i).Nspt(j)<=2
                    peso_especifico_solo(cont)=13;%kN/m^3
                elseif and(sondagem(i).Nspt(j)>2,sondagem(i).Nspt(j)<=5)
                    peso_especifico_solo(cont)=15;%kN/m^3
                elseif and(sondagem(i).Nspt(j)>5,sondagem(i).Nspt(j)<=10)
                    peso_especifico_solo(cont)=17;%kN/m^3
                elseif and(sondagem(i).Nspt(j)>10,sondagem(i).Nspt(j)<=19)
                    peso_especifico_solo(cont)=19;%kN/m^3
                elseif sondagem(i).Nspt(j)>19
                    peso_especifico_solo(cont)=21;%kN/m^3
                end
        end
        
    end
end



F = scatteredInterpolant(transpose(x),transpose(z),transpose(peso_especifico_solo));
F.ExtrapolationMethod = 'nearest';
F.Method = 'linear';


peso_especifico_solo=F;


end