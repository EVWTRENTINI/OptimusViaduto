function [tamanho_grupos_vao,quantidade_grupos_vao] = divide_populacao_por_grupo_vao(vaos_unicos, tamanho_populacao)
n_grupos_vao = length(vaos_unicos);
tamanho_grupos_vao = ones(1,n_grupos_vao) * floor(tamanho_populacao / n_grupos_vao);
if sum(tamanho_grupos_vao) < tamanho_populacao % Corrige com o que faltou para completar o tamanho da populacao
    tamanho_grupos_vao(1 : tamanho_populacao - sum(tamanho_grupos_vao)) = tamanho_grupos_vao(1 : tamanho_populacao - sum(tamanho_grupos_vao)) + 1;
end
quantidade_grupos_vao = length(tamanho_grupos_vao);
end