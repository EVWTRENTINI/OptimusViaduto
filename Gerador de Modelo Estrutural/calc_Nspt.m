function Nspt=calc_Nspt(sondagem)
n_furos=length(sondagem);



cont=0;
for i=1:n_furos
    n_niveis(i)=length(sondagem(i).Nspt);
    for j=1:n_niveis(i)
        cont=cont+1;
        x(cont)=sondagem(i).x;
        profundidade=(j-1);
        z(cont)=sondagem(i).nivel_terreno-profundidade;
        
        Nspt(cont)=sondagem(i).Nspt(j);
        
    end
end

% t = delaunay(x,z);
% trisurf(t,x,Nspt/10,z);
% axis equal vis3d

F = scatteredInterpolant(transpose(x),transpose(z),transpose(Nspt));
F.ExtrapolationMethod = 'nearest';
F.Method = 'linear';


Nspt=F;


end