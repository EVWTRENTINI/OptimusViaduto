function [ap,situacao,msg_erro] = aloja_faixas_armadura(secao,As,folga_ver,fi_t,dr_As,c,Asmin_y_i,Asmin_y_f,Asmax_y_i,Asmax_y_f,As_max,As_min,longa_fi_long_min,longa_fi_long_max,config_draw)
%Aloja faixas de armadura na seção transversal
%   As entra em m² e sai em cm²

situacao=true;
msg_erro='sem erro';


As_y_i=Asmin_y_i+((Asmax_y_i-Asmin_y_i)/(As_max-As_min))*(As-As_min);
As_y_f=Asmin_y_f+((Asmax_y_f-Asmin_y_f)/(As_max-As_min))*(As-As_min);

fi_l=longa_fi_long_min+((longa_fi_long_max-longa_fi_long_min)/(As_max-As_min))*(As-As_min);



offset=c+fi_t+fi_l/2;
[offs_l.x,offs_l.y] = offsetCurve(transpose(secao(1:end-1,1)),transpose(secao(1:end-1,2)), offset);


[~,ind]=mink(offs_l.y,2);%y da primeira camada e indice


cont=0;
offs_cort=([transpose(offs_l.x) transpose(offs_l.y)]);%offset para o corte
[~,ind]=mink(offs_cort(:,2),2);%y da primeira camada e indice
offs_cort(ind,2)=offs_cort(ind,2)-.1;%folga pra cortar em cima

if As_y_f>=max(offs_cort(:,2))*.999
    situacao=false;
    msg_erro=['Faixa de armadura alojada para fora da seção transversal'];
    ap='erro';
end

if situacao
    if (As_y_f-As_y_i)<=0
        cortar=As_y_i;
        cont=cont+1;
        [camada(cont).x,camada(cont).y,situacao,msg_erro] =  corta_pol_1linha(offs_cort,cortar);
        if not(situacao); ap='erro'; return; end
    else
        for cortar=As_y_i:(As_y_f-As_y_i)/(dr_As-1):As_y_f
            
            
            cont=cont+1;
            [camada(cont).x,camada(cont).y,situacao,msg_erro] =  corta_pol_1linha(offs_cort,cortar);
            if not(situacao); ap='erro'; return; end
        end
    end
    
    nc=cont;
    for i=1:nc
        camada(i).l=camada(i).x(2)-camada(i).x(1);
    end
    l_total=sum([camada.l]);
    
    for i=1:nc
        camada(i).As=As*camada(i).l/l_total;
    end
    
    ap.x=zeros(1,nc);
    ap.y=zeros(1,nc);
    ap.A=zeros(1,nc);%*As_1bar*1E4;%cm²;
    ap.n=nc;
    for i=1:nc
        ap.x(i)=(camada(i).x(1)+camada(i).x(2))/2;
        ap.y(i)=(camada(i).y(1)+camada(i).y(2))/2;
        ap.A(i)=camada(i).As*1E4;%cm²
    end
    
    %desenho
    if config_draw.alojamento_faixas_longa
        draw_alojamento_faixas_longa
    end
end
ap.camada=camada;
end


