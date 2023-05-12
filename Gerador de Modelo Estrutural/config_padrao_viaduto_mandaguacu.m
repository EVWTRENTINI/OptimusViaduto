%% Parametros gerais

viaduto.nfaixa=2;
viaduto.hpav=.1;%m
viaduto.Umi=75;%Umidade relativa do ar em para cálculo da retração
viaduto.Ti=25;%Temperatura média diária do ambiente em graus Celsius
viaduto.nivel_minimo_de_protensao=2;% 2 é protensão limitada, 3 é protensão completa, protensão parcial não é aceito.
viaduto.DMLG=15;%(Data da montagem das longarinas) em dias, usado na instabilidade da longarina e no calculo da fluencia dos pilares
viaduto.DCLJ=20;%(Data da concretagem da laje) em dias, usado na instabilidade da longarina e no dimensionamento a flexão da longarina
viaduto.delta_temperatura = 15; % em °C. Variação de temperatura - utilizado nos casos de carregamentos com valor negativo
viaduto.h_bloco_enterrado=0.0;%metros

%% Parametros dos materiais
viaduto.gama_c=1.4;  %ELU - Combinação Ultima Normal
viaduto.gama_s=1.15; %ELU - Combinação Ultima Normal
viaduto.fyk=50;
viaduto.Ep=20000;%kN/cm² %modulo de elasticidade aço ativo
viaduto.fpyd=146;%kN/cm² 
viaduto.fptd=162.6;%kN/cm²
viaduto.Eppu=35;%‰
viaduto.Es=21000;%kN/cm² %modulo de elasticidade aço passivo

viaduto.alfa_e=1.2;%brita
viaduto.cdl=1E-5;%ºC^-1 %Coeficiente de dilatação linear do concreto
% Carvalho (2012) - Estruturas de Concreto Protendido

viaduto.fundacao.tipo_cimento='CPIIE'; % Para Cálculo da vida útil de projeto
viaduto.pilares.tipo_cimento='CPIIE'; % Para Cálculo da vida útil de projeto
viaduto.travessas.tipo_cimento='CPIIE'; % Para Cálculo da vida útil de projeto
viaduto.longarinas.tipo_cimento='CPIIE'; % Para Cálculo da vida útil de projeto
viaduto.lajes.tipo_cimento='CPIIE'; % Para Cálculo da vida útil de projeto


%% Parametros da discretização de carregamento
viaduto.Vnx=2;%numero de intervalos entre divisões em x
viaduto.Vny=4;%numero de intervalos entre divisões em y

viaduto.Mny=5;%numero de faixas de carregamento de multidão

%% Força do vento
viaduto.V90_tabuleiro_carregado=1.0;%Força do vento no tabueliro carregado em kN/m²
viaduto.V90_tabuleiro_descarregado=1.5;%Força do vento no tabueliro descarregado em kN/m²

%% Parametros para dimensionamento dos pilares
viaduto.pilares.folga_minima_entre_faces = 1; % Folga minima entre faces de pilares em metros.
viaduto.pilares.altura_minima = 2; % Altura mínima do pilar em metros. Não menor que 1.25 m.
viaduto.pilares.abatimento=7;%abatimento do concreto em centimetros;
viaduto.pilares.alfa_flu=2;%Endurecimento normal
viaduto.pilares.s=.25;% Concreto de cimento CP I e II
viaduto.pilares.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
viaduto.pilares.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
viaduto.pilares.fi_t=.008;%diametro da armadura transversal em m


viaduto.metodo_dim_pilar=2;   % 1 Pilar padrão com curvatura aproximada; 2 Pilar padrão acoplado a diagramas M, N, 1/r 
viaduto.gama_f3=1.1;%utilizado no diagrama normal momento curvatura



%% Discretização do detalhamento da armadura transversal
    
viaduto.disc_cor_tor=[.35]; % Discretização até a metade do vão, valor maximo 0.5. É tratado como simetrico. É adicionado a posição da transição do enrijecimento também.



%% Parametros para dimensionamento da longarina

viaduto.folga=.50;%m Folga entre nó inicial e final das longarinas consecutivas 
viaduto.junta=.05;%m Junta de dilatação entre tabuleiros (contida dentro da folga)
viaduto.comprimento_apoiado_pre_laje = .05; %m Comprimento do apoio da pré laje sobre a longarina. Utilizado para o calculo do cisalhamento na interface.

viaduto.disc_cabos=10;% intervalos alem dos dois extremos (Necessariamente par)

viaduto.limite_Pi_fptk=.74;%limite pós tração RB
viaduto.limite_Pi_fpyk=.82;%limite pós tração RB
viaduto.mi=.2;%Coeficiente de atrito
viaduto.ka=.01*viaduto.mi;%Coeficiente de perda devido a curvas não intencionais
viaduto.acomodacao_anc=.006;%m %acomodação da ancoragem em metros

viaduto.tipo_diametro_cordoalha = 1;% Tipo 1 é cordoalha de 12,7 mm; Tipo 2 é cordoalha de 15,2 mm.

viaduto.longarinas.folga_entre_longarinas = .35; % Folga entre longarinas em metros, % Estava 50 cm não sei pq, alterado para 35 cm em 29/11/22.
viaduto.longarinas.abatimento=7;%abatimento do concreto em centimetros;
viaduto.longarinas.alfa_ret=1;%Endurecimento normal
viaduto.longarinas.alfa_flu=2;%Endurecimento normal
viaduto.longarinas.s=.25;% Concreto de cimento CP I e II
viaduto.longarinas.delta_t_ef=10;%(Data da protensão)Período, em dias, durante o qual a temperatura média do ambiente, Ti, pode ser admitida constante.

viaduto.longa_fi_long_min=.016;% Diametro minimo da armadura longitudinal da longaria
viaduto.longa_fi_long_max=.025;% Diametro maximo da armadura longitudinal da longaria
viaduto.longa_fi_tran=.0125;% Diametro da armadura transversal da longaria
viaduto.dia_max_agr_grau=.025;% Diamensão máxima do agregado graúdo em milimetros
%Brita 1, 12,5 mm
%Brita 2, 25,0 mm
%Brita 3, 38,5 mm
viaduto.n_max_camadas=30;% Numero maximo de camadas de armadura
viaduto.disc_rep_as=8;%numero de faixas que representam a área de aço passivo

viaduto.dcabo=.066;%diametro do cabo em metros
viaduto.danc=.23;% distancia entre eixo de ancoragens de protensão
viaduto.nmcc=10;%numero máximo de cordoalhas por cabo 

% Flecha
viaduto.mult_flecha_peso_proprio = 2.7;
viaduto.mult_flecha_acoes_permanentes = 3;
viaduto.mult_flecha_protensao = 2.45;
viaduto.mult_flecha_acoes_variaveis = 3;
viaduto.limite_l_sobre_flecha_ativa = 640; % AASHTO(2017)
viaduto.limite_l_sobre_flecha_diferida = 350; % NBR6118:2014

%% Parametros da laje
viaduto.lajes.fi_l=.016;% diametro da armadura long em metros


%% Parametros da fundação
viaduto.fundacao.fck = 25E6; % 25 MPa para classe de agressividade I e II e 40 MPa para III e IV - em Pa
viaduto.l_max_fuste=1;%comprimento maximo da barra que representa o fuste
viaduto.dimensionar_barras_fustes_individualmente=false; %dimensionar todas as barras dos fustes = true; uma vez para o maior esforço das barras dos false = false;
viaduto.fustes.gama_c=3.1;% Escavado sem fluido
viaduto.fustes.fi_l_max=.025;%diametro maximo da armadura longitudinal em m
viaduto.fustes.fi_l_min=.01;%diametro minimo da armadura longitudinal em m
viaduto.fustes.fi_t=.008;%diametro da armadura transversal em m

%% Parametros do aparalho de apoio
%pap=propriedades dos aparelhos de apoio
viaduto.pap.dureza=60;%dureza shore A (entre 50 e 70)
viaduto.pap.cl=.004;%espessura da camada externa de elastomero em metros, cobrimento lateral
viaduto.pap.he=.0025;%espessura da camada externa de elastomero em metros, cobrimento vertical
viaduto.pap.s=.00325;%espessura da chapa de aço em metros
viaduto.pap.himax=.012;%espessura maxima da camada elastomero em metros
viaduto.pap.fb=.1;%diferença entre a largura da base da longarina e a largura do aparelho de apoio em metros
viaduto.pap.a_sobre_b=.625;%relação entre a menor dimensão sobre a maior dimensão


%% Parametros para verificação da estabilidade lateral da longarina 
viaduto.analise_nao_linear_de_estabilidade_lateral=true; %true=faz analise não linear de acordo com Pablo Krahl; false=utiliza limitação de esbeltez da NBR 7187:2021

mT_lg=109.2;%deformação lateral por temperatura da longarina sob aparelho de apoio, multiplicador do quadrado do vão Jong-Han Lee (2012). Def_lateral_temperatura=mT_lg*cdl*l^2, def em centimetros e l em metros

% Longarina sobre aparelhos de apoio
viaduto.ex_ap=0;% (NÃO ESTA USANDO! ARTIGO DO PABLO NÃO USA) excentricidade do posicionamento da longarina sobre o apoio
viaduto.ex_lg=1/300;%excentricidade inicial da longarina em função do comprimento
viaduto.mT_lg_livre=mT_lg;%deformação lateral por temperatura da longarina sob aparelho de apoio, multiplicador do quadrado do vão Jong-Han Lee (2012). Def_lateral_temperatura=mT_lg*cdl*l^2, def em centimetrose l em metros
viaduto.fs_r=1.5;%Fator de minoração da resistencia ao tombamento FS=pp_crit/(pp_long_k*gama_gd_esp)

% Longarina travada no giro
viaduto.mT_lg_travada=mT_lg;%deformação lateral por temperatura da longarina situação com travamento nos apoios, multiplicador do quadrado do vão Jong-Han Lee (2012). Def_lateral_temperatura=mT_lg*cdl*l^2, def em centimetros e l em metros
viaduto.fs_pcrit=4;%Fator de minoração da carga critica FS=w_crit/((pp_long_k+pp_laje_k)*gama_gd_esp)