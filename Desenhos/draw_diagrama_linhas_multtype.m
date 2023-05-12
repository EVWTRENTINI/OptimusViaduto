function draw_diagrama_linhas_multtype(grupo,nvmax_por_quadro,titer,fignum)
n = size(grupo,2);

n_grupo = 0;
for i = 1:n
    if not(isempty(grupo{i}))
        if grupo{i}.situacao
            n_grupo = n_grupo + 1;
        end
    end
end

fitness = zeros(n_grupo,3);
for i = 1:n_grupo
    fitness(i,:) = grupo{i}.fitness;
end


if n_grupo>1
    minfit = min(fitness);
    maxfit = max(fitness);
    rangefit = maxfit-minfit;
else
    rangefit = [1 1 1];
    minfit = fitness;
    maxfit = fitness;
end
if rangefit(1) == 0; rangefit(1) = maxfit(1); end
if rangefit(2) == 0; rangefit(2) = maxfit(2); end
if rangefit(3) == 0; rangefit(3) = maxfit(3); end



nv = zeros(1,n_grupo);
for i = 1:n_grupo
    nv(i) = length(grupo{i}.variaveis);
end
[nv_max,ind_nv] = max(nv);

variaveis = cell(1,n_grupo);

for i = 1:n_grupo
    variaveis{i} = grupo{i}.variaveis;
end

%% Monta vetor de legendas, escala e unidades
[legenda,~, escala, unidade] = monta_legenda(nv_max);


%% Plot diagrama de linhas
% ver maximo de variaveis

order = 1:n_grupo; % Caso não organize, order = i;
% Organiza par evitar cores muito aleatórias proximas
[~,order]=sort(-fitness(:,1));

variaveis_ordem_original = variaveis;
for i = 1:n_grupo
    variaveis{i} = variaveis_ordem_original{order(i)};
end

fitness_ordem_original = fitness;
fitness = fitness_ordem_original(order,:);

valores_posicao = cell(1,nv_max);
for v = 1:nv_max
    cont = 0;
    for i = 1:n_grupo
        if length(variaveis{i}) >= v
            cont = cont + 1;
            valores_posicao{v}(cont) = variaveis{i}(v);
        end
    end
end

for v = 1:nv_max
    minvar(v) = min(valores_posicao{v});
    maxvar(v) = max(valores_posicao{v});
end
%minvar = min(variaveis);
%maxvar = max(variaveis);
rangevar = maxvar-minvar;


varnor = cell(1,n_grupo);

for i = 1:n_grupo
    varnor{i} = zeros(1,length(variaveis{i}));
    for v = 1:nv_max
        if length(variaveis{i}) >= v
            if not(rangevar(v) == 0)
                varnor{i}(v) = (variaveis{i}(v)-minvar(v))/rangevar(v);
            else
                varnor{i}(v) = 0.5;
            end
        end
    end
end

valores_normalizados = cell(1,nv_max);
indice_valores_normalizados = cell(1,nv_max);
for v = 1:nv_max
    valores_normalizados{v} = zeros(1,length(valores_posicao{v}));
    indice_valores_normalizados{v} = zeros(1,length(valores_posicao{v}));
    cont = 0;
    for i = 1:n_grupo
        if length(variaveis{i}) >= v
            cont = cont + 1;
            indice_valores_normalizados{v}(cont) = i;
            if not(rangevar(v) == 0)
                valores_normalizados{v}(cont) = (valores_posicao{v}(cont)-minvar(v))/rangevar(v);
            else
                valores_normalizados{v}(cont) = 0.5;
            end
        end
    end
end


disclinha=30;
xx = cell(1,n_grupo);
for i = 1:n_grupo
    xx{i} = 1:1/disclinha:length(variaveis{i});
end

nttiles = ceil(nv_max / nvmax_por_quadro);

hf = figure(fignum);
set(hf, 'MenuBar', 'none');
set(hf, 'ToolBar', 'none');
%tiledlayout(nttiles,1,'TileSpacing','Compact','Padding','Compact')
tiledlayout(nttiles,1,'Padding','Compact')
contleg = 0;


esp = .05; % tamanho do espraiamento
varnoresp = cell(1,n_grupo);
for i = 1:n_grupo
    varnoresp{i} = zeros(1,length(variaveis{i}));
end

for v = 1:nv_max
    %unqvar = unique(varnor(:,v));
    unqvar = unique(valores_normalizados{v});
    espacamento_total = min(unqvar(2:end) - unqvar(1:end-1));
    if isempty(espacamento_total)
        espacamento_total = 1;
    end
    for nivel = 1 : length(unqvar)
        neste_nivel = valores_normalizados{v} == unqvar(nivel);
        indice_nivel = find(neste_nivel);
        if length(indice_nivel) == 1
            esp_entre_sol = 0;
            espacamento_total_utilizado = 0;
        else
            espacamento_total_utilizado = espacamento_total;
            esp_entre_sol = espacamento_total_utilizado / (length(indice_nivel)-1);
        end
        cont = 0;
        for s = indice_nivel
            varnoresp{indice_valores_normalizados{v}(s)}(v) = valores_normalizados{v}(s) - espacamento_total_utilizado/2*esp + esp_entre_sol*cont*esp;
            cont = cont +1;
            
            if and(nivel == 1,length(unqvar)>1)
                varnoresp{indice_valores_normalizados{v}(s)}(v) = varnoresp{indice_valores_normalizados{v}(s)}(v) + espacamento_total_utilizado/2*esp;
            end
            if and(nivel == length(unqvar),length(unqvar)>1)

                varnoresp{indice_valores_normalizados{v}(s)}(v) = varnoresp{indice_valores_normalizados{v}(s)}(v) - espacamento_total_utilizado/2*esp;
            end

        end
   
       %if and(nivel == 1,length(unqvar)>1)
       %    varnoresp{indice_nivel}(v) = varnoresp{indice_nivel}(v) + espacamento_total_utilizado/2*esp;
       %end
       %if and(nivel == length(unqvar),length(unqvar)>1)
       %    varnoresp{indice_nivel}(v) = varnoresp{indice_nivel}(v) - espacamento_total_utilizado/2*esp;
       %end
    end
end


for t = 1:nttiles
    nexttile
    grid on
    hold on
    ax = gca;

    ini = 1+(t-1)*nvmax_por_quadro-(t-1);
    fim = 1+(t-1)*nvmax_por_quadro-(t-1)+nvmax_por_quadro;
    % grid
    for i = ini:fim
        plot([i,i],[0,1],'Color',[.8 .8 .8])
    end
    for i = [0 .25 .5 .75 1]
        plot([ini,fim],[i,i],'Color',[.8 .8 .8])
    end


    % parallel plot
    for i = 1:n_grupo
        redi = (maxfit(1)-fitness(i,1))/rangefit(1);
        greeni = (maxfit(2)-fitness(i,2))/rangefit(2);
        bluei = 1 - (maxfit(3)-fitness(i,3))/rangefit(3);
        if redi < 0; redi = 0; end
        if redi > 1; redi = 1; end
        if greeni < 0; greeni = 0; end
        if greeni > 1; greeni = 1; end
        if bluei < 0; bluei = 0; end
        if bluei > 1; bluei = 1; end
        
        yy = interp1(1:length(variaveis{i}), varnoresp{i}, xx{i}, 'pchip'); % 'cubic' 'spline' 'makima' 'pchip'
        inip = 1+(t-1)*nvmax_por_quadro*disclinha - (t-1)*disclinha; %1+((t-1)*disclinha)*(nvmax-1);
        fimp = inip + nvmax_por_quadro*disclinha;%1+((t)*disclinha)*(nvmax-1);

        if fimp > length(xx{i})
            fimp = length(xx{i});
        end
        hp=plot(ax,xx{i}(inip:fimp),yy(inip:fimp),'Color',[redi greeni bluei], 'tag', num2str(i));

        pointerBehavior.enterFcn = ...
            @(hfig, cpp)set(findobj(hfig, 'tag', num2str(i)), ...
            'LineWidth', 5);

        pointerBehavior.traverseFcn =  ...
            @(hfig, cpp) set(hf,'Name',['Diagrama de linhas paralelas da iteração ' num2str(titer) '. Número da solução selecionada: ' num2str(order(i))]);

        pointerBehavior.exitFcn = ...
            @(hfig, cpp)set(findobj(hfig, 'tag', num2str(i)), ...
            'LineWidth', .5);

        iptSetPointerBehavior(hp, pointerBehavior);
    end


    if nv_max == nvmax_por_quadro
        fim = nvmax_por_quadro;
    elseif nvmax_por_quadro > nv_max
        fim = nv_max;
    end
    set(ax,'XTick',[], 'YTick', [])
    xlim([ini fim])
    axis off
    % Legenda
    if fim > nv_max
        fim = nv_max;
    end
    for v = ini:fim
        contleg = contleg + 1;
        if contleg > length(legenda)
        else
            text(v,1.06,['$$' convertStringsToChars(legenda(contleg)) '$$'],'HorizontalAlignment','center','VerticalAlignment','bottom','Interpreter', 'latex','FontSize',15)
            text(v,1.06,[num2str(maxvar(contleg)*escala(contleg)) convertStringsToChars(unidade(contleg))],'HorizontalAlignment','center','VerticalAlignment','top','FontName','Times New Roman','FontSize',10)
            text(v,0,[num2str(minvar(contleg)*escala(contleg)) convertStringsToChars(unidade(contleg))],'HorizontalAlignment','center','VerticalAlignment','top','FontName','Times New Roman','FontSize',10)
            %text(v,0.5,['\it' legenda(contleg)],'HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Times New Roman','Rotation',90)
        end
    end
    contleg = contleg - 2; % Por conta da duplicação
end
set(gcf,'color','w')
hold off


set(hf,'Name',['Diagrama de linhas paralelas da iteração ' num2str(titer) '.'],'NumberTitle','off')

iptPointerManager(hf, 'enable');

end
%function changeColor(hfig, cpp, i)
%    set(findobj(hfig, 'tag', 'rollover'), ...
%        'Color', 'red')
%end