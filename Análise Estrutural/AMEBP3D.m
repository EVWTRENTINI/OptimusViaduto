function [d,v,F,R,Qf,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig] = AMEBP3D(nb,nn,lb,r,T,joints,jb,jfix,broty,LC,A,E,G,Iy,Iz,J,brig,brig_ex,aflex,relatorio_tempo)
%Análise matricial elastica de barras prismaticas 3D
%   Calcula as forças na extremidade das barras e as reações de apoio e
%   deformações

%Calcula matriz de rigidez
if relatorio_tempo
    tic
    fprintf('Construção e inversão da matriz de rigidez... '); 
end


[K,S,Su,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig] =...
constroi_KeS(joints,jb,jfix,broty,A,E,G,Iy,Iz,J,brig,brig_ex,aflex,nb,lb,r,T);

if relatorio_tempo; toc; end

%Avalia o caso de carregamento
%Transfere as forças aplicadas entre nós para forças nos nós
if relatorio_tempo; tic; end

[~,nLC]=size(LC);
[ngl,~]=size(invSu);
d=zeros(ngl,nLC);
v=zeros(12,nb,nLC);
F=zeros(12,nb,nLC);
R=zeros(ngl,nLC);
Qf=zeros(12,nb,nLC);

if relatorio_tempo; fprintf(['Avaliação de ' num2str(nLC) ' casos de carregamento...     '] ); end

for i=1:nLC
    
    Qf(:,:,i)=...
    transpose(fixedreaction(LC(i).cd,LC(i).cc,LC(i).ct,jb,joints,broty,A,E));

    [d(:,i),v(:,:,i),F(:,:,i),R(:,i)]=...
    aval_cc(Qf(:,:,i),LC(i).jl,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig,T,nb,nn);
    
end
if relatorio_tempo; toc; end
end

