function ct= RFT2ct(viaduto,info)
%Aplica variação de temperatura nas longarinas dos tabuleiros

alfa=viaduto.cdl;%ºC^-1 %Coeficiente de Dilatação Linear do Concreto
cont=0;
for k=1:viaduto.n_apoios-1
    n_longa=viaduto.vao(k).n_longarinas;
    for g=1:n_longa
        m=info.longarinas.vao(k).longarina(g).membros;%membro
        %[Barra Variação_de_temp coeficiente_de_dilatação]
        cont=cont+1;
        ct{cont}=[m info.longarinas.vao(k).longarina(g).var_T alfa];
    end
end

ct=vertcat(ct{:});
end

