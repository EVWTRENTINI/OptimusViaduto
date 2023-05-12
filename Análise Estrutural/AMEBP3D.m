function [d,v,F,R,Qf,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig] = AMEBP3D(nb,nn,lb,r,T,joints,jb,jfix,broty,LC,A,E,G,Iy,Iz,J,brig,brig_ex,aflex,relatorio_tempo)
%An�lise matricial elastica de barras prismaticas 3D
%   Calcula as for�as na extremidade das barras e as rea��es de apoio e
%   deforma��es

%Calcula matriz de rigidez
if relatorio_tempo
    tic
    fprintf('Constru��o e invers�o da matriz de rigidez... '); 
end


[K,S,Su,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig] =...
constroi_KeS(joints,jb,jfix,broty,A,E,G,Iy,Iz,J,brig,brig_ex,aflex,nb,lb,r,T);

if relatorio_tempo; toc; end

%Avalia o caso de carregamento
%Transfere as for�as aplicadas entre n�s para for�as nos n�s
if relatorio_tempo; tic; end

[~,nLC]=size(LC);
[ngl,~]=size(invSu);
d=zeros(ngl,nLC);
v=zeros(12,nb,nLC);
F=zeros(12,nb,nLC);
R=zeros(ngl,nLC);
Qf=zeros(12,nb,nLC);

if relatorio_tempo; fprintf(['Avalia��o de ' num2str(nLC) ' casos de carregamento...     '] ); end

for i=1:nLC
    
    Qf(:,:,i)=...
    transpose(fixedreaction(LC(i).cd,LC(i).cc,LC(i).ct,jb,joints,broty,A,E));

    [d(:,i),v(:,:,i),F(:,:,i),R(:,i)]=...
    aval_cc(Qf(:,:,i),LC(i).jl,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig,T,nb,nn);
    
end
if relatorio_tempo; toc; end
end

