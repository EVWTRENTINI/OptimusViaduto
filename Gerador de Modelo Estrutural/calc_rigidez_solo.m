function rigidez_solo=calc_rigidez_solo(sondagem)
n_furos=length(sondagem);




cont=0;
for i=1:n_furos
    n_niveis(i)=length(sondagem(i).Nspt);
    for j=1:n_niveis(i)
        cont=cont+1;
        rigidez_solo.x(cont)=sondagem(i).x;
        profundidade=(j-1);
        rigidez_solo.z(cont)=sondagem(i).nivel_terreno-profundidade;
        if sondagem(i).tipo_solo(j)==2% Para areia ou argila mole
                rigidez_solo.K(cont)=sondagem(i).Nspt(j)*1.0*10^6;
        elseif sondagem(i).tipo_solo(j)==1 % Para argila pré-adensada
            if rigidez_solo.z(cont)>sondagem(i).nivel_agua
                rigidez_solo.K(cont)=sondagem(i).Nspt(j)*1.6*10^6*profundidade;
            else
                rigidez_solo.K(cont)=sondagem(i).Nspt(j)*1.0*10^6*profundidade;
            end
        end
    end
end



F = scatteredInterpolant(transpose(rigidez_solo.x),transpose(rigidez_solo.z),transpose(rigidez_solo.K));
F.ExtrapolationMethod = 'nearest';
F.Method = 'linear';


rigidez_solo.F=F;



% for i=1:n_furos
%     zmin(i)=sondagem(i).nivel_terreno-length(sondagem(i).Nspt);
% end
% x = sondagem(1).x:1:sondagem(end).x;
% z = min(zmin):.5:max([sondagem.nivel_terreno]);
% [Xq,Zq] = meshgrid(x,z);
% 
% Kq=F(Xq,Zq);
% mesh(Xq,Zq,Kq)
% hold on
% scatter3(rigidez_solo.x,rigidez_solo.z,rigidez_solo.K)
% hold off
% 
% 
%%%%%%%%%% Desenho %%%%%%%%%%%%%
% t = delaunay(rigidez_solo.x,rigidez_solo.z);
% trisurf(t,rigidez_solo.x,rigidez_solo.K/10000000,rigidez_solo.z);
% axis equal vis3d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% 
% hold on
% Kq2 = rbfinterp([Xq(:)';Zq(:)'], rbfcreate([rigidez_solo.x;rigidez_solo.z], rigidez_solo.K,'RBFFunction', 'linear'));
% Kq2 = reshape(Kq2, size(Xq));
% mesh(Xq,Zq,Kq2)
% hold off

end