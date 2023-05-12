function [Nx,Vy,Vz,Tx,My,Mz] = calc_esf(cc,cd,lb,nb,F,T,xb,tot_ponto)
%Calcula os esforços internos da estrutura
%   calcula os esforços internos na discretização escolhida, nas posições
%   das cargas concentradas, e no inicio e no final das cargas distribuidas

[nbcc,~]=size(cc);
[nbcd,~]=size(cd);

Nx=zeros(size(xb),'single');
Vy=zeros(size(xb),'single');
Vz=zeros(size(xb),'single');
Tx=zeros(size(xb),'single');
My=zeros(size(xb),'single');
Mz=zeros(size(xb),'single');

Q=zeros(12,nb);

for n=1:nb
    Q(:,n)=T(:,:,n)*F(:,n);
    
    for n_ponto=1:tot_ponto(n)
        xb(n_ponto,n)=(lb(n)/(tot_ponto(n)-1))*(n_ponto-1);
        Nx(n_ponto,n)=-Q(1,n);
        Vy(n_ponto,n)= Q(2,n);
        Vz(n_ponto,n)= Q(3,n);
        Tx(n_ponto,n)=-Q(4,n);
        My(n_ponto,n)= Q(5,n)+Q(3,n)*xb(n_ponto,n);%ADICIONAR CORTANTE
        Mz(n_ponto,n)=-Q(6,n)+Q(2,n)*xb(n_ponto,n);%ADICIONAR CORTANTE
    end 
end
for linhacc=1:nbcc %Carregamentos concentradas em barra
    n=cc(linhacc,1);%numero da barra
    xp=cc(linhacc,3)*lb(n);%posição do carregamento
    if cc(linhacc,2)==1%Esforço normal
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xp%se o ponto esta depois da carga
                Nx(n_ponto,n)=Nx(n_ponto,n)-cc(linhacc,4);
            end
        end
    elseif cc(linhacc,2)==2%Esforço cortante y
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xp%se o ponto esta depois da carga
                Vy(n_ponto,n)=Vy(n_ponto,n)+cc(linhacc,4);
                Mz(n_ponto,n)=Mz(n_ponto,n)+cc(linhacc,4)*(xb(n_ponto,n)-xp);
            end
        end
    elseif cc(linhacc,2)==3%Esforço cortante z
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xp%se o ponto esta depois da carga
                Vz(n_ponto,n)=Vz(n_ponto,n)+cc(linhacc,4);
                My(n_ponto,n)=My(n_ponto,n)+cc(linhacc,4)*(xb(n_ponto,n)-xp);
            end
        end
    elseif cc(linhacc,2)==4%Esforço de torção x
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xp%se o ponto esta depois da carga
                Tx(n_ponto,n)=Tx(n_ponto,n)-cc(linhacc,4);
            end
        end
    elseif cc(linhacc,2)==5%Esforço de momento em y
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xp%se o ponto esta depois da carga
                My(n_ponto,n)=My(n_ponto,n)+cc(linhacc,4);
            end
        end
    elseif cc(linhacc,2)==6%Esforço de momento em z
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xp%se o ponto esta depois da carga
                Mz(n_ponto,n)=Mz(n_ponto,n)-cc(linhacc,4);
            end
        end
    end
end
for linhacd=1:nbcd %Carregamentos dist em barra
    n=cd(linhacd,1);%numero da barra
    xqi=cd(linhacd,3)*lb(n);%posição inicio do carregamento
    xqf=cd(linhacd,4)*lb(n);%posição inicio do carregamento
    
    
    
    
    if cd(linhacd,2)==1%Esforço normal
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xqi%se o ponto esta depois da carga
                if xb(n_ponto,n)<=xqf
                    Nx(n_ponto,n)=Nx(n_ponto,n)-cd(linhacd,5)*(xb(n_ponto,n)-xqi);
                elseif (xb(n_ponto,n)>xqf && xb(n_ponto,n)>xqi)
                    Nx(n_ponto,n)=Nx(n_ponto,n)-cd(linhacd,5)*(xqf-xqi);
                end
               
            end
        end
       
    elseif cd(linhacd,2)==2%Esforço cortante y
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xqi%se o ponto esta depois da carga
                if xb(n_ponto,n)<=xqf
                    Vy(n_ponto,n)=Vy(n_ponto,n)+cd(linhacd,5)*(xb(n_ponto,n)-xqi);
                    Mz(n_ponto,n)=Mz(n_ponto,n)+cd(linhacd,5)*(xb(n_ponto,n)-xqi)^2/2;
                elseif (xb(n_ponto,n)>xqf && xb(n_ponto,n)>xqi)
                    Vy(n_ponto,n)=Vy(n_ponto,n)+cd(linhacd,5)*(xqf-xqi);
                    Mz(n_ponto,n)=Mz(n_ponto,n)+cd(linhacd,5)*(xqf-xqi)*(xb(n_ponto,n)-xqf+(xqf-xqi)/2);
                end
            end
        end
    elseif cd(linhacd,2)==3%Esforço cortante z
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xqi%se o ponto esta depois da carga
                if xb(n_ponto,n)<=xqf
                    Vz(n_ponto,n)=Vz(n_ponto,n)+cd(linhacd,5)*(xb(n_ponto,n)-xqi);
                    My(n_ponto,n)=My(n_ponto,n)+cd(linhacd,5)*(xb(n_ponto,n)-xqi)^2/2;
                elseif (xb(n_ponto,n)>xqf && xb(n_ponto,n)>xqi)
                    Vz(n_ponto,n)=Vz(n_ponto,n)+cd(linhacd,5)*(xqf-xqi);
                    My(n_ponto,n)=My(n_ponto,n)+cd(linhacd,5)*(xqf-xqi)*(xb(n_ponto,n)-xqf+(xqf-xqi)/2);
                end
            end
        end
    elseif cd(linhacd,2)==4%Esforço de torção x
        for n_ponto=1:tot_ponto(n)%percorre todos os pontos
            if xb(n_ponto,n)>xqi%se o ponto esta depois da carga
                if xb(n_ponto,n)<=xqf
                    Tx(n_ponto,n)=Tx(n_ponto,n)-cd(linhacd,5)*(xb(n_ponto,n)-xqi);
                elseif (xb(n_ponto,n)>xqf && xb(n_ponto,n)>xqi)
                    Tx(n_ponto,n)=Tx(n_ponto,n)-cd(linhacd,5)*(xqf-xqi);
                end
            end
        end
    end
end



%%%%%Transforma de matriz para cell array para economizar memoria%%%%%%%
% Nxc=cell(1,nb);
% Vyc=cell(1,nb);
% Vzc=cell(1,nb);
% Txc=cell(1,nb);
% Myc=cell(1,nb);
% Mzc=cell(1,nb);
% 
%  for n=1:nb
%      Nxc{n}=Nx(1:tot_ponto(n),n);
%      Vyc{n}=Vy(1:tot_ponto(n),n);
%      Vzc{n}=Vz(1:tot_ponto(n),n);
%      Txc{n}=Tx(1:tot_ponto(n),n);
%      Myc{n}=My(1:tot_ponto(n),n);
%      Mzc{n}=Mz(1:tot_ponto(n),n);
%  end


end


