function [apoios_possiveis, n_vaos_possiveis, vaos_unicos] = cria_apoios_possiveis(xi, xf, impedido, L_vao)
% Cria uma lista dos possiveis apoios
x = xi+L_vao.min:L_vao.discretizacao:xf-L_vao.min;
for i = 1:length(impedido)
    indices = and(x >= impedido(i).xi, x <= impedido(i).xf);
    x = x(~indices);
end

x = [xi x xf];
analisado = [true false(1,length(x)-2) true];
pilares = analisado;
% Primeira passada
% Da esquerda pra direita
% maximo_de_tentativas = 1000;
% contador = 0;
while true
%     contador = contador + 1;

    [n_casos, ~] = size(analisado);
    for i = 1:n_casos
        ponto_a_serem_analisados = find(analisado(i,:)==false);
        if not(isempty(ponto_a_serem_analisados)); break; end 
    end
    if isempty(ponto_a_serem_analisados)
        break
    end
    % Checa se ainda existem pontos a serem analisados
    
    ponto_analisado = ponto_a_serem_analisados(1);
    % Checa se é necessário colocar apoio por conta do vão máximo
    index_dos_pilares_ate_o_ponto_analisado = find(pilares(i,1:ponto_analisado)==true);
    index_do_ultimo_pilar_ate_o_ponto_analisado = index_dos_pilares_ate_o_ponto_analisado(end);
    vao_ate_o_proximo_ponto_analisado = x(ponto_analisado+1) - x(index_do_ultimo_pilar_ate_o_ponto_analisado);
    % Se for possivel aumentar ainda mais o vão então aumenta
    if vao_ate_o_proximo_ponto_analisado < L_vao.max
        % Deixa o vão vazio
        pilares(i,ponto_analisado) = false;
        analisado(i,ponto_analisado) = true; % Anota que deixou vazio mais foi analisado
        % Cria um novo caso com pilar
        analisado(n_casos+1, :) = analisado(i, :); % Copia os pontos analisados do caso pai : Cuidado por que ele ja foi alterado
        pilares(n_casos+1, :) = pilares(i, :); % Copia os pilar do caso pai
        pilares(n_casos+1, ponto_analisado) = true; % Coloca o pilar novo no caso filho
        % Anota que não pode ter pilar por conta do vão minimo e considera analisado
        distancia_ate_o_novo_pilar = x-x(ponto_analisado);
        analisado(n_casos+1, :) = or(analisado(n_casos+1, :),distancia_ate_o_novo_pilar < L_vao.min);
    else
        % Coloca pilar
        pilares(i,ponto_analisado) = true;
        analisado(i,ponto_analisado) = true; % Anota que deixou vazio mais foi analisado
        distancia_ate_o_novo_pilar = x-x(ponto_analisado);
        analisado(i, :) = or(analisado(i, :), distancia_ate_o_novo_pilar < L_vao.min);
    end



end

apoios_possiveis = cell(1,n_casos);
n_vaos_possiveis = zeros(1,n_casos);

for i = 1: n_casos
    apoios_possiveis{i} = x(pilares(i,:));
    n_vaos_possiveis(i)= length(apoios_possiveis{i})-1;
end

vaos_unicos = unique(n_vaos_possiveis);

end