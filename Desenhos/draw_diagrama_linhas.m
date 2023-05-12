function draw_diagrama_linhas(grupo,nvmax,fignum,varsel)
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





for i = 1:n_grupo
    nv(i) = length(grupo{i}.variaveis);
end
[nv,ind_nv] = max(nv);

variaveis = zeros(n_grupo,nv);
for i = 1:n_grupo
    variaveis(i,:) = grupo{i}.variaveis;
end

%% Monta vetor de legendas, escala e unidades
[legenda,~, escala, unidade] = monta_legenda(nv_max);

%% Plot diagrama de linhas
% ver maximo de variaveis

order = 1:n_grupo; % Caso não organize, order = i;
% Organiza par evitar cores muito aleatórias proximas
[~,order]=sort(-fitness(:,1));
variaveis = variaveis(order,:);
fitness = fitness(order,:);

if nargin == 3
    varsel = 1:nv;
end

variaveis = variaveis(:,varsel);
unidade = unidade(varsel);
legenda = legenda(varsel);
minvar = min(variaveis);
maxvar = max(variaveis);
rangevar = maxvar-minvar;

range_zero = rangevar == 0;
nvs = length(varsel);
varnor = zeros(n_grupo,nvs);
for i = 1:n_grupo
    varnor(i,not(range_zero)) = (variaveis(i,not(range_zero))-minvar(not(range_zero)))./rangevar(not(range_zero));
end

varnor(:,range_zero) = 0.5;

disclinha=30;

xx = 1:1/disclinha:nvs;

nttiles = ceil(nvs / nvmax);

hf = figure(fignum);
%tiledlayout(nttiles,1,'TileSpacing','Compact','Padding','Compact')
tiledlayout(nttiles,1,'Padding','Compact')
contleg = 0;


esp = .05; % tamanho do espraiamento
varnoresp = zeros(size(varnor));
for v = 1:nv
    unqvar = unique(varnor(:,v));
    espacamento_total = min(unqvar(2:end) - unqvar(1:end-1));
    if isempty(espacamento_total)
        espacamento_total = 1;
    end
    for nivel = 1 : length(unqvar)
        neste_nivel = varnor(:,v) == unqvar(nivel);
        indice_nivel = find(neste_nivel);
        if length(indice_nivel) == 1
            esp_entre_sol = 0;
            espacamento_total_utilizado = 0;
        else
            espacamento_total_utilizado = espacamento_total;
            esp_entre_sol = espacamento_total_utilizado / (length(indice_nivel)-1);
        end
        cont = 0;

        for s = transpose(indice_nivel)
            varnoresp(s,v) = varnor(s,v) - espacamento_total_utilizado/2*esp + esp_entre_sol*cont*esp;
            cont = cont +1;
        end

        if and(nivel == 1,length(unqvar)>1)
            varnoresp(indice_nivel,v) = varnoresp(indice_nivel,v) + espacamento_total_utilizado/2*esp;
        end
        if and(nivel == length(unqvar),length(unqvar)>1)
            varnoresp(indice_nivel,v) = varnoresp(indice_nivel,v) - espacamento_total_utilizado/2*esp;
        end
    end
end


for t = 1:nttiles
    nexttile
    grid on
    hold on
    ax = gca;

    ini = 1+(t-1)*nvmax-(t-1);
    fim = 1+(t-1)*nvmax-(t-1)+nvmax;
    % grid
    for i = ini:fim
        plot([i,i],[0,1],'Color',[.8 .8 .8])
    end
    for i = [0 .25 .5 .75 1]
        plot([ini,fim],[i,i],'Color',[.8 .8 .8])
    end


    % paralel plot
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

        yy = interp1(1:nvs, varnoresp(i,:), xx, 'pchip'); % 'cubic' 'spline' 'makima' 'pchip'
        inip = 1+(t-1)*nvmax*disclinha - (t-1)*disclinha; %1+((t-1)*disclinha)*(nvmax-1);
        fimp = inip + nvmax*disclinha;%1+((t)*disclinha)*(nvmax-1);

        if fimp > length(xx)
            fimp = length(xx);
        end
        hp=plot(ax,xx(inip:fimp),yy(inip:fimp),'Color',[redi greeni bluei], 'tag', num2str(i));

        pointerBehavior.enterFcn = ...
            @(hfig, cpp)set(findobj(hfig, 'tag', num2str(i)), ...
            'LineWidth', 5);

        pointerBehavior.traverseFcn =  ...
            @(hfig, cpp) fprintf([num2str(order(i)) '\n']);

        pointerBehavior.exitFcn = ...
            @(hfig, cpp)set(findobj(hfig, 'tag', num2str(i)), ...
            'LineWidth', .5);

        iptSetPointerBehavior(hp, pointerBehavior);
    end


    if nvs == nvmax
        fim = nvmax;
    elseif nvmax > nvs
        fim = nvs;
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




iptPointerManager(hf, 'enable');
end
%function changeColor(hfig, cpp, i)
%    set(findobj(hfig, 'tag', 'rollover'), ...
%        'Color', 'red')
%end