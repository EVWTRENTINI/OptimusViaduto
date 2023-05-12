function viaduto = variaveis2viaduto(variaveis,viaduto_padrao,parametros_gerador_modelo, greide)
%% Desplanifica as variaveis
viaduto.n_apoios = variaveis2n_apoios(variaveis);

n = 1;

% Variaveis fixas independente do numero de vãos
variaveis_struct.fundacao.c = variaveis(n); n = n + 1;                           % 1
variaveis_struct.pilares.fck = variaveis(n)*1E6; n = n + 1;                      % 2
variaveis_struct.pilares.c = variaveis(n); n = n + 1;                            % 3
variaveis_struct.travessas.fck = variaveis(n)*1E6; n = n + 1;                    % 4
variaveis_struct.travessas.c= variaveis(n); n = n + 1;                           % 5
variaveis_struct.tabuleiro.fck= variaveis(n)*1E6; n = n + 1;                     % 6
variaveis_struct.longarinas.c= variaveis(n); n = n + 1;                          % 7
variaveis_struct.lajes.c= variaveis(n); n = n + 1;                               % 8

% Primeiro e ultimo apoio
for i = [1 viaduto.n_apoios]
    variaveis_struct.apoio(i).profundidade_fundacao = variaveis(n); n = n + 1;   % 9    16
    variaveis_struct.apoio(i).n_pilares = variaveis(n); n = n + 1;               % 10   17
    variaveis_struct.apoio(i).fustes.d = variaveis(n); n = n + 1;                % 11   18
    variaveis_struct.apoio(i).pilares.d = variaveis(n); n = n + 1;               % 12   19
    variaveis_struct.apoio(i).travessa.h = variaveis(n); n = n + 1;              % 13   20
    variaveis_struct.apoio(i).travessa.b = variaveis(n); n = n + 1;              % 14   21
    variaveis_struct.apoio(i).travessa.bl = variaveis(n); n = n + 1;             % 15   22
end

% Primeiro vão
for i = 1
    variaveis_struct.vao(i).n_longarinas = variaveis(n); n = n + 1;              % 23
    variaveis_struct.vao(i).hap = variaveis(n); n = n + 1;                       % 24
    variaveis_struct.vao(i).longarina.h1 = variaveis(n); n = n + 1;              % 25
    variaveis_struct.vao(i).longarina.h2 = variaveis(n); n = n + 1;              % 26
    variaveis_struct.vao(i).longarina.h3 = variaveis(n); n = n + 1;              % 27
    variaveis_struct.vao(i).longarina.h4 = variaveis(n); n = n + 1;              % 28
    variaveis_struct.vao(i).longarina.h5 = variaveis(n); n = n + 1;              % 29
    variaveis_struct.vao(i).longarina.b1 = variaveis(n); n = n + 1;              % 30
    variaveis_struct.vao(i).longarina.b2 = variaveis(n); n = n + 1;              % 31
    variaveis_struct.vao(i).longarina.b3 = variaveis(n); n = n + 1;              % 32
    variaveis_struct.vao(i).longarina.enr = variaveis(n); n = n + 1;             % 33
    variaveis_struct.vao(i).longarina.benr = variaveis(n); n = n + 1;            % 34
    variaveis_struct.vao(i).amp = variaveis(n) * variaveis_struct.vao(i).longarina.h1; n = n + 1;  % 35
    variaveis_struct.vao(i).aap = variaveis(n) * variaveis_struct.vao(i).longarina.h1; n = n + 1;  % 36
    variaveis_struct.vao(i).ntcord = variaveis(n); n = n + 1;                    % 37
    variaveis_struct.vao(i).laje.h = variaveis(n); n = n + 1;                    % 38
end

% Para cada vão adicional
if viaduto.n_apoios == 2
    variaveis_struct.x_apoio_intermediarios = [];
end

for i = 2:viaduto.n_apoios-1
    % Apoio
    variaveis_struct.x_apoio_intermediarios(i-1) = variaveis(n); n = n + 1;      % 39   63
    variaveis_struct.apoio(i).profundidade_fundacao = variaveis(n); n = n + 1;   % 40   64
    variaveis_struct.apoio(i).n_pilares = variaveis(n); n = n + 1;               % 41   65
    variaveis_struct.apoio(i).fustes.d = variaveis(n); n = n + 1;                % 42   66
    variaveis_struct.apoio(i).pilares.d = variaveis(n); n = n + 1;               % 43   67
    variaveis_struct.apoio(i).travessa.h = variaveis(n); n = n + 1;              % 44   68
    variaveis_struct.apoio(i).travessa.b = variaveis(n); n = n + 1;              % 45   69
    variaveis_struct.apoio(i).travessa.bl = variaveis(n); n = n + 1;             % 46   70
    % Vao
    variaveis_struct.vao(i).n_longarinas = variaveis(n); n = n + 1;              % 47   71
    variaveis_struct.vao(i).hap = variaveis(n); n = n + 1;                       % 48   72
    variaveis_struct.vao(i).longarina.h1 = variaveis(n); n = n + 1;              % 49   73
    variaveis_struct.vao(i).longarina.h2 = variaveis(n); n = n + 1;              % 50   74
    variaveis_struct.vao(i).longarina.h3 = variaveis(n); n = n + 1;              % 51   75
    variaveis_struct.vao(i).longarina.h4 = variaveis(n); n = n + 1;              % 52   76
    variaveis_struct.vao(i).longarina.h5 = variaveis(n); n = n + 1;              % 53   77
    variaveis_struct.vao(i).longarina.b1 = variaveis(n); n = n + 1;              % 54   78
    variaveis_struct.vao(i).longarina.b2 = variaveis(n); n = n + 1;              % 55   79
    variaveis_struct.vao(i).longarina.b3 = variaveis(n); n = n + 1;              % 56   80
    variaveis_struct.vao(i).longarina.enr = variaveis(n); n = n + 1;             % 57   81
    variaveis_struct.vao(i).longarina.benr = variaveis(n); n = n + 1;            % 58   82
    variaveis_struct.vao(i).amp = variaveis(n) * variaveis_struct.vao(i).longarina.h1; n = n + 1; % 59   83
    variaveis_struct.vao(i).aap = variaveis(n) * variaveis_struct.vao(i).longarina.h1; n = n + 1; % 60   84
    variaveis_struct.vao(i).ntcord = variaveis(n); n = n + 1;                    % 61   85
    variaveis_struct.vao(i).laje.h = variaveis(n); n = n + 1;                    % 62   86
end



%% Constroi o viaduto
viaduto.W = greide.largura;
viaduto.L = greide.x(end) - greide.x(1);

viaduto.x_apoio = [greide.x(1) variaveis_struct.x_apoio_intermediarios greide.x(end)];
viaduto.n_apoios = length(viaduto.x_apoio);

% Remove o campo x_apoio_intermediarios de variaveis
variaveis_struct = rmfield(variaveis_struct,'x_apoio_intermediarios');

% Copia todo o conteudo de variaveis para viaduto
f = fieldnames(variaveis_struct);
for i = 1:length(f)
    viaduto.(f{i}) = variaveis_struct.(f{i});
end

% Copia todo o conteudo de variaveis para viaduto
f = fieldnames(viaduto_padrao);
for i = 1:length(f)
    viaduto.(f{i}) = viaduto_padrao.(f{i});
end

viaduto.fundacao.c = variaveis_struct.fundacao.c;
viaduto.pilares.fck = variaveis_struct.pilares.fck;
viaduto.pilares.c = variaveis_struct.pilares.c;
viaduto.travessas.fck = variaveis_struct.travessas.fck;
viaduto.travessas.c = variaveis_struct.travessas.c;
viaduto.longarinas.fck = variaveis_struct.tabuleiro.fck;
viaduto.longarinas.c = variaveis_struct.longarinas.c;
viaduto.lajes.fck = variaveis_struct.tabuleiro.fck;
viaduto.lajes.c = variaveis_struct.lajes.c;


% Complementa viaduto com valores não existentes em variaveis
for i=1:viaduto.n_apoios
    viaduto.apoio(i).fustes.fck = viaduto.fundacao.fck;
    viaduto.apoio(i).fustes.c = variaveis_struct.fundacao.c;

    viaduto.apoio(i).pilares.fck = variaveis_struct.pilares.fck;
    viaduto.apoio(i).pilares.c = variaveis_struct.pilares.c;

    viaduto.apoio(i).travessa.fck = variaveis_struct.travessas.fck;
    viaduto.apoio(i).travessa.c = variaveis_struct.travessas.c;
end

for i=1:viaduto.n_apoios-1
    viaduto.vao(i).l = (viaduto.x_apoio(i+1)-viaduto.x_apoio(i));%m
    
    viaduto.vao(i).longarina.fck = variaveis_struct.tabuleiro.fck;
    viaduto.vao(i).longarina.c = variaveis_struct.longarinas.c;

    viaduto.vao(i).laje.fck = variaveis_struct.tabuleiro.fck;
    viaduto.vao(i).laje.c = variaveis_struct.lajes.c;


    limites_benr_alterado = rearranja_limites_benr(parametros_gerador_modelo.longarinas.benr,viaduto.vao(i).longarina.b1,viaduto.vao(i).longarina.b2,viaduto.vao(i).longarina.b3);
    viaduto.vao(i).longarina.benr = min([viaduto.vao(i).longarina.benr limites_benr_alterado.max]);
    viaduto.vao(i).longarina.benr = max([viaduto.vao(i).longarina.benr limites_benr_alterado.min]);
end


end