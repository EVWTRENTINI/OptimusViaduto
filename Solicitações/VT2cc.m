function cc = VT2cc(VT,fauchart,r,viaduto,info)
%Calcula os carregamentos concetrados causados por uma posição do veiculo
%tipo
%   Seleciona qual vão esta cerregado para posteriormente aplicar o
%   processo de Fauchart.
cont=0;
p=VT.p;
for k=1:viaduto.n_apoios-1
limitevao(k).b=info.longarinas.vao(k).longarina(1).xb;
limitevao(k).e=info.longarinas.vao(k).longarina(1).xe;
end
for eixo=1:1:3 %Para cada eixo do veiculo tipo
    X=VT.X+(eixo-2)*1.5;
    if X<limitevao(1).b %Verifica se não esta na primeira laje de aproximação
        %['O eixo ' num2str(eixo) ' esta antes de começar']
        k=1;
        for roda=[-1 +1]
            [Rf] = cc_fauchart(p,VT.Y+roda,fauchart(k).Kf,fauchart(k).invKfu,fauchart(k).Lf,fauchart(k).Lfacum,viaduto.W);
            cont=cont+1;
            cc{:,:,cont}=cc_tabuleiro(limitevao(k).b,Rf,k,r,info);
        end
    elseif X>limitevao(viaduto.n_apoios-1).e %Verifica se não esta no final da ultima laje de aproximação
        %['O eixo ' num2str(eixo) ' esta depois de acabar']
        k=viaduto.n_apoios-1;
        for roda=[-1 +1]
            [Rf] = cc_fauchart(p,VT.Y+roda,fauchart(k).Kf,fauchart(k).invKfu,fauchart(k).Lf,fauchart(k).Lfacum,viaduto.W);
            cont=cont+1;
            cc{:,:,cont}=cc_tabuleiro(limitevao(k).e-limitevao(k).b,Rf,k,r,info);
        end
    else %Se entrar aqui é porque esta dentro do viaduto
        for k=1:viaduto.n_apoios-1 %Conferir dentro de um vao
            if X>=limitevao(k).b && X<=limitevao(k).e
                %['O eixo ' num2str(eixo) ' esta no vao ' num2str(k)]
                for roda=[-1 +1]
                    [Rf] = cc_fauchart(p,VT.Y+roda,fauchart(k).Kf,fauchart(k).invKfu,fauchart(k).Lf,fauchart(k).Lfacum,viaduto.W);
                    cont=cont+1;
                    cc{:,:,cont}=cc_tabuleiro(X-limitevao(k).b,Rf,k,r,info);
                end
            end
        end
        for k=2:viaduto.n_apoios-1 %confere se esta sobre um apoio
            if X>limitevao(k-1).e && X<limitevao(k).b
                %['O eixo ' num2str(eixo) ' esta entre os vãos ' num2str(k-1) ' e ' num2str(k)]
                folga=limitevao(k).b-limitevao(k-1).e;
                xf=X-limitevao(k-1).e;
                a=xf/folga;
                b=(folga-xf)/folga;
                for roda=[-1 +1]
                    [Rf] = cc_fauchart(p*b,VT.Y+roda,fauchart(k-1).Kf,fauchart(k-1).invKfu,fauchart(k-1).Lf,fauchart(k-1).Lfacum,viaduto.W);
                    cont=cont+1;
                    cc{:,:,cont}=cc_tabuleiro(limitevao(k-1).e-limitevao(k-1).b,Rf,k-1,r,info);
                end
                for roda=[-1 +1]
                    [Rf] = cc_fauchart(p*a,VT.Y+roda,fauchart(k).Kf,fauchart(k).invKfu,fauchart(k).Lf,fauchart(k).Lfacum,viaduto.W);
                    cont=cont+1;
                    cc{:,:,cont}=cc_tabuleiro(0,Rf,k,r,info);
                end
            end
        end
    end
end
%cc=num2cell(cc, [1 2]);
cc=vertcat(cc{:});
end

