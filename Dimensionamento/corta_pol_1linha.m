function [xcor,ycor,situacao,msg_erro] = corta_pol_1linha(secao,cortar)
%Reparte a poligonal na coordenada cortar
%   Originalmente inspirado no algoritimo do Lauro Modesto e editado
%   u é coordenada horizontal
%   w é coordenada vertical

situacao=true;
msg_erro='sem erro';

[nv,~]=size(secao);
w=secao(:,2);
u=secao(:,1);
% w(nv+1)=w(1);%verificar
% u(nv+1)=u(1);%verificar


[~,scortar]=size(cortar);
cont=1;
for nc=1:scortar
    k=0;
if nc>1
    [~,nv]=size(y);
    w=y;
    u=x;
end
    for i=1:nv-1
        %                                                        caso
        % Se a linha cruza a coordenada do vetor cortar então                               3
        %caso=1 - adiciona o nó final na nova poligonal
        %caso=2 - Corta o trecho
       
        caso=1;
        if (and(w(i+1)<=cortar(nc),w(i)>=cortar(nc)))
            caso=2;
        elseif (and(w(i+1)>=cortar(nc),w(i)<=cortar(nc)))
            caso=2;
        end
        
        switch caso
            case 1 %adiciona o nó final na nova poligonal
                k=k+1;
            case 2 %caso=2 - Corta o trecho
                k=k+1;
                %%%% Ini do SPtCorte
                deltaw=w(i+1)-w(i);
                deltau=u(i+1)-u(i);
                if deltau==0
                    y(k)=cortar(nc);
                    x(k)=u(i);
                    xcor(cont)=x(k);
                    ycor(cont)=y(k);
                    cont=cont+1;
                else
                    y(k)=cortar(nc);
                    tg=deltaw/deltau;
                    x(k)=u(i)-(w(i)-cortar(nc))/tg;
                    xcor(cont)=x(k);
                    ycor(cont)=y(k);
                    cont=cont+1;
                end
                k=k+1;
        end
    end    
end


if not(exist('xcor','var'))
    xcor = -9999;
    ycor = -9999;
    situacao = false;
    msg_erro = 'O corte da seção transversal falhou.';
end
%draw_secaoeno

end

