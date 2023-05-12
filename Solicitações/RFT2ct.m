function ct= RFT2ct(viaduto,info)
%Aplica varia��o de temperatura nas longarinas dos tabuleiros

alfa=viaduto.cdl;%�C^-1 %Coeficiente de Dilata��o Linear do Concreto
cont=0;
for k=1:viaduto.n_apoios-1
    n_longa=viaduto.vao(k).n_longarinas;
    for g=1:n_longa
        m=info.longarinas.vao(k).longarina(g).membros;%membro
        %[Barra Varia��o_de_temp coeficiente_de_dilata��o]
        cont=cont+1;
        ct{cont}=[m info.longarinas.vao(k).longarina(g).var_T alfa];
    end
end

ct=vertcat(ct{:});
end

