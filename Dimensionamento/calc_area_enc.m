function [area_enc,B,nt] = calc_area_enc(Sigenc,cabo,n,config_draw)
%Calcula área entre diagramas de atrito
%   Em função da tensão na cunha ja acomodada, calcula a área entre o 
%diagrama de atrito antes e depois da acomodação da cunha
ndc=size(cabo(n).x)-3;
ndc(1)=[];
   B(ndc+3)=0;
    B(1)=cabo(n).Sigx(1)-Sigenc;
    nt=0;%numero de trapezios, sendo o primeiro de área nula
    for i=2:ndc+3
        B(i)=(cabo(n).Sigx(i)-cabo(n).Sigx(i-1))*2+B(i-1);
        if B(i)>0
            nt=nt+1;
        end
    end

    
    %Área dos trapezios
    area_enc(nt+2)=0;
    area_enc(1)=0;
    for i=2:nt+1
        area_enc(i)=(B(i)+B(i-1))*(cabo(n).x(i)-cabo(n).x(i-1))/2;
    end
    if nt==ndc+2%Se as duas linhas não cruzarem
    else
        %Área do triangulo
        a=(B(nt+1)-B(nt+2))/(cabo(n).x(nt+2)-cabo(n).x(nt+1));
        htri=B(nt+1)/a;
        area_enc(nt+2)=B(nt+1)*htri/2;
    end
    if config_draw.encunhamento
        draw_encunhamento
    end
    

end

