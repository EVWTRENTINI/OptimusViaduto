function [z,uc] = corta_pol(secao,cortar)
%Reparte a poligonal nas coordenadas do vetor cortar
%   Originalmente inspirado no algoritimo do Lauro Modesto
%   uc é coordenada horizontal
%   z é coordenada vertical
[nv,~]=size(secao);
w=secao(:,2);
u=secao(:,1);
% w(nv+1)=w(1);%verificar
% u(nv+1)=u(1);%verificar


[~,scortar]=size(cortar);
%% CONTAR
numero_de_linhas_adicionais=zeros(1,scortar);
for nc=1:scortar
    for i=1:nv-1
        caso=1;
        if     (and(w(i+1)<cortar(nc),w(i)>cortar(nc)))
            caso=2;
        elseif (and(w(i+1)>cortar(nc),w(i)<cortar(nc)))
            caso=2;
        end
        if caso==2
            numero_de_linhas_adicionais(nc)=numero_de_linhas_adicionais(nc)+1;
        end
    end
end


w(1:nv)=secao(:,2);
u(1:nv)=secao(:,1);

%% CORTAR
for nc=1:scortar
    k=0;
if nc>1
    [~,nv]=size(z);
    w=z;
    u=uc;
    z=zeros(1,numero_de_linhas_adicionais(nc)+nv);
    uc=zeros(1,numero_de_linhas_adicionais(nc)+nv);
end
    for i=1:nv-1
        %                                                        caso
        % Se a linha cruza a coordenada do vetor cortar então                               3
        %caso=1 - adiciona o nó final na nova poligonal
        %caso=2 - Corta o trecho
       
        caso=1;
        if (and(w(i+1)<cortar(nc),w(i)>cortar(nc)))
            caso=2;
        elseif (and(w(i+1)>cortar(nc),w(i)<cortar(nc)))
            caso=2;
        end
        
        switch caso
            case 1 %adiciona o nó final na nova poligonal
                k=k+1;
                z(k)=w(i+1);
                uc(k)=u(i+1);
            case 2 %caso=2 - Corta o trecho
                k=k+1;
                %%%% Ini do SPtCorte
                deltaw=w(i+1)-w(i);
                deltau=u(i+1)-u(i);
                if deltau==0
                    z(k)=cortar(nc);
                    uc(k)=u(i);
                else
                    z(k)=cortar(nc);
                    tg=deltaw/deltau;
                    uc(k)=u(i)-(w(i)-cortar(nc))/tg;
                end
                k=k+1;
                z(k)=w(i+1);
                uc(k)=u(i+1);
        end
    end
    z(k+1)=z(1);
    uc(k+1)=uc(1);
    
end



%draw_secaoeno

end

