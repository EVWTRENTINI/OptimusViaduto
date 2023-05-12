function [situacao, msg_erro] = avalia_aparelho_de_apoio(a, b, Fg, Fq, Hg, Hq, alfa_g, alfa_q, G, fyk, cl, ne, he, ni, hi, h_total, hs)
%% Definições iniciais

situacao=true;
msg_erro='sem erro';

g = 9.806; % Gravidade em m/s²
het = ne*he + ni*hi; %cm, Altura de elastomero total

ug = (Hg * het)/(1 * G * a * b);
uq = (Hq * het)/(2 * G * a * b);

al = a - 2*cl;
bl = b - 2*cl;

Aref = al*bl;
Al = (Aref-(ug+uq)*bl);

Nmax = Fq + Fg;

%% Limite da tensão de compressão

tensao_normal_adm = define_tensao_normal_adm(a);

% tensao_normal_adm = 125 % Para bater com o exemplo do catalogo

tensao_normal_max = Nmax / Al; % A norma não exige que se desconte a defomração horizontal. O catalo Neoprex sim, e acho coerente.

if tensao_normal_max > tensao_normal_adm
    situacao = false;
    msg_erro = 'Limite da tensão de compressão máxima excedida no aparelho de apoio.';
    return
end


%% Limite da tensão de cisalhamento

tensao_cisalhamento_adm = 5 * G;

%teta_0 = .01; % rad, imprecisao inicial de acordo com braga (1986) segundo El Debs (2021)
teta_0 = 0; % rad, imprecisao inicial
if (tan(alfa_g) + 1.5*tan(alfa_q)) > 0
    teta_0 = teta_0;
else
    teta_0 = -teta_0;
end

Si = al*bl/(2*hi*(al+bl)); % Fator de forma da NBR 9062:2017 item 7.2.1.6.24

tau_n = 1.5/Si * (Fg + 1.5 * Fq)/(a*b);
tau_h = (Hg + 0.5 * Hq)/(a*b);
tau_t = G*a^2 / (2*hi*(ni*hi)) * abs(tan(alfa_g+teta_0) + 1.5*tan(alfa_q));

tensao_cisalhamento_max = tau_n + tau_h + tau_t;


if tensao_cisalhamento_max > tensao_cisalhamento_adm
    situacao = false;
    msg_erro = 'Limite da tensão de cisalhamento máxima excedida no aparelho de apoio.';
    return
end

%% Limite da deformacao por compressão

deformacao_por_compressao_adm = 0.15 * het;
%deformacao_por_compressao_adm = 0.25 * het;

%beta_ref = Aref/(2*het*(al+bl));

deformacao_por_compressao_max = tensao_normal_max / (4*G*Si + 3*tensao_normal_max) * het;

if deformacao_por_compressao_max > deformacao_por_compressao_adm
    situacao = false;
    msg_erro = 'Limite de deformação por compressão excedida no aparelho de apoio.';
    return
end

%% Limite da deformação por cisalhamento

ah_adm = h_total / 2; % NBR 9062:2017 item 7.2.1.6.21
ah_max = ug + uq;

if ah_max > ah_adm
    situacao = false;
    msg_erro = 'Limite de deformação de cisalhamento excedida no aparelho de apoio.';
    return
end

%% Segurança contra o deslizamento
%%% Atrito de Coulomb
%%%% Viaduto descarregado
mig = 0.1 + 0.6/(((Fg)*g/1E6)/(Al*1E-4)); % Atrito

H_adm = Fg * mig;

H_max = Hg;

if H_max > H_adm
    situacao = false;
    msg_erro = 'Segurança contra deslizamento não atendida no aparelho de apoio, viaduto descarregado.';
    return
end

%%%% Viaduto carregado
miq = 0.1 + 0.6/(((Fg + Fq)*g/1E6)/(Al*1E-4)); % Atrito

H_adm = (Fg + Fq) * miq;

H_max = Hg + Hq;

if H_max > H_adm
    situacao = false;
    msg_erro = 'Segurança contra deslizamento não atendida no aparelho de apoio, viaduto carregado.';
    return
end

%%% Tensão minima  

% tensao_normal_min = (Fg*g/1E6) / (Al*1E-4); % em MPa
% tensao_normal_min_adm = 2; % em MPa
% 
% if tensao_normal_min < tensao_normal_min_adm
%     situacao = false;
%     msg_erro = 'Segurança contra deslizamento não atendida no aparelho de apoio, tensão normal menor que a mínima.';
%     return
% end

%% Condição de não levantamento da borda menos carregada
%%% Viaduto descarregado
sigma_g = Fg / Al; % kgf/cm²
h1i = (hi * sigma_g)/(4*G*Si^2 + 3*sigma_g); % Na NBR 9062:2017 item 7.2.1.6.24 tem o quadrado no Si, acredito estar equivocado
tgg_adm = 6*ni*h1i / al;

tgg_atu = abs(tan(alfa_g));

if tgg_atu > tgg_adm
    situacao = false;
    msg_erro = 'Condição de não levantamento da borda menos descarregada não atendida no aparelho de apoio, viaduto descarregado.';
    return
end

%%% Viaduto carregado
sigma_gq = (Fg + Fq) / Al; % kgf/cm²
h2i = (hi * sigma_gq)/(4*G*Si^2 + 3*sigma_gq); % Na NBR 9062:2017 item 7.2.1.6.24 tem o quadrado no Si, acredito estar equivocado
tggq_adm = 6*ni*h2i / al;

tggq_atu = abs(tan(alfa_g) + 1.5 * tan(alfa_q));

if tggq_atu > tggq_adm
    situacao = false;
    msg_erro = 'Condição de não levantamento da borda menos descarregada não atendida no aparelho de apoio, viaduto carregado.';
    return
end


%% Verificação da estabilidade
% Catalogo NEOPREX item 10.2.6
tensao_normal_flambagem_adm = 2*al*G*Si/(3*(ni*hi+2.8*he));

if tensao_normal_max > tensao_normal_flambagem_adm
    situacao = false;
    msg_erro = 'Verificação de estabilidade não atendida no aparelho de apoio.';
    return
end

%%  Verificação das chapas de aço
hs_adm = al*tensao_normal_max/(Si*fyk);

if hs < hs_adm
    situacao = false;
    msg_erro = 'Verificação das chapas de aço do aparelho de apoio não atendida.';
    return
end




end

function tensao_normal_adm = define_tensao_normal_adm(a)
% Define a tensão normal admissivel em kgf/cm² em função da largura a em centimetros
if a <= 15
    tensao_normal_adm = 80;
elseif a <= 20
    tensao_normal_adm = 110;
elseif a <= 30
    tensao_normal_adm = 125;
else
    tensao_normal_adm = 150;
end
end