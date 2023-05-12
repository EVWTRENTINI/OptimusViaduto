function [Nx,Vy,Vz,Tx,My,Mz,xb,tot_ponto]= LC2esf(disc_max,LC,lb,nb,F,T)
%Calcula o esforço para todos os casos de carregamento
%   Aplica a função calc_esf para todos os casos de carregamentos

[~,nLC]=size(LC);



%Verifica o numero de pontos e garante que seja impar
maxpoint=(ceil(max(lb)/disc_max)+1);
if mod(maxpoint,2)==0 %se for par
    xb=zeros(maxpoint+1,nb);
else
    xb=zeros(maxpoint,nb);    
end
%Cria a discretização ao longo do comprimento da barra
tot_ponto=zeros(1,nb);
for n=1:nb
    tot_ponto(n)=ceil(lb(n)/disc_max)+1;
    
    if mod(tot_ponto(n),2)==0 %se for par
        tot_ponto(n)=tot_ponto(n)+1;
    end
    
    for n_ponto=1:tot_ponto(n)
        xb(n_ponto,n)=(lb(n)/(tot_ponto(n)-1))*(n_ponto-1);
    end
    
end

 Nx=zeros([size(xb) nLC],'single');
 Vy=zeros([size(xb) nLC],'single');
 Vz=zeros([size(xb) nLC],'single');
 Tx=zeros([size(xb) nLC],'single');
 My=zeros([size(xb) nLC],'single');
 Mz=zeros([size(xb) nLC],'single');


%ARRAY OF MATRIX
for CC=1:nLC
[Nx(:,:,CC),Vy(:,:,CC),Vz(:,:,CC),Tx(:,:,CC),My(:,:,CC),Mz(:,:,CC)]=...
calc_esf(LC(CC).cc,LC(CC).cd,lb,nb,F(:,:,CC),T,xb,tot_ponto);
end


%%CELL ARRAY
% 
% Nx=cell(1,nLC);
% Vy=cell(1,nLC);
% Vz=cell(1,nLC);
% Tx=cell(1,nLC);
% My=cell(1,nLC);
% Mz=cell(1,nLC);
% 
% for CC=1:nLC
% [Nx{CC},Vy{CC},Vz{CC},Tx{CC},My{CC},Mz{CC}]=...
% calc_esf(LC(CC).cc,LC(CC).cd,lb,nb,F(:,:,CC),T,xb,tot_ponto);
% end



end
