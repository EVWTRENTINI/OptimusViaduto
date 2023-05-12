% De acordo com SINCRO do DNIT - São Paulo, Abril 2022.
%% Concreto                                      
custos.concreto(1) = struct('fck', 25, 'valor', 386.63);  % R$/m^3   - 1106380 Concreto para bombeamento fck = 25 MPa - confecção em central dosadora de 30 m³/h - areia e brita comerciais
custos.concreto(2) = struct('fck', 30, 'valor', 405.14);  % R$/m^3   - 1106280 Concreto para bombeamento fck = 30 MPa - confecção em central dosadora de 30 m³/h - areia e brita comerciais
custos.concreto(3) = struct('fck', 35, 'valor', 428.98);  % R$/m^3   - 1106281 Concreto para bombeamento fck = 35 MPa - confecção em central dosadora de 30 m³/h - areia e brita comerciais
custos.concreto(4) = struct('fck', 40, 'valor', 455.59);  % R$/m^3   - 1106282 Concreto para bombeamento fck = 40 MPa - confecção em central dosadora de 30 m³/h - areia e brita comerciais
custos.concreto(5) = struct('fck', 50, 'valor', 520.00);  % R$/m^3   - PAVCONCRETO 
custos.concreto(6) = struct('fck', 60, 'valor', 570.00);  % R$/m^3   - PAVCONCRETO 
custos.concreto(7) = struct('fck', 70, 'valor', 590.00);  % R$/m^3   - PAVCONCRETO 
custos.concreto(8) = struct('fck', 80, 'valor', 610.00);  % R$/m^3   - PAVCONCRETO 
custos.concreto(9) = struct('fck', 90, 'valor', 630.00);  % R$/m^3   - PAVCONCRETO 

%% Tubulões
custos.tubuloes.escavacao_fuste = 51.43;                 % R$/m^3   -  6106325 Escavação mecânica de fuste de tubulão com trado para solos em material de 1ª categoria
custos.tubuloes.alargamento_base = 318.61;               % R$/m^3   -  6106183 Escavação manual de base alargada de tubulão a céu aberto em material de 1ª categoria na profundidade de 10 a 15 m
custos.tubuloes.CA50 = 11.18;                            % R$/kg    -  6106220 Armação de fuste de tubulão em aço CA-50 com apoio de guindaste - fornecimento, preparo e colocação
custos.tubuloes.lancamento_concreto = 46.32;             % R$/m^3   - 1106050 Lançamento livre de concreto usinado por meio de caminhão betoneira - confecção em central dosadora de 30 m³/h

%% Blocos
custos.blocos.forma = 147.84;                            % R$/m^2   - 3108015 Fôrmas de compensado plastificado 14 mm - uso geral - utilização de 1 vez - confecção, instalação e retirada
custos.blocos.CA50 = 16.78;                              % R$/kg    - 0407819 Armação em aço CA-50 - fornecimento, preparo e colocação
custos.blocos.lancamento_concreto = 46.32;               % R$/m^3   - 1106050 Lançamento livre de concreto usinado por meio de caminhão betoneira - confecção em central dosadora de 30 m³/h

%% Pilares
custos.pilares.forma = 21.86;                            % R$/m^2   - 3108150 Fôrma metálica curva em chapa 3/16" reforçada com nervuras de 40 mm x 3/16" dispostas em grelhas de 40 x 60 cm - utilização de 100 vezes - confecção, instalação e retirada m²
custos.pilares.CA50 = 16.78;                             % R$/kg    - 0407819 Armação em aço CA-50 - fornecimento, preparo e colocação
custos.pilares.lancamento_concreto = 54.55;              % R$/m^3   - 1107860 Lançamento mecânico de concreto com bomba lança sobre chassi com capacidade de 50 m³/h - confecção em central dosadora de 40 m³/h

%% Travessas
custos.travessas.forma = 147.84;                         % R$/m^2   - 3108015 Fôrmas de compensado plastificado 14 mm - uso geral - utilização de 1 vez - confecção, instalação e retirada 
custos.travessas.escoramento = 49.20;                    % R$/m^3   - 2108169 Escoramento com pontaletes D = 15 cm - utilização de 1 vez - confecção e instalação 
custos.travessas.CA50 = 16.78;                           % R$/kg    - 0407819 Armação em aço CA-50 - fornecimento, preparo e colocação
custos.travessas.lancamento_concreto = 54.55;            % R$/m^3   - 1107860 Lançamento mecânico de concreto com bomba lança sobre chassi com capacidade de 50 m³/h - confecção em central dosadora de 40 m³/h

%% Longarinas
custos.longarinas.aparelho_de_apoio = 82.20;             % R$/dcm^3 - 0307732 Aparelho de apoio de neoprene fretado para estruturas pré-moldadas - fornecimento e instalação 
custos.longarinas.CA50 = 16.78;                          % R$/kg    - 0407819 Armação em aço CA-50 - fornecimento, preparo e colocação
custos.longarinas.forma = 52.71;                         % R$/m^2   - 3106427 Fôrma metálica para viga de concreto pré-moldada protendida para OAE - utilização de 20 vezes - confecção, instalação e retirada
custos.longarinas.lancamento_concreto = 54.55;           % R$/m^3   - 1107860 Lançamento mecânico de concreto com bomba lança sobre chassi com capacidade de 50 m³/h - confecção em central dosadora de 40 m³/h

custos.longarinas.manobra_lancamento(1) = struct('peso',  400, 'valor',  (4445.02 + 3520.31));  % R$/un    - 3806420 + 5915400 Carga, descarga, manobra e lançamento de viga pré-moldada de até 500 kN com utilização de guindaste
custos.longarinas.manobra_lancamento(2) = struct('peso',  500, 'valor',  (4445.02 + 3520.31));  % R$/un    - 3806420 + 5915400 Carga, descarga, manobra e lançamento de viga pré-moldada de até 500 kN com utilização de guindaste
custos.longarinas.manobra_lancamento(3) = struct('peso',  750, 'valor',  (5080.01 + 3953.07));  % R$/un    - 3806421 + 5915401 Carga, descarga, manobra e Lançamento de viga pré-moldada de 500 a 750 kN com utilização de guindaste
custos.longarinas.manobra_lancamento(4) = struct('peso', 1000, 'valor',  (9345.94 + 6716.13));  % R$/un    - 3806422 + 5915402 Carga, descarga, manobra e lançamento de viga pré-moldada de 750 a 1.000 kN com utilização de guindaste
custos.longarinas.manobra_lancamento(5) = struct('peso', 1250, 'valor', (10384.36 + 7258.20));  % R$/un    - 3806423 + 5915369 Carga, descarga, manobra e lançamento de viga pré-moldada de 1.000 a 1.250 kN com utilização de guindaste

custos.longarinas.cordoalha_127 = 13.13;                 % R$/kg    - 4507956 Cordoalha CP 190 RB D = 12,7 mm - fornecimento e instalação
custos.longarinas.cordoalha_152 = 13.59;                 % R$/kg    - 4507957 Cordoalha CP 190 RB D = 15,2 mm - fornecimento e instalação

custos.longarinas.bainha(1)  = struct('diametro',  30, 'valor',  33.58);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(2)  = struct('diametro',  35, 'valor',  35.59);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(3)  = struct('diametro',  40, 'valor',  40.96);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(4)  = struct('diametro',  45, 'valor',  43.13);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(5)  = struct('diametro',  50, 'valor',  46.85);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(6)  = struct('diametro',  55, 'valor',  50.69);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(7)  = struct('diametro',  60, 'valor',  66.38);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(8)  = struct('diametro',  65, 'valor',  74.03);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(9)  = struct('diametro',  70, 'valor',  77.77);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(10) = struct('diametro',  75, 'valor',  79.27);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(11) = struct('diametro',  80, 'valor',  81.41);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(12) = struct('diametro',  85, 'valor', 104.66);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(13) = struct('diametro',  90, 'valor', 111.20);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(14) = struct('diametro',  95, 'valor', 118.90);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(15) = struct('diametro', 100, 'valor', 129.02);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(16) = struct('diametro', 110, 'valor', 137.38);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(17) = struct('diametro', 120, 'valor', 144.76);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento
custos.longarinas.bainha(18) = struct('diametro', 130, 'valor', 148.86);  % R$/m     - 4507739 Bainha metálica redonda D = 35 mm para 2 cordoalhas D = 15,2 mm - fornecimento, instalação e injeção de nata de cimento

%                                                                              ativa  + passiva
custos.longarinas.ancoragens_127(1)  = struct('n_cordoalhas',   4, 'valor',  ( 338.78 +  140.58));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(2)  = struct('n_cordoalhas',   6, 'valor',  ( 486.34 +  207.68));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(3)  = struct('n_cordoalhas',   7, 'valor',  ( 529.06 +  220.03));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(4)  = struct('n_cordoalhas',   8, 'valor',  ( 621.06 +  246.46));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(5)  = struct('n_cordoalhas',   9, 'valor',  ( 698.73 +  274.97));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(6)  = struct('n_cordoalhas',  10, 'valor',  ( 759.53 +  273.46));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(7)  = struct('n_cordoalhas',  12, 'valor',  ( 949.17 +  326.30));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(8)  = struct('n_cordoalhas',  15, 'valor',  (1314.95 +  483.67));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(9)  = struct('n_cordoalhas',  19, 'valor',  (1629.74 +  615.50));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(10) = struct('n_cordoalhas',  22, 'valor',  (2084.76 +  720.88));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(11) = struct('n_cordoalhas',  27, 'valor',  (2474.22 +  892.10));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_127(12) = struct('n_cordoalhas',  31, 'valor',  (3476.11 + 1024.01));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação

custos.longarinas.ancoragens_152(1)  = struct('n_cordoalhas',   4, 'valor',  ( 403.38 +  192.60));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(2)  = struct('n_cordoalhas',   6, 'valor',  ( 579.12 +  284.63));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(3)  = struct('n_cordoalhas',   7, 'valor',  ( 679.49 +  298.11));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(4)  = struct('n_cordoalhas',   8, 'valor',  ( 775.59 +  337.54));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(5)  = struct('n_cordoalhas',   9, 'valor',  ( 899.88 +  377.06));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(6)  = struct('n_cordoalhas',  10, 'valor',  (1009.10 +  377.55));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(7)  = struct('n_cordoalhas',  12, 'valor',  (1234.95 +  456.46));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(8)  = struct('n_cordoalhas',  15, 'valor',  (1595.84 +  587.80));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(9)  = struct('n_cordoalhas',  19, 'valor',  (2048.69 +  745.63));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(10) = struct('n_cordoalhas',  22, 'valor',  (2599.35 +  864.04));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(11) = struct('n_cordoalhas',  27, 'valor',  (3400.47 + 1061.39));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação
custos.longarinas.ancoragens_152(12) = struct('n_cordoalhas',  31, 'valor',  (4681.30 + 1219.31));  % R$/m     - 4507766 Ancoragem ativa e passiva com x cordoalhas aderentes D = 12,7 mm - fornecimento e instalação

%% Lajes
%custos.lajes.lancamento_pre_laje = 64.51;               % R$/t     - 3806426 Lançamento de pré-laje com utilização de guindauto
custos.lajes.trelica = 14.56;                            % R$/kg    - 0407743 Treliça nervurada três barras longitudinais interligadas por duas diagonais sinusoidal - fornecimento e instalação
custos.lajes.CA50 = 16.78;                               % R$/kg    - 0407819 Armação em aço CA-50 - fornecimento, preparo e colocação
custos.lajes.lancamento_concreto = 54.55;                % R$/m^3   - 1107860 Lançamento mecânico de concreto com bomba lança sobre chassi com capacidade de 50 m³/h - confecção em central dosadora de 40 m³/h


