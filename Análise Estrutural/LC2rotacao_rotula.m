function [rb, re] = LC2rotacao_rotula(LC, broty, lb, E, Iy, jb, v, T)
[~, nLC] = size(LC);
[numero_barras_rotuladas, ~] = size(broty);
rb = zeros([numero_barras_rotuladas nLC]);
re = zeros([numero_barras_rotuladas nLC]);


for CC=1:nLC
    [rb(:,CC),re(:,CC)]=...
        calc_rotacao_rotula(LC(CC).cc,LC(CC).cd,lb,broty,E,Iy,jb,v(:,:,CC),T);
end
end