%% Laje
parametros_gerador_modelo_relativo.lajes.h_em_funcao_vao = struct('relacao', 1/10, 'variacao_aleatoria', .30);

%% Longarinas
parametros_gerador_modelo_relativo.longarinas.h1_em_funcao_vao = struct('relacao', 1/15, 'variacao_aleatoria', .50);
parametros_gerador_modelo_relativo.longarinas.h2_em_funcao_h1 = struct('relacao', 1.2/20, 'variacao_aleatoria', .30);
parametros_gerador_modelo_relativo.longarinas.h3_em_funcao_h1 = struct('relacao', .8/20, 'variacao_aleatoria', .30);
parametros_gerador_modelo_relativo.longarinas.h4_em_funcao_h1 = struct('relacao', 2/20, 'variacao_aleatoria', .30);
parametros_gerador_modelo_relativo.longarinas.h5_em_funcao_h1 = struct('relacao', 4/20, 'variacao_aleatoria', .30); % 2.5

parametros_gerador_modelo_relativo.longarinas.b1_em_funcao_h1 = struct('relacao', 12/20, 'variacao_aleatoria', .30);
parametros_gerador_modelo_relativo.longarinas.b2_em_funcao_h1 = struct('relacao', 5/20, 'variacao_aleatoria', .30);
parametros_gerador_modelo_relativo.longarinas.b3_em_funcao_h1 = struct('relacao', 10/20, 'variacao_aleatoria', .30); % 7
parametros_gerador_modelo_relativo.longarinas.hpa = struct('relacao', 7/10, 'variacao_aleatoria', .10);





