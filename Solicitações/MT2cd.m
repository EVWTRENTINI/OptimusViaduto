function cd = MT2cd(MT,ntx,fauchart,r,viaduto,info)
%Calcula os carregamentos concetrados causados por uma carga distribuida
%sobre um tabuleiro
%   Seleciona quais barras do processo de Fauchar estão carregadas
k=MT.tabuleiro;
Rf=cd_fauchart(MT,fauchart(k).Kf,fauchart(k).invKfu,fauchart(k).Lf,fauchart(k).Lfacum,viaduto.W);
if ntx==1
    cd=cd_tabuleiro(Rf,0,1,k,r,info);
else
    cd=cd_tabuleiro(Rf,MT.inix,MT.fimx,k,r,info);
end
end

