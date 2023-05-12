function [rb, re] = calc_rotacao_rotula(cc, cd, lb, broty, E, Iy, jb, v, T)

[nbcc,~]=size(cc);
[nbcd,~]=size(cd);

[numero_barras_rotuladas, ~] = size(broty);

rb = zeros(numero_barras_rotuladas, 1);
re = zeros(numero_barras_rotuladas, 1);


for linha_broty = 1 : numero_barras_rotuladas
    n = broty(linha_broty, 1);
    if or(broty(linha_broty, 2) == 0, broty(linha_broty, 3) == 0) % Checa se o elemento não é rotulado-rotulado
        fprintf('A análise estrutural não avalia a rotação de elementos rotulados-engastados ou engastados-rotulados.');
        return
    end
    % Tendo garantido que o elemento é rotulado-rotulado continua
    %% Rotação por desnivel dos nós
    u = T(:,:,n) * v(:,n);
      
    co = u(9) - u(3);
    ca = lb(n) + u(7) - u(1);

    rb(linha_broty) = rb(linha_broty) + atan(-co/ca);
    re(linha_broty) = re(linha_broty) + atan(-co/ca);

    %% Carga concentrada em z
    if not(isempty(cc)) % Existe carga concentrada neste caso de carregamento
        % Seleciona as cargas que são aplicadas na barra em questão
        cc_barra = cc(cc(:, 1) == n , :);
        if not(isempty(cc_barra)) % Existe carga concentrada na barra
            % Seleciona carga concentrada em z
            cc_barra = cc_barra(cc_barra(:,2) == 3, :);
            if not(isempty(cc_barra)) % Existe carga concentrada em z
                [nt_cc, ~] = size(cc_barra);
                for n_cc = 1 : nt_cc
                    P = cc_barra(n_cc, 4);
                    a = cc_barra(n_cc, 3)*lb(n);
                    b = lb(n) - a;

                    [rb_cc, re_cc] = calc_rotacao_rotula_carga_concentrada(P,a,b,lb(n),E(n),Iy(n));
                    rb(linha_broty) = rb(linha_broty) + rb_cc;
                    re(linha_broty) = re(linha_broty) + re_cc;
                end
            end
        end
    end

    %% Carga distribuida em z
    if not(isempty(cd)) % Existe carga distribuida neste caso de carregamento
        % Seleciona as cargas que são aplicadas na barra em questão
        cd_barra = cd(cd(:, 1) == n , :);
        if not(isempty(cd_barra)) % Existe carga distribuida na barra
            % Seleciona cargas distribuida em z
            cd_barra = cd_barra(cd_barra(:,2) == 3, :);
            if not(isempty(cd_barra)) % Existe carga distribuida em z
                [nt_cd, ~] = size(cd_barra);
                for n_cd = 1 : nt_cd
                    q = cd_barra(n_cd, 5);
                    a = cd_barra(n_cd, 3)*lb(n);
                    b = lb(n) - cd_barra(n_cd, 4)*lb(n);

                    [rb_cd, re_cd] = calc_rotacao_rotula_carga_distribuida(q,a,b,lb(n),E(n),Iy(n));
                    rb(linha_broty) = rb(linha_broty) + rb_cd;
                    re(linha_broty) = re(linha_broty) + re_cd;
                end
            end
        end
    end
    %% Momento aplicado em torno de y
    if not(isempty(cc)) % Existe carga concentrada neste caso de carregamento
        % Seleciona as cargas que são aplicadas na barra em questão
        cc_barra = cc(cc(:, 1) == n , :);
        if not(isempty(cc_barra)) % Existe carga concentrada na barra
            % Seleciona momentos em torno de y
            cc_barra = cc_barra(cc_barra(:,2) == 5, :);
            if not(isempty(cc_barra)) % Existe momento aplicado em torno de y
                fprintf('A análise estrutural não avalia a rotação de elementos com momento aplicado em torno de y');
            end
        end
    end
    
    %% Diferença da rotação do começo da barra e do nó de apoio
    rb(linha_broty) = rb(linha_broty) - v(5,n);
    re(linha_broty) = re(linha_broty) - v(11,n);
    

end



end