
%Monta o Modelo analitico
[joints,jb,jfix,aflex,broty,brig,brig_ex,draw_not,A,E,G,Iz,Iy,J,secao] =...
MA2AMEBP3D( MA );

%Calcula os conessenos diretores
[nb,nn,lb,r,T] =...
calc_cossenos(joints,jb);


%Cria os casos de carregametno
[LC,info,situacao,msg_erro] = constroi_LC(MA,r,viaduto,impedido,info,config_draw);
if not(situacao); return; end


if relatorio_tempo; fprintf('Construção do modelo estrutural...            '); end
if relatorio_tempo; toc; end

%% Análise estrutural

[d,v,F,R,Qf,K,invSu,Cu,cg,B,M,invM,bcn,rdf_list,rdf,n_e_rig,n_e_rig_ex,restr,nbrig] = AMEBP3D(nb,nn,lb,r,T,joints,jb,jfix,broty,LC,A,E,G,Iy,Iz,J,brig,brig_ex,aflex,relatorio_tempo);



%% Cálculo dos esforços internos
if relatorio_tempo; fprintf('Cálculo dos esforços internos...              '); end
if relatorio_tempo;  tic; end
[Nx,Vy,Vz,Tx,My,Mz,xb,tot_ponto] = LC2esf(1,LC,lb,nb,F,T);
if relatorio_tempo;  toc; end
 

%% Cálculo da rotação dos aparelhos de apoio
if relatorio_tempo; fprintf('Cálculo da rotação dos aparelhos de apoio...  '); end
if relatorio_tempo;  tic; end
[rb, re] = LC2rotacao_rotula(LC, broty, lb, E, Iy, jb, v, T);
if relatorio_tempo;  toc; end

