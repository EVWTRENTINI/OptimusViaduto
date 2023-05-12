function draw_resultados_scatter(grupo,ax)
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

if n_grupo > 1
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
% Plot fit scatter



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
    scatter3(ax,fitness(i,1),fitness(i,2),fitness(i,3),600,[redi greeni bluei],'.');
    hold(ax,'on')
    text(ax,fitness(i,1),fitness(i,2),fitness(i,3),['  ' num2str(i)],'Color',[redi*.75 greeni*.75 bluei*.75]);
end
%pbaspect([1 1 1])

hold(ax,'off')
end