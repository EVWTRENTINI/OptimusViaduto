function [quantitativo, orcamento, impacto_ambiental, VUP, viaduto, situacao, msg_erro] = avalia_viaduto(viaduto, terreno, greide, impedido, custos, emissoes, coeficientes_VUP, relatorio_tempo, relatorio_erro, config_draw)
if relatorio_tempo; tStart = tic; end
info=struct();
quantitativo = struct();
orcamento = struct();
impacto_ambiental = struct();
VUP = struct();

if relatorio_tempo; tic; end
%% Analise estrutural

% Trata configucações que podem ser salvas em .xml e transforma em variaveis utilizadas ao longo da analise
[viaduto,impedido,situacao,msg_erro] = trata_informacoes(viaduto, greide, terreno, impedido);
if not(situacao); fprintf([msg_erro '\n']); return; end

[MA,Nspt,peso_especifico_solo,info,situacao,msg_erro]=cria_viaduto(viaduto,terreno);
if not(situacao); fprintf([msg_erro '\n']); return; end

n_maximo_tentativas_protensao = 3;
n_tentativas_protensao = 0;

%Dimensionamento das lajes
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Dimensionamento das lajes...                  '); end
[info,situacao,msg_erro]=dim_lajes(viaduto,info,config_draw);
if not(situacao); fprintf([msg_erro '\n']); return; end
if relatorio_tempo; toc; end

while n_tentativas_protensao <= n_maximo_tentativas_protensao
    Analise_estrutural%Caso falhe tem um "return" aqui dentro <-------
    % Envoltória
    if relatorio_tempo; tic; end
    [ENVLONGA,ENVLONGACR,ENVLONGACF,ENVLONGACQP,ENVAPAPOIO,ENVTRAV,ENVPIL,ENVFUS,COMBFUNDA] = ENVCOMB_viaduto(Nx,Vy,Vz,Tx,My,Mz,rb, re, broty,xb,tot_ponto,info,viaduto);
    if relatorio_tempo; fprintf('Cálculo da envoltória...                      '); end
    if relatorio_tempo; toc; end



    if not(situacao); fprintf([msg_erro '\n']); return; end

    %extruded_view(secao,joints,jb,lb,r,draw_not)
    %draw_fresta_de_laje(joints,jb,r,info,viaduto)
    %draw_enr_longa(joints,jb,r,info,viaduto)
    %drawnow

    %% Dimensionamento

    % Dimensionamento das longarinas
    if relatorio_tempo; tic; end


    % Dimensionamento das Travessas
    if relatorio_tempo; tic; end
    if relatorio_tempo; fprintf('Dimensionamento das travessas...              '); end
    [info,situacao,msg_erro]=dim_travessas(ENVTRAV,viaduto,info,{MA.memb.rig},xb,tot_ponto,config_draw);
    if not(situacao); fprintf([msg_erro '\n']); return; end
    if relatorio_tempo; toc; end

    if relatorio_tempo; fprintf('Dimensionamento das longarinas...             '); end
    [info,todas_as_falhas_foram_por_n_cabos,situacao,msg_erro]=dim_longarinas(ENVLONGA,ENVLONGACR,ENVLONGACF,ENVLONGACQP,ENVAPAPOIO,viaduto,MA,info,xb,tot_ponto,LC,config_draw);
    if relatorio_tempo; toc; end
    if not(situacao)
        if not(todas_as_falhas_foram_por_n_cabos)
            fprintf([msg_erro '\n'])
            return
        else
            %situacao = true;
            n_tentativas_protensao = n_tentativas_protensao + 1;
            fprintf('Recalculando com [');
            for k = 1:viaduto.n_apoios-1
                viaduto.vao(k).ntcord = viaduto.vao(k).ntcord + max([info.longarinas.vao(k).longarina(:).adicionar_cordoalhas]);
                viaduto.vao(k).ntcord = max([viaduto.vao(k).ntcord - max([info.longarinas.vao(k).longarina(:).remover_cordoalhas]) 1]); % o 1 do final é para não deixar zerar as coordoalhas
                fprintf(num2str(viaduto.vao(k).ntcord));
                if not(k == viaduto.n_apoios-1)
                    fprintf(' ');
                end
            end
            fprintf('] cabos.\n');
        end
    else
        break
    end

    

end

if not(situacao)
    fprintf([msg_erro '\n'])
    return
end


%Dimensionamento dos pilares
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Dimensionamento dos pilares...                '); end
[info,situacao,msg_erro]=dim_pilares(ENVPIL,viaduto,info,config_draw);
if not(situacao); fprintf([msg_erro '\n']); return; end
if relatorio_tempo; toc; end

% Dimensionamento dos fustes
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Dimensionamento dos fustes...                 '); end
[info,situacao,msg_erro]=dim_fustes(ENVFUS,viaduto,info,config_draw);
if not(situacao); fprintf([msg_erro '\n']); return; end
if relatorio_tempo; toc; end

% Dimensionamento dos tubulões
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Dimensionamento dos tubulões...               '); end
[info,situacao,msg_erro]=dim_tubuloes(COMBFUNDA,Nspt,peso_especifico_solo,viaduto,info,config_draw);
if not(situacao); fprintf([msg_erro '\n']); return; end
if relatorio_tempo; toc; end

% Dimensionamento dos blocos
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Dimensionamento dos blocos...                 '); end
[info,situacao,msg_erro]=dim_blocos(ENVFUS,viaduto,info,config_draw);
if not(situacao); fprintf([msg_erro '\n']); return; end
if relatorio_tempo; toc; end




if relatorio_tempo; fprintf('\n'); end

% Orçamento
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Orçamento...                                  '); end
[orcamento, quantitativo] = orcar_viaduto(custos, viaduto, info);
if relatorio_tempo; toc; end

% Emissões
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Emissões...                                   '); end
impacto_ambiental = calc_impacto_ambiental(emissoes, quantitativo, info, viaduto);
if relatorio_tempo; toc; end

% Vida Util de Projeto
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Vida útil de projeto...                       '); end
VUP = calc_viaduto_VUP(coeficientes_VUP, viaduto);
if relatorio_tempo; toc; end

orcamento.TOTAL

if relatorio_tempo; tEnd = toc(tStart); end
if relatorio_tempo;cprintf('green', ['\nTempo total de processamento...               ' num2str(tEnd) ' segundos\n']); end

%% Desenhos

%extruded_view(secao,joints,jb,lb,r,draw_not)

% NLC=181;
%figure(2)
% CC=NLC;
%draw_est
% draw_loads(1E-3,LC(CC).cc,LC(CC).cd,joints,jb,r,lb,LC(CC).jl)
% draw_rigidez_solo
% draw_Nspt
%draw_peso_especifico_solo
%draw_rf(1E-4,R(:,NLC),joints)
% draw_esf(5,2E-5,Nx(:,:,NLC),Vy(:,:,NLC),Vz(:,:,NLC),Tx(:,:,NLC),My(:,:,NLC),Mz(:,:,NLC),xb,tot_ponto,nb,r,jb,joints,draw_not)
% draw_tubuloes(viaduto,info,joints)
% draw_blocos(viaduto,info,joints)

extruded_view(secao,joints,jb,lb,r,draw_not)
draw_blocos(viaduto,info,joints)
draw_tubuloes(viaduto,info,joints)
draw_fresta_de_laje(joints,jb,r,info,viaduto)
draw_enr_longa(joints,jb,r,info,viaduto)
drawnow

%% Som
[y, Fs] = audioread('tada-fanfare-a-6313.mp3');
player = audioplayer(y, Fs);
playblocking(player);


end