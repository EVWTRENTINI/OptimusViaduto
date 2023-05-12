function [cabo_eq_ato,cabo_eq_enc] = calc_cabo_eq(cabo,ntc,ndc,area_cabos,config_draw)
%
%
%ntc - numero total de cabos
%ndc - numero de discretização do traçado do cabo

%% Ato da protensão
fr(1:ndc+3)=0;
for n=1:ntc
    tensao=cabo(n).Sigx;
    for i=1:ndc+3
        fr(i)=fr(i)+area_cabos(n)*tensao(i);
    end
end

cabo_eq_ato.x=cabo(1).x;
cabo_eq_ato.y(ndc+3)=0;
cabo_eq_ato.Sig(ndc+3)=0;
cabo_eq_ato.A=sum(area_cabos);
for n=1:ntc
    tensao=cabo(n).Sigx;
    for i=1:ndc+3
        frn=area_cabos(n)*tensao(i);%força resultante
        ctb=frn/fr(i);%contribição no total
        cabo_eq_ato.y(i)=cabo_eq_ato.y(i)+cabo(n).y(i)*ctb;
        cabo_eq_ato.Sig(i)=cabo_eq_ato.Sig(i)+tensao(i)*ctb;
    end
end

%% Após o encunhamento
fr(1:ndc+3)=0;
for n=1:ntc
    tensao=cabo(n).Sigx_enc;
    for i=1:ndc+3
        fr(i)=fr(i)+area_cabos(n)*tensao(i);
    end
end

cabo_eq_enc.x=cabo(1).x;
cabo_eq_enc.y(ndc+3)=0;
cabo_eq_enc.Sig(ndc+3)=0;
cabo_eq_enc.A=sum(area_cabos);
for n=1:ntc
    tensao=cabo(n).Sigx_enc;
    for i=1:ndc+3
        frn=area_cabos(n)*tensao(i);%força resultante
        ctb=frn/fr(i);%contribição no total
        cabo_eq_enc.y(i)=cabo_eq_enc.y(i)+cabo(n).y(i)*ctb;
        cabo_eq_enc.Sig(i)=cabo_eq_enc.Sig(i)+tensao(i)*ctb;
    end
end

%% Desenha traçado do cabo
if config_draw.tracado_cabo
    draw_tracado_cabo
end
%% Desenha tensão no cabo durante o ato e após o encunhamento
if config_draw.tensao_cabo_ato_enc
    draw_tensao_cabo_ato_enc
end





end



