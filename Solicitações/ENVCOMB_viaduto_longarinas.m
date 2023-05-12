function [ENVLONGA, ENVLONGACR, ENVLONGACF, ENVLONGACQP, MFLECHA, ENVAPAPOIO] = ENVCOMB_viaduto_longarinas(info, tot_ponto, xb, Nx, Vz, Tx, My, rb, re, broty, viaduto)
CNF=1-.05*(viaduto.nfaixa-2);
if CNF<0.9
    CNF=0.9;
end

CIA=1.25;



[~,nvao]=size(info.longarinas.vao);

config_Mc;

%% Envoltória Especifica para longarinas - ELU

Mclonga=[Mc(1,1:2);Mc(4,1:2)];
Mclonga=[Mclonga(:,1) Mclonga(:,2)*CNF];%CIA é ADICIONADO DENTRO DO smartENV

for k=1:nvao
    [~,nlonga]=size(info.longarinas.vao(k).longarina);
    for j=1:ceil(nlonga/2)
        n=info.longarinas.vao(k).longarina(j).membros;
        %[ENV] = smartENV_longa(Fk,sp,Mc,info,CIA,xb)
        ENVbar=smartENV_longa(Vz(1:tot_ponto(n),n,:),tot_ponto(n),Mclonga,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGA.vao(k).longarina(j).MAX.Vz(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGA.vao(k).longarina(j).MIN.Vz(1:tot_ponto(n))=ENVbar.MIN;
        
        ENVbar=smartENV_longa(Tx(1:tot_ponto(n),n,:),tot_ponto(n),Mclonga,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGA.vao(k).longarina(j).MAX.Tx(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGA.vao(k).longarina(j).MIN.Tx(1:tot_ponto(n))=ENVbar.MIN;

        ENVbar=smartENV_longa(My(1:tot_ponto(n),n,:),tot_ponto(n),Mclonga,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGA.vao(k).longarina(j).MAX.My(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGA.vao(k).longarina(j).MIN.My(1:tot_ponto(n))=ENVbar.MIN;
        
        
    end
end
%% Envoltória Especifica para longarinas - ELS
% Combinação Rara
MclongaCR=[1 1*CNF];
for k=1:nvao
    [~,nlonga]=size(info.longarinas.vao(k).longarina);
    for j=1:ceil(nlonga/2)
        n=info.longarinas.vao(k).longarina(j).membros;
        
        ENVbar=smartENV_longa(My(1:tot_ponto(n),n,:),tot_ponto(n),MclongaCR,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGACR.vao(k).longarina(j).MAX.My(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGACR.vao(k).longarina(j).MIN.My(1:tot_ponto(n))=ENVbar.MIN;
    end
end


% Combinação Frequente
MclongaCF=[1 .5*CNF];
for k=1:nvao
    [~,nlonga]=size(info.longarinas.vao(k).longarina);
    for j=1:ceil(nlonga/2)
        n=info.longarinas.vao(k).longarina(j).membros;
        
        ENVbar=smartENV_longa(Vz(1:tot_ponto(n),n,:),tot_ponto(n),MclongaCF,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGACF.vao(k).longarina(j).MAX.Vz(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGACF.vao(k).longarina(j).MIN.Vz(1:tot_ponto(n))=ENVbar.MIN;
        
        ENVbar=smartENV_longa(Tx(1:tot_ponto(n),n,:),tot_ponto(n),MclongaCF,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGACF.vao(k).longarina(j).MAX.Tx(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGACF.vao(k).longarina(j).MIN.Tx(1:tot_ponto(n))=ENVbar.MIN;
                
        ENVbar=smartENV_longa(My(1:tot_ponto(n),n,:),tot_ponto(n),MclongaCF,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGACF.vao(k).longarina(j).MAX.My(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGACF.vao(k).longarina(j).MIN.My(1:tot_ponto(n))=ENVbar.MIN;
    end
end


% Combinação Quase Permanente
MclongaCQP=[1 psi_2*CNF];
for k=1:nvao
    [~,nlonga]=size(info.longarinas.vao(k).longarina);
    for j=1:ceil(nlonga/2)
        n=info.longarinas.vao(k).longarina(j).membros;

        ENVbar=smartENV_longa(My(1:tot_ponto(n),n,:),tot_ponto(n),MclongaCQP,info,CIA,xb(1:tot_ponto(n),n));
        ENVLONGACQP.vao(k).longarina(j).MAX.My(1:tot_ponto(n))=ENVbar.MAX;
        ENVLONGACQP.vao(k).longarina(j).MIN.My(1:tot_ponto(n))=ENVbar.MIN;

        MFLECHA.vao(k).longarina(j).MFLECHA=calc_MFLECHA(My(1:tot_ponto(n),n,:),tot_ponto(n),MclongaCQP,info,1,xb(1:tot_ponto(n),n));
        

    end
end




% plot(ENVLONGACF.vao(1).longarina(1).MAX.My)
% hold on
% plot(ENVLONGACF.vao(1).longarina(1).MIN.My)
% plot(ENVLONGACR.vao(1).longarina(1).MAX.My)
% plot(ENVLONGACR.vao(1).longarina(1).MIN.My)
% hold off


%% Envoltória Especifica para os aparelhos de apoio
[numero_barras_rotuladas, ~] = size(broty);
rotacao.rb = rb;
rotacao.re = re;
% Viaduto descarregado
Mc_aparelho_apoio = [1 0 1 0 0]; % Peso proprio e retração, fuencia e efeito de temperatura

for k=1:nvao
    nlonga=viaduto.vao(k).n_longarinas;
    for j=1:ceil(nlonga/2)
        for nap = [1 2] % numero do aparelho de apoio, 1 para o primeiro e 2 para o segundo
            n = info.apoios.vao(k).longarina(j).m_ap(nap);
            % Força normal
            ENVbar = smartENV(Vz(1:tot_ponto(n),n,:),tot_ponto(n),Mc_aparelho_apoio,info);
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MAX.Fg(1:tot_ponto(n))=ENVbar.MAX;
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MIN.Fg(1:tot_ponto(n))=ENVbar.MIN;

            % Força horizontal
            ENVbar = smartENV(Nx(1:tot_ponto(n),n,:),tot_ponto(n),Mc_aparelho_apoio,info);
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MAX.Hg(1:tot_ponto(n))=ENVbar.MAX;
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MIN.Hg(1:tot_ponto(n))=ENVbar.MIN;

            % Angulo de rotação
            switch nap; case 1; lado = 'rb'; case 2; lado = 're'; end
            barra_longarina = info.longarinas.vao(k).longarina(j).membros;
            ENVbar = smartENV(rotacao.(lado)(broty(:,1)==barra_longarina,:),1,Mc_aparelho_apoio,info);
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MAX.alfa_g=ENVbar.MAX;
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MIN.alfa_g=ENVbar.MIN;
        end
    end
end


% Viaduto carregado
Mc_aparelho_apoio = [0 1 0 0 0]; % Veiculo tipo, multidão e frenagem ou aceleração

for k=1:nvao
    nlonga=viaduto.vao(k).n_longarinas;
    for j=1:ceil(nlonga/2)
        for nap = [1 2] % numero do aparelho de apoio, 1 para o primeiro e 2 para o segundo
            n = info.apoios.vao(k).longarina(j).m_ap(nap);
            % Força normal
            ENVbar = smartENV(Vz(1:tot_ponto(n),n,:),tot_ponto(n),Mc_aparelho_apoio,info);
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MAX.Fq(1:tot_ponto(n))=ENVbar.MAX;
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MIN.Fq(1:tot_ponto(n))=ENVbar.MIN;

            % Força horizontal
            ENVbar = smartENV(Nx(1:tot_ponto(n),n,:),tot_ponto(n),Mc_aparelho_apoio,info);
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MAX.Hq(1:tot_ponto(n))=ENVbar.MAX;
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MIN.Hq(1:tot_ponto(n))=ENVbar.MIN;

            % Angulo de rotação
            switch nap; case 1; lado = 'rb'; case 2; lado = 're'; end
            barra_longarina = info.longarinas.vao(k).longarina(j).membros;
            ENVbar = smartENV(rotacao.(lado)(broty(:,1)==barra_longarina,:),1,Mc_aparelho_apoio,info);
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MAX.alfa_q=ENVbar.MAX;
            ENVAPAPOIO.vao(k).longarina(j).aparelho_de_apoio(nap).MIN.alfa_q=ENVbar.MIN;
        end
    end
end

end