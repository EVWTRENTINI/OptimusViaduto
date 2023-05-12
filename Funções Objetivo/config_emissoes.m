m3_diesel = 3.16; % tCO2
kg_aco = 1.8452/1000; % tCO2
m3_madeira = .4086; % tCO2
%% Concreto                                      
emissoes.concreto(1)  = struct('fck', 15, 'valor', 0.321); % tCO2/m^3
emissoes.concreto(2)  = struct('fck', 20, 'valor', 0.348); % tCO2/m^3
emissoes.concreto(3)  = struct('fck', 25, 'valor', 0.374); % tCO2/m^3
emissoes.concreto(4)  = struct('fck', 30, 'valor', 0.394); % tCO2/m^3
emissoes.concreto(5)  = struct('fck', 35, 'valor', 0.416); % tCO2/m^3
emissoes.concreto(6)  = struct('fck', 40, 'valor', 0.438); % tCO2/m^3
emissoes.concreto(7)  = struct('fck', 45, 'valor', 0.460); % tCO2/m^3
emissoes.concreto(8)  = struct('fck', 50, 'valor', 0.486); % tCO2/m^3
emissoes.concreto(9)  = struct('fck', 60, 'valor', 0.541); % tCO2/m^3
emissoes.concreto(10) = struct('fck', 65, 'valor', 0.579); % tCO2/m^3
emissoes.concreto(11) = struct('fck', 70, 'valor', 0.588); % tCO2/m^3
emissoes.concreto(12) = struct('fck', 80, 'valor', 0.619); % tCO2/m^3

%% Tubulões
emissoes.tubuloes.escavacao_fuste = (186*.18/12)/1000*m3_diesel;    % tCO2/m^3 -  6106325 - 186 kW potencia, .18 l/kWh rendimento combustivel, 12 m³/h de redimento do equipamento
emissoes.tubuloes.alargamento_base = 0;                             % tCO2/m^3 -  6106183 
emissoes.tubuloes.CA50 = kg_aco;                                    % tCO2/kg  -  6106220 
emissoes.tubuloes.lancamento_concreto = 0;                          % tCO2/m^3 -  1106050 

%% Blocos
emissoes.blocos.forma = ((1.222*.075*.075+.075*.025*.54167+.025*.1*5.6864+.025*.3*.9778)+(1.1*.014))*m3_madeira; % tCO2/m^2   - 3108015, Volume de madeira/m² * m3_madeira
emissoes.blocos.CA50 = kg_aco;                             % tCO2/kg  -  6106220
emissoes.blocos.lancamento_concreto = 0;                   % tCO2/m^3 -  1106050 

%% Pilares
emissoes.pilares.forma = (.4323+(.04*4*.003*7850)*.01875) * kg_aco;  % tCO2/m^2   - 3108150 peso em kilos/m² * kg_aco
emissoes.pilares.CA50 = kg_aco;                               % tCO2/kg    - 0407819 
emissoes.pilares.lancamento_concreto = (136*.18/33.2)/1000*m3_diesel;    % tCO2/m^3   - 1107860 - 136 kW potencia, .18 l/kWh rendimento combustivel, 33.2 m³/h de redimento do equipamento

%% Travessas
emissoes.travessas.forma = ((1.222*.075*.075+.075*.025*.54167+.025*.1*5.6864+.025*.3*.9778)+(1.1*.014))*m3_madeira; % tCO2/m^2   - 3108015, Volume de madeira/m² * m3_madeira
emissoes.travessas.cimbramento = (.075*.1*.275+.025*.15*2.52175+.025*.3*.0825+pi*.15^2/4*1.03812)*m3_madeira;       % tCO2/m^3   - 2108169, Volume de madeira/m³ * m3_madeira
emissoes.travessas.CA50 = kg_aco;                                                                                   % tCO2/kg    - 0407819 
emissoes.travessas.lancamento_concreto = (136*.18/33.2)/1000*m3_diesel;                                             % tCO2/m^3   - 1107860 - 136 kW potencia, .18 l/kWh rendimento combustivel, 33.2 m³/h de redimento do equipamento

%% Longarinas
emissoes.longarinas.aparelho_de_apoio = 0;                               % tCO2/dcm^3 - 0307732 
emissoes.longarinas.CA50 = kg_aco;                                       % tCO2/kg    - 0407819 
emissoes.longarinas.forma = (2.01747+(.04*4*.003*7850)*.11933) * kg_aco; % tCO2/m^2   - 3106427 peso em kilos/m² * kg_aco
emissoes.longarinas.lancamento_concreto = (136*.18/33.2)/1000*m3_diesel; % tCO2/m^3   - 1107860 - 136 kW potencia, .18 l/kWh rendimento combustivel, 33.2 m³/h de redimento do equipamento

emissoes.longarinas.manobra_lancamento(1) = struct('peso',  400, 'valor',  ((2*450*.18/1.18571 + (2*450*.18 + 323*.18)/1.66000))/1000*m3_diesel);  % tCO2/un - 3806420 + 5915400 potencia * rendimento combustivel * rendimento serviço - utiliza 2 guindastes
emissoes.longarinas.manobra_lancamento(2) = struct('peso',  500, 'valor',  ((2*450*.18/1.18571 + (2*450*.18 + 323*.18)/1.66000))/1000*m3_diesel);  % tCO2/un - 3806420 + 5915400 potencia * rendimento combustivel * rendimento serviço - utiliza 2 guindastes
emissoes.longarinas.manobra_lancamento(3) = struct('peso',  750, 'valor',  ((2*450*.18/0.92222 + (2*450*.18 + 440*.18)/1.66000))/1000*m3_diesel);  % tCO2/un - 3806421 + 5915401 potencia * rendimento combustivel * rendimento serviço - utiliza 2 guindastes
emissoes.longarinas.manobra_lancamento(4) = struct('peso', 1000, 'valor',  ((2*450*.18/1.03750 + (2*500*.18 + 323*.18)/1.38334))/1000*m3_diesel);  % tCO2/un - 3806422 + 5915402 potencia * rendimento combustivel * rendimento serviço - utiliza 2 guindastes
emissoes.longarinas.manobra_lancamento(5) = struct('peso', 1250, 'valor',  ((2*450*.18/0.83000 + (2*500*.18 + 440*.18)/1.38334))/1000*m3_diesel);  % tCO2/un - 3806423 + 5915369 potencia * rendimento combustivel * rendimento serviço - utiliza 2 guindastes
emissoes.longarinas.cordoalha_127 = kg_aco;                              % tCO2/kg    - 4507956 
emissoes.longarinas.cordoalha_152 = kg_aco;                              % tCO2/kg    - 4507957 

emissoes.longarinas.bainha(1)  = struct('diametro',  30, 'valor', pi*.030*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(2)  = struct('diametro',  35, 'valor', pi*.035*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(3)  = struct('diametro',  40, 'valor', pi*.040*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(4)  = struct('diametro',  45, 'valor', pi*.045*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(5)  = struct('diametro',  50, 'valor', pi*.050*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(6)  = struct('diametro',  55, 'valor', pi*.055*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(7)  = struct('diametro',  60, 'valor', pi*.060*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(8)  = struct('diametro',  65, 'valor', pi*.065*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(9)  = struct('diametro',  70, 'valor', pi*.070*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(10) = struct('diametro',  75, 'valor', pi*.075*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(11) = struct('diametro',  80, 'valor', pi*.080*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(12) = struct('diametro',  85, 'valor', pi*.085*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(13) = struct('diametro',  90, 'valor', pi*.090*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(14) = struct('diametro',  95, 'valor', pi*.095*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(15) = struct('diametro', 100, 'valor', pi*.100*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(16) = struct('diametro', 110, 'valor', pi*.110*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(17) = struct('diametro', 120, 'valor', pi*.120*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 
emissoes.longarinas.bainha(18) = struct('diametro', 130, 'valor', pi*.130*.0003*2*7850 * kg_aco);  % tCO2/m     - 4507739 - peso considerando 3 mm de espessura e multiplicado por 2 para considerar a parte corrugada 

%                                                                              ativa  + passiva
emissoes.longarinas.ancoragens_127(1)  = struct('n_cordoalhas',   4, 'valor',  (  6 + 0.7) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(2)  = struct('n_cordoalhas',   6, 'valor',  ( 16 + 1.3) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(3)  = struct('n_cordoalhas',   8, 'valor',  ( 20 + 1.6) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(4)  = struct('n_cordoalhas',  10, 'valor',  ( 20 + 2.1) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(5)  = struct('n_cordoalhas',  12, 'valor',  ( 20 + 2.5) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(6)  = struct('n_cordoalhas',  19, 'valor',  ( 35 + 3.5) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(7)  = struct('n_cordoalhas',  22, 'valor',  ( 48 + 3.8) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(8)  = struct('n_cordoalhas',  27, 'valor',  ( 76 + 4.8) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_127(9)  = struct('n_cordoalhas',  31, 'valor',  (101 + 5.4) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf

emissoes.longarinas.ancoragens_152(1)  = struct('n_cordoalhas',   4, 'valor',  (  9 + 0.7) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_152(2)  = struct('n_cordoalhas',   6, 'valor',  ( 16 + 1.3) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_152(3)  = struct('n_cordoalhas',   8, 'valor',  ( 20 + 1.6) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_152(4)  = struct('n_cordoalhas',  10, 'valor',  ( 31 + 2.1) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_152(5)  = struct('n_cordoalhas',  12, 'valor',  ( 35 + 2.5) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_152(6)  = struct('n_cordoalhas',  15, 'valor',  ( 48 + 2.6) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_152(7)  = struct('n_cordoalhas',  19, 'valor',  ( 70 + 2.6) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
emissoes.longarinas.ancoragens_152(8)  = struct('n_cordoalhas',  22, 'valor',  (101 + 2.8) * kg_aco);  % R$/m     - 4507766 Ancoragem ativa e passiva catalogo da rudloff https://api.aecweb.com.br/cls/catalogos/rudloff/catalogo_concreto_protendido.pdf
 
%% Lajes
%emissoes.lajes.lancamento_pre_laje = 64.51;                % tCO2/t     - 3806426 Lançamento de pré-laje com utilização de guindauto
emissoes.lajes.trelicas = kg_aco;                            % tCO2/kg    - 0407743
emissoes.lajes.CA50 = kg_aco;                               % tCO2/kg    - 0407819
emissoes.lajes.lancamento_concreto = (136*.18/33.2)/1000*m3_diesel;   % tCO2/m^3   - 1107860 - 136 kW potencia, .18 l/kWh rendimento combustivel, 33.2 m³/h de redimento do equipamento


