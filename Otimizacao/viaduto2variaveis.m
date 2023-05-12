function variaveis = viaduto2variaveis(viaduto)

variaveis_struct.x_apoio_intermediarios = viaduto.x_apoio(2:end-1);

variaveis_struct.fundacao.c = viaduto.fundacao.c;

variaveis_struct.pilares.fck = viaduto.pilares.fck; 
variaveis_struct.pilares.c = viaduto.pilares.c;

variaveis_struct.travessas.fck = viaduto.travessas.fck; 
variaveis_struct.travessas.c = viaduto.travessas.c; 

variaveis_struct.tabuleiro.fck = viaduto.tabuleiro.fck; 
variaveis_struct.longarinas.c  = viaduto.longarinas.c;  
variaveis_struct.lajes.c = viaduto.lajes.c;

for i=1:viaduto.n_apoios
    variaveis_struct.apoio(i).profundidade_fundacao = viaduto.apoio(i).profundidade_fundacao;
    variaveis_struct.apoio(i).n_pilares = viaduto.apoio(i).n_pilares;
    variaveis_struct.apoio(i).fustes.d = viaduto.apoio(i).fustes.d;
    variaveis_struct.apoio(i).pilares.d = viaduto.apoio(i).pilares.d;
    variaveis_struct.apoio(i).travessa.h = viaduto.apoio(i).travessa.h;
    variaveis_struct.apoio(i).travessa.b = viaduto.apoio(i).travessa.b;
    variaveis_struct.apoio(i).travessa.bl = viaduto.apoio(i).travessa.bl;
end


for i=1:viaduto.n_apoios-1
    variaveis_struct.vao(i).n_longarinas = viaduto.vao(i).n_longarinas;
    variaveis_struct.vao(i).hap = viaduto.vao(i).hap;

    variaveis_struct.vao(i).longarina.h1 = viaduto.vao(i).longarina.h1;
    variaveis_struct.vao(i).longarina.h2 = viaduto.vao(i).longarina.h2;
    variaveis_struct.vao(i).longarina.h3 = viaduto.vao(i).longarina.h3;
    variaveis_struct.vao(i).longarina.h4 = viaduto.vao(i).longarina.h4;
    variaveis_struct.vao(i).longarina.h5 = viaduto.vao(i).longarina.h5;
    variaveis_struct.vao(i).longarina.b1 = viaduto.vao(i).longarina.b1;
    variaveis_struct.vao(i).longarina.b2 = viaduto.vao(i).longarina.b2;
    variaveis_struct.vao(i).longarina.b3 = viaduto.vao(i).longarina.b3;
    
    variaveis_struct.vao(i).longarina.enr = viaduto.vao(i).longarina.enr;
    variaveis_struct.vao(i).longarina.benr = viaduto.vao(i).longarina.benr;

    variaveis_struct.vao(i).amp = viaduto.vao(i).amp;
    variaveis_struct.vao(i).aap = viaduto.vao(i).aap;
    variaveis_struct.vao(i).ntcord = viaduto.vao(i).ntcord;

    variaveis_struct.vao(i).laje.h = viaduto.vao(i).laje.h;
end


%% Planifica a estrutura
n = 1;

% Variaveis fixas independente do numero de vãos
variaveis(n) = variaveis_struct.fundacao.c; n = n + 1;
variaveis(n) = variaveis_struct.pilares.fck*1E-6; n = n + 1;
variaveis(n) = variaveis_struct.pilares.c; n = n + 1;
variaveis(n) = variaveis_struct.travessas.fck*1E-6; n = n + 1;
variaveis(n) = variaveis_struct.travessas.c; n = n + 1;
variaveis(n) = variaveis_struct.tabuleiro.fck*1E-6; n = n + 1;
variaveis(n) = variaveis_struct.longarinas.c; n = n + 1;
variaveis(n) = variaveis_struct.lajes.c; n = n + 1;

% Primeiro e ultimo apoio
for i = [1 viaduto.n_apoios]
    variaveis(n) = variaveis_struct.apoio(i).profundidade_fundacao; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).n_pilares; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).fustes.d; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).pilares.d; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).travessa.h; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).travessa.b; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).travessa.bl; n = n + 1;
end

% Primeiro vão
for i = 1
    variaveis(n) = variaveis_struct.vao(i).n_longarinas; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).hap; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h2; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h3; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h4; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h5; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.b1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.b2; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.b3; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.enr; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.benr; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).amp / variaveis_struct.vao(i).longarina.h1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).aap / variaveis_struct.vao(i).longarina.h1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).ntcord; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).laje.h; n = n + 1;
end

% Para cada vão adicional
for i = 2:viaduto.n_apoios-1
    % Apoio
    variaveis(n) = variaveis_struct.x_apoio_intermediarios(i-1); n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).profundidade_fundacao; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).n_pilares; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).fustes.d; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).pilares.d; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).travessa.h; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).travessa.b; n = n + 1;
    variaveis(n) = variaveis_struct.apoio(i).travessa.bl; n = n + 1;
    % Vao
    variaveis(n) = variaveis_struct.vao(i).n_longarinas; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).hap; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h2; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h3; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h4; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.h5; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.b1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.b2; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.b3; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.enr; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).longarina.benr; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).amp / variaveis_struct.vao(i).longarina.h1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).aap / variaveis_struct.vao(i).longarina.h1; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).ntcord; n = n + 1;
    variaveis(n) = variaveis_struct.vao(i).laje.h; n = n + 1;
end

end