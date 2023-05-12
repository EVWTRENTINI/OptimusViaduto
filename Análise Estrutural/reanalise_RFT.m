for k=1:viaduto.n_apoios-1
    n_longa=viaduto.vao(k).n_longarinas;
    for g=1:ceil(viaduto.vao(k).n_longarinas/2)
        [info,situacao,msg_erro]=cria_cabos_e_var_T(k,g,LC(info.LC.PP_ini).cd,viaduto,info,config_draw);
        if not(situacao); if relatorio_tempo; fprintf([msg_erro '\n']); end; return; end
    end
end
LC(info.LC.RFT_ini).ct=RFT2ct(viaduto,info);
%Avalia o caso de carregamento
%Transfere as forças aplicadas entre nós para forças nos nós
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Reavaliação da RFT...                         '); end
Qf(:,:,info.LC.RFT_ini)=...
    transpose(fixedreaction(LC(info.LC.RFT_ini).cd,LC(info.LC.RFT_ini).cc,LC(info.LC.RFT_ini).ct,jb,joints,broty,A,E));

[d(:,info.LC.RFT_ini),v(:,:,info.LC.RFT_ini),F(:,:,info.LC.RFT_ini),R(:,info.LC.RFT_ini)]=...
    aval_cc(Qf(:,:,info.LC.RFT_ini),LC(info.LC.RFT_ini).jl,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig,T,nb,nn);
if relatorio_tempo; toc; end

%% Recalculando a rotação dos parelhos de apoio
if relatorio_tempo; fprintf('Recalculando a rotação dos ap. de apoio...    '); end
if relatorio_tempo;  tic; end
[rb, re] = LC2rotacao_rotula(LC, broty, lb, E, Iy, jb, v, T);
if relatorio_tempo;  toc; end

% Recalculo dos esforços internos
if relatorio_tempo; fprintf('Recalculando o esforço interno de RFT...      '); end
if relatorio_tempo;  tic; end
[Nx(:,:,info.LC.RFT_ini),Vy(:,:,info.LC.RFT_ini),Vz(:,:,info.LC.RFT_ini),Tx(:,:,info.LC.RFT_ini),My(:,:,info.LC.RFT_ini),Mz(:,:,info.LC.RFT_ini),xb,tot_ponto]= LC2esf(1,LC(info.LC.RFT_ini),lb,nb,F(:,:,info.LC.RFT_ini),T);
if relatorio_tempo;  toc; end

% Recalculo a envontória de esforços
if relatorio_tempo; tic; end
if relatorio_tempo; fprintf('Recalculo da envoltória das longarinas...     '); end
[ENVLONGA, ENVLONGACR, ENVLONGACF, ENVLONGACQP, MFLECHA, ENVAPAPOIO] = ENVCOMB_viaduto_longarinas(info, tot_ponto, xb, Nx, Vz, Tx, My, rb, re, broty, viaduto);
if relatorio_tempo; toc; end