function [viaduto,impedido,situacao,msg_erro] = trata_informacoes(viaduto, greide, terreno, impedido)
% Faz verificações iniciais e tratamento das informações
situacao=true;
msg_erro='sem erro';

%% Verifica a ordem dos pilares
for k = 1 : viaduto.n_apoios - 1
    if viaduto.vao(k).l <= 0
        situacao = false;
        msg_erro=['Vão de comprimento negativo por conta da ordem dos pilares. Vão ' num2str(k) '.'];
        return
    end
end

%% Verifica dimensões da seção da longarina
% Altura
for k = 1 : viaduto.n_apoios - 1
    h1 = viaduto.vao(k).longarina.h1;
    h2 = viaduto.vao(k).longarina.h2;
    h3 = viaduto.vao(k).longarina.h3;
    h4 = viaduto.vao(k).longarina.h4;
    h5 = viaduto.vao(k).longarina.h5;
    if h1<(h2+h3+h4+h5)
        situacao = false;
        msg_erro=['Altura da secão transversal incopativel com altura das partes individuais. Vão ' num2str(k) '.'];
        return
    end
end

% Largura
% % % fi_t = viaduto.longa_fi_tran;
% % % fi_l_max = viaduto.longa_fi_long_max;
% % % for k = 1 : viaduto.n_apoios - 1
% % %     b1 = viaduto.vao(k).longarina.b1;
% % %     b2 = viaduto.vao(k).longarina.b2;
% % %     b3 = viaduto.vao(k).longarina.b3;
% % %     benr = viaduto.vao(k).longarina.benr;
% % %     c = viaduto.vao(k).longarina.c;
% % % 
% % %     esp_min=min([b1 b2 b3 benr]);
% % %     offsetmaximo=c+fi_t+fi_l_max;
% % %     if esp_min/2<=offsetmaximo
% % %         situacao=false;
% % %         msg_erro=['Menor espessura da seção transversal é menor que a mínima de ' num2str(offsetmaximo*2*100) ' cm'];
% % %     end
% % %     if not(situacao); return; end
% % % end


%% lida com cotas dos apoios
for i = 1 : viaduto.n_apoios
    viaduto.apoio(i).cota_greide = interp1(greide.x, greide.z, viaduto.x_apoio(i));
    viaduto.apoio(i).cota_topo_bloco = interp1([terreno.x], [terreno.nivel_terreno], viaduto.x_apoio(i)) - viaduto.h_bloco_enterrado;%face superior do bloco
    viaduto.apoio(i).cota_fundacao = viaduto.apoio(i).cota_topo_bloco - viaduto.apoio(i).profundidade_fundacao;
end

%% lida com o diametro da cordoalha de protensão - viaduto.area_cordoalha
if viaduto.tipo_diametro_cordoalha == 1 % se for tipo 1 é de 12,7mm
    viaduto.area_cordoalha=.987;%cm²
else %se for tipo 2 é de 15,2mm, utilizando else para não interromper o processo caso qualquer outro valor for utilizado.
    viaduto.area_cordoalha=1.399;%cm²
end


%% lida com a discretização do cortante - viaduto.disc_cor_tor
n_disc = length(viaduto.disc_cor_tor);
disc_cor_tor_limpo = zeros(1, n_disc*2+2);
disc_cor_tor_limpo(end) = 1;
for i = 1 : n_disc
    disc_cor_tor_limpo(1 + i) = viaduto.disc_cor_tor(i);
    disc_cor_tor_limpo(end - i) = 1 - viaduto.disc_cor_tor(i);
end

for k = 1 : viaduto.n_apoios - 1
    enr = viaduto.vao(k).longarina.enr;
    
    if any(disc_cor_tor_limpo == enr) % Caso a discretização ja coincida com o enrijecimento
        % Não precisa de alteração nenhuma
        disc_cor_tor = disc_cor_tor_limpo;
    else % Precisa de alteração
        adicinou_o_primeiro = false;
        adicinou_o_ultimo = false;
        [~,it] = size(disc_cor_tor_limpo);
        disc_cor_tor = zeros(1, it + 2);
        for i = 1 : it
            if disc_cor_tor_limpo(i) < enr
                disc_cor_tor(i) = disc_cor_tor_limpo(i);
            else
                if not(adicinou_o_primeiro)
                    disc_cor_tor(i) = enr;
                    adicinou_o_primeiro = true;
                end
                if not(adicinou_o_ultimo)
                    disc_cor_tor(i + 1) = disc_cor_tor_limpo(i);
                end
                if disc_cor_tor_limpo(i) > 1 - enr
                    if not(adicinou_o_ultimo)
                        disc_cor_tor(i+1) = 1 - enr;
                        adicinou_o_ultimo = true;
                    end
                    disc_cor_tor(i + 2) = disc_cor_tor_limpo(i);
                end
            end
        end
    end
    viaduto.vao(k).disc_cor_tor = disc_cor_tor;
end

% transfor string em booleano por conta dos arquivos xml
if not(islogical(viaduto.analise_nao_linear_de_estabilidade_lateral))
    if viaduto.analise_nao_linear_de_estabilidade_lateral == "false"
        viaduto.analise_nao_linear_de_estabilidade_lateral = false;
    elseif viaduto.analise_nao_linear_de_estabilidade_lateral == "true"
        viaduto.analise_nao_linear_de_estabilidade_lateral = true;
    end
end

if not(islogical(viaduto.dimensionar_barras_fustes_individualmente))
    if viaduto.dimensionar_barras_fustes_individualmente == "false"
        viaduto.dimensionar_barras_fustes_individualmente = false;
    elseif viaduto.dimensionar_barras_fustes_individualmente == "true"
        viaduto.dimensionar_barras_fustes_individualmente = true;
    end
end

for i = 1:length(impedido)
    if not(islogical(impedido(i).pista))
        if impedido(i).pista == "false"
            impedido(i).pista = false;
        elseif impedido(i).pista == "true"
            impedido(i).pista = true;
        end
    end
end