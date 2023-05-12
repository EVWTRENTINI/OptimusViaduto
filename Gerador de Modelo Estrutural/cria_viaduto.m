function [MA,Nspt,peso_especifico_solo,info,situacao,msg_erro] = cria_viaduto(viaduto,terreno)
%Constrói o modelo analítico do viaduto
%   Com base nos parâmetros constrói o modelo analítico.

MA=struct();
info=struct();
situacao=true;
msg_erro='sem erro';

%% Desenvolve Interpolação do solo.
rigidez_solo         =calc_rigidez_solo(terreno);
Nspt              =calc_Nspt(terreno);
peso_especifico_solo =calc_peso_especifico_solo(terreno);

%% Inicialização das variáveis

nnf=0;%Numero de nós dos fustes
nnp=0;%Numero de nós dos pilares
nnlg=0;%Numero de nós das longarinas
nnt=0;%Numero de nós das travessas
nna=0;%Numero de nós dos apoios

nbf=0;%Numero de barras do fuste
nbp=0;%Numero de barras dos pilares
nblg=0;%Numero de barras das longarinas
nbt=0;%Numero de barras das travessas
nba=0;%Numero de barras dos apoios


for i=1:viaduto.n_apoios
    fustes_l=viaduto.apoio(i).cota_topo_bloco-viaduto.apoio(i).cota_fundacao;
    n_barras=ceil(fustes_l/viaduto.l_max_fuste);
    for j=1:viaduto.apoio(i).n_pilares
        nnf=nnf+n_barras+1;
        nbf=nbf+n_barras;
        nnp=nnp+3;
        nbp=nbp+3;
    end
end

nnlg=sum([viaduto.vao(:).n_longarinas]*2);
nblg=sum([viaduto.vao(:).n_longarinas]*1);
nnt=sum([viaduto.apoio(:).n_pilares])*2+sum([viaduto.vao(:).n_longarinas])*2;
nbt=nnt-1*viaduto.n_apoios+sum([viaduto.apoio(:).n_pilares]);
for i=1:viaduto.n_apoios
    if viaduto.apoio(i).travessa.bl>0
        nnt=nnt+2;
        nbt=nbt+2;
    end
end
%          número de vigas*10    -   número de vigas primeiro vão    -   número de vigas último vão
nna=sum([viaduto.vao(:).n_longarinas]*10)-sum([viaduto.vao(1).n_longarinas])-sum([viaduto.vao(viaduto.n_apoios-1).n_longarinas]);
nba=sum([viaduto.vao(:).n_longarinas]*12)-sum([viaduto.vao(1).n_longarinas])-sum([viaduto.vao(viaduto.n_apoios-1).n_longarinas]);



nn=nnf+nnp+nnt+nna+nnlg;
nb=nbf+nbp+nbt+nba+nblg;
cria_MA;

%% Criação dos Fustes

[MA.joints(1:nnf),MA.memb(1:nbf),info_fustes]=...
cria_fustes(viaduto,rigidez_solo,terreno);
%% Criação dos Pilares

[MA.joints(nnf+1:nnf+nnp),MA.memb(nbf+1:nbf+nbp),...
info_pilares,situacao,msg_erro]=...
cria_pilares(viaduto,terreno,info_fustes);
if not(situacao); return; end


for i = 1 : viaduto.n_apoios
    for j = 1 : viaduto.apoio(i).n_pilares
        % Checa folga mínima entre pilares
        if j<=viaduto.apoio(i).n_pilares-1
            folga=MA.joints(info_pilares.apoio(i).pilar(j+1).primeiro_no).y-MA.joints(info_pilares.apoio(i).pilar(j).primeiro_no).y-viaduto.apoio(i).pilares.d;
            if folga < viaduto.pilares.folga_minima_entre_faces
                situacao = false;
                msg_erro = ['Distancia entre face de pilares menor que a mínima no apoio ' num2str(i) '.'];
                return
            end
        end
        % Checa o tamanho do pilar e confere com o mínimo
        altura_pilar = MA.joints(info_pilares.apoio(i).pilar(j).primeiro_no).z-MA.joints(info_fustes.apoio(i).fuste(j).primeiro_no).z;
        if altura_pilar < viaduto.pilares.altura_minima
            situacao = false;
            msg_erro = ['Altura do pilar menor que o comprimento mínimo no apoio ' num2str(i) '.'];
            return
        end
    end
end

%% Criação das Longarinas

[MA.joints(nnf+nnp+1:nnf+nnp+nnlg),...
 MA.memb(nbf+nbp+1:nbf+nbp+nblg),  ...
 info_longarinas]=                 ...
 cria_longarinas(viaduto,info_pilares,info_fustes);


% Checa se a folga entre longarinas é maior que a mínima
for k=1:viaduto.n_apoios-1
    b1=viaduto.vao(k).longarina.b1;
    b2=viaduto.vao(k).longarina.b2;
    b3=viaduto.vao(k).longarina.b3;
    %benr=viaduto.vao(k).longarina.benr;
    n_longa=viaduto.vao(k).n_longarinas-1;
    for g=1:n_longa
        meia_folga_1 = info_longarinas.vao(k).longarina(g).bf_por_2 - max([b1 b2 b3])/2;
        meia_folga_2 = info_longarinas.vao(k).longarina(g+1).bf_por_2 - max([b1 b2 b3])/2;
        folga_longarinas = meia_folga_1 + meia_folga_2;
        
        if folga_longarinas < viaduto.longarinas.folga_entre_longarinas
            situacao = false;
            msg_erro = ['Folga entre longarinas menor que a mínima. Apoio ' num2str(k) ', longarina ' num2str(g) '.'];
            return
        end
    end
end

%% Criação das Travessas

[MA_temp.joints,...
MA_temp.memb,  ...
info_travessas]=                              ...
cria_travessas(viaduto,info_pilares,info_longarinas,info_fustes);

nnt_rem=nnt-(info_travessas.UNE-info_longarinas.UNE);
nbt_rem=nbt-(info_travessas.UME-info_longarinas.UME);
nnt=info_travessas.UNE-info_longarinas.UNE;
nbt=info_travessas.UME-info_longarinas.UME;

MA.joints(end-nnt_rem+1:end)=[];
MA.memb(end-nbt_rem+1:end)=[];
nn=nnf+nnp+nnt+nna+nnlg;
nb=nbf+nbp+nbt+nba+nblg;
MA.n.joints=nn;
MA.n.memb=nb;

MA.joints(nnf+nnp+nnlg+1:nnf+nnp+nnlg+nnt)=MA_temp.joints;
MA.memb(nbf+nbp+nblg+1:nbf+nbp+nblg+nbt)=MA_temp.memb;
%% Criação dos aparelho de apoio
[info_aparelhos_de_apoio,situacao,msg_erro]=cria_aparelho_de_apoios(viaduto);
if not(situacao); return; end


%% Criação dos Apoios das Longarinas

[MA.joints(nnf+nnp+nnlg+nnt+1:nnf+nnp+nnlg+nnt+nna),...
MA.memb(nbf+nbp+nblg+nbt+1:nbf+nbp+nblg+nbt+nba),  ...
info_apoios]=                              ...
 cria_apoios(viaduto,info_pilares,info_longarinas,info_travessas,info_aparelhos_de_apoio);


%% Salva Informações Sobre MA
%Conta numero de barra rigidas e rigidas extensiveis

contrig=0;
contrigex=0;
for i=1:MA.n.memb
    if MA.memb(i).rig ==1
    contrig=contrig+1;
    end
    if not(isempty(MA.memb(i).rig_ex))
    contrigex=contrigex+1;
    end
end

MA.n.brig=contrig;

MA.n.brig_ex=contrigex;


% % Plota nós
% figure(1)
% clf
% hold on
% for i=1:nn 
%     plot3(MA.joints(i).x,MA.joints(i).y,MA.joints(i).z,'o','Color','k','MarkerFaceColor','k')
% %    text(MA.joints(i).x,MA.joints(i).y,MA.joints(i).z,[' ' num2str(i)],'HorizontalAlignment', 'left','VerticalAlignment', 'top')
% end
% for i=1:nb
%     if MA.memb(i).rig==1
%         corbarra='g';
%     else
%         corbarra='b';
%     end
% 	plot3([MA.joints(MA.memb(i).b).x MA.joints(MA.memb(i).e).x],...          %[X1 X2]
%           [MA.joints(MA.memb(i).b).y MA.joints(MA.memb(i).e).y],...          %[Y1 Y2]
%           [MA.joints(MA.memb(i).b).z MA.joints(MA.memb(i).e).z],'color',corbarra);%[Z1 Z2]
% %     text((MA.joints(MA.memb(i).b).x+MA.joints(MA.memb(i).e).x)/2,...
% %          (MA.joints(MA.memb(i).b).y+MA.joints(MA.memb(i).e).y)/2,...
% %          (MA.joints(MA.memb(i).b).z+MA.joints(MA.memb(i).e).z)/2,...
% %           [' ' num2str(i)],'HorizontalAlignment', 'left','color','b')
% end
% 
% axis  vis3d equal
% view([-38 24])
% hold off

% Atualiza as informações
info.fustes=info_fustes;
info.pilares=info_pilares;
info.longarinas=info_longarinas;
info.travessas=info_travessas;
info.apoios=info_apoios;
info.aparelhos_de_apoio=info_aparelhos_de_apoio;

end

