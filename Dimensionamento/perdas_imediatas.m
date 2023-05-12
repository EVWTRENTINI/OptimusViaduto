function [cabo,SigPi,situacao,msg_erro] = perdas_imediatas(cabo,viaduto,config_draw)
%Calcula as perdas por atrito e acomodação da ancoragem
%   
situacao=true;
msg_erro='sem erro';

[~,ntc]=size(cabo);%numero total de cabos
[~,ndc]=size(cabo(1).x);%numero de discretização do traçado do cabo
ndc=ndc-3;

if config_draw.encunhamento
    figure
end
for n=1:ntc
    lt(ndc+2)=cabo(n).x(ndc+3)-cabo(n).x(ndc+2);
    for i=2:ndc+2
        lt(i-1)=cabo(n).x(i)-cabo(n).x(i-1);
    end
    %% Angulo com a horizontal
    cabo(n).teta_h(ndc+2)=0;
    for i=1:ndc+2
        cabo(n).teta_h(i)=atan((cabo(n).y(i)-cabo(n).y(i+1))/(cabo(n).x(i+1)-cabo(n).x(i)));
    end
    %plot(cabo(n).teta_h*180/pi())
    %% Alfa - Disvio angular no nó
    cabo(n).alfa(ndc+3)=0;
    cabo(n).alfa(1)=0;
    for i=2:ndc+2
        cabo(n).alfa(i)=abs(cabo(n).teta_h(i)-cabo(n).teta_h(i-1));
    end
    %plot(cabo(n).alfa)
    %% Somatoria de alfa
    cabo(n).S_alfa(ndc+3)=0;
    cabo(n).S_alfa(1)=0;
    for i=2:ndc+2
        alfapormetro=cabo(n).alfa(i)/(lt(i-1)+lt(i));% Desvio angular que ocorre entre dois trechos por isso soma os comprimentos
        cabo(n).S_alfa(i)=cabo(n).S_alfa(i-1)+alfapormetro*lt(i-1);
    end
    cabo(n).S_alfa(ndc+3)=cabo(n).S_alfa(ndc+2)+alfapormetro*lt(ndc+2);

    %% Tensão no cabo no momento da protensão
    SigPi=min([viaduto.limite_Pi_fptk*1.15*viaduto.fptd viaduto.limite_Pi_fpyk*1.15*viaduto.fpyd]);%kN/cm²
    cabo(n).Sigx(1)=SigPi;
    for i=2:ndc+3
        cabo(n).Sigx(i)=SigPi*exp(-(viaduto.mi*cabo(n).S_alfa(i)+viaduto.ka*cabo(n).x(i)));
    end
    
    %% Tensão no cabo após a acomodação da ancoragem
    area_enc_obj=viaduto.acomodacao_anc*viaduto.Ep;   
    conttestes=0;
    limite_dif_A=0.001;
    limite_iteracoes=100;
    dif_A=limite_dif_A+1;%só pra entrar no while
    Sigenc_inf=0;
    Sigenc_sup=SigPi;
    
    %%%%%%%%%%%%%%%%%%%%%%%Método da bisseção%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    while (abs(dif_A)>limite_dif_A && conttestes<limite_iteracoes)
        conttestes=conttestes+1;
        Sigenc=(Sigenc_sup+Sigenc_inf)/2;
        [area_enc,B,nt] = calc_area_enc(Sigenc,cabo,n,config_draw);
        Sarea_enc=sum(area_enc);
        dif_A=area_enc_obj-Sarea_enc;
        if dif_A>=0
            Sigenc_sup=Sigenc;
        end
        if dif_A<0
            Sigenc_inf=Sigenc;
        end
    end
    if conttestes==limite_iteracoes
        situacao=false;
        msg_erro=['Encunhamento não convergiu dentro do limite de iterações']
    end
    
    %% Tensão apos o encunhamento
    %Parte que deslisou 
    for i=1:nt+1
        cabo(n).Sigx_enc(i)=(cabo(n).Sigx(i)-B(i));
    end
    %Parte que não deslisou
    for i=nt+2:ndc+3
        cabo(n).Sigx_enc(i)=(cabo(n).Sigx(i));
    end
end

end
