function [orcamento, quantitativo] = orcar_viaduto(custos, viaduto, info)
% Faz o orçamento de acordo com SICRO do DNIT


mult_armadura = 1.1; % Multiplicador de peso de armadura por conta de transpasses


[orcamento.fundacao, quantitativo.fundacao] = orcar_fundacao(viaduto, info, custos, mult_armadura);
[orcamento.pilares, quantitativo.pilares] = orcar_pilares(viaduto, info, custos, mult_armadura);
[orcamento.travessas, quantitativo.travessas] = orcar_travessas(viaduto, info, custos, mult_armadura);
[orcamento.longarinas, quantitativo.longarinas] = orcar_longarinas(viaduto, info, custos, mult_armadura);
[orcamento.lajes, quantitativo.lajes] = orcar_lajes(viaduto, info, custos, mult_armadura);

orcamento.TOTAL = orcamento.fundacao.TOTAL + orcamento.pilares.TOTAL + orcamento.travessas.TOTAL + orcamento.longarinas.TOTAL + orcamento.lajes.TOTAL;


end

function [orcamento, quantitativo] = orcar_fundacao(viaduto, info, custos, mult_armadura)
% Orça a fundação
volume_escavacao_fuste = 0;
volume_concreto_fuste = 0;
volume_base_alargada = 0;
peso_aco_longitudinal_fuste = 0;
peso_aco_transversal_fuste = 0;
volume_bloco = 0;
forma_bloco = 0;
peso_estribos_horizoltais_bloco = 0;
peso_estribos_verticais_bloco  = 0;
fustes_l = zeros(1, viaduto.n_apoios);

for i = 1 : viaduto.n_apoios
    n_pilares = viaduto.apoio(i).n_pilares;
    df = viaduto.apoio(i).fustes.d;
    cf = viaduto.apoio(i).fustes.c;
    cb = viaduto.apoio(i).fustes.c; % Mesmo do fuste pq ja é o mesmo concreto tambem
    fck = viaduto.apoio(i).fustes.fck / 1E6;
    fustes_l(i) = viaduto.apoio(i).cota_topo_bloco - viaduto.apoio(i).cota_fundacao; % Não esta descontado o bloco

    volume_escavacao_fuste = volume_escavacao_fuste + fustes_l(i) * pi*df^2/4 * n_pilares;% Não esta descontado o bloco
    
    for j = 1 : n_pilares
        volume_concreto_fuste = volume_concreto_fuste + (fustes_l(i) - info.blocos.apoio(i).bloco(j).H) * pi*df^2/4;% Descontado o bloco
        dt = info.tubuloes.apoio(i).tubulao(j).diam;
        ht = info.tubuloes.apoio(i).tubulao(j).ht;
        volume_roda_pe = (pi*dt^2/4 - pi*df^2/4) * .2;
        volume_tronco_cone = pi * (ht-.2) / 3 * ((dt/2)^2 + (df/2)^2 + dt*df/4)  - pi*df^2/4*(ht-.2);
        volume_base_alargada = volume_base_alargada + volume_roda_pe + volume_tronco_cone;

        Asl(j) = max(info.fustes.apoio(i).fuste(j).Asl) * 1E-4; % m² - maior em relação a todo o comprimento
        Ast(j) = max(info.fustes.apoio(i).fuste(j).Ast) * 1E-4; % m² - maior em relação a todo o comprimento
        Aslt(j) = max(info.fustes.apoio(i).fuste(j).Aslt) * 1E-4; % m² - maior em relação a todo o comprimento
        

        
        
        Asxy(j) = info.blocos.apoio(i).bloco(j).Asxy * 1E-4; % m² 
        Asxz_yz(j) = info.blocos.apoio(i).bloco(j).Asxz_yz * 1E-4; % m² 



    end
    Asl = max(Asl(j)); % maior entre todos os fustes deste apoio
    Ast = max(Ast(j)); % maior entre todos os fustes deste apoio
    Aslt = max(Aslt(j)); % maior entre todos os fustes deste apoio

    peso_aco_longitudinal_fuste = peso_aco_longitudinal_fuste + ((Asl + Aslt*pi*(df - 2*cf)) * mult_armadura * fustes_l(i) * 7850) * n_pilares;
    peso_aco_transversal_fuste = peso_aco_transversal_fuste + ((Ast) * pi*(df - 2*cf) * mult_armadura * fustes_l(i) * 7850) * n_pilares;% Ast já vem dividido por duas pernas e somada com armadura de torção

   
    Ab = info.blocos.apoio(i).bloco(1).A; % Assumindo que todos são iguais pega a dimensão do primeiro
    Hb = info.blocos.apoio(i).bloco(1).H; % Assumindo que todos são iguais pega a dimensão do primeiro
    volume_bloco = volume_bloco + Ab*Ab*Hb*n_pilares;
    forma_bloco = forma_bloco + (Ab*Hb*4)*n_pilares;


    Asxy = max(Asxy(j)); % maior entre todos os blocos deste apoio
    Asxz_yz = max(Asxz_yz(j)); % maior entre todos os blocos deste apoio

    peso_estribos_horizoltais_bloco = peso_estribos_horizoltais_bloco + (Asxy/2 * (Ab - 2*cb)*4 * mult_armadura * Hb * 7850) * n_pilares;
    peso_estribos_verticais_bloco = peso_estribos_verticais_bloco + (Asxz_yz/2 * ((Ab - 2*cb)*2 + (Hb - 2*cb)*2) * mult_armadura * Ab * 7850)* 2 * n_pilares;

end

quantitativo.volume_escavacao_fuste = volume_escavacao_fuste;
quantitativo.volume_concreto_fuste = volume_concreto_fuste;
quantitativo.volume_base_alargada = volume_base_alargada;
quantitativo.peso_CA50_fuste = peso_aco_longitudinal_fuste + peso_aco_transversal_fuste;

quantitativo.volume_bloco = volume_bloco;
quantitativo.forma_bloco = forma_bloco;
quantitativo.peso_CA50_bloco = peso_estribos_horizoltais_bloco + peso_estribos_verticais_bloco;



orcamento.escavacao_fuste = quantitativo.volume_escavacao_fuste * custos.tubuloes.escavacao_fuste;
orcamento.escavacao_base_alargada = quantitativo.volume_base_alargada * custos.tubuloes.alargamento_base;
orcamento.CA50_fuste = quantitativo.peso_CA50_fuste * custos.tubuloes.CA50;
orcamento.concreto_base_alargada = quantitativo.volume_base_alargada * (custo_interpolado(fck,[transpose([custos.concreto(:).fck]),transpose([custos.concreto(:).valor])]) + custos.tubuloes.lancamento_concreto);
orcamento.concreto_fuste = quantitativo.volume_concreto_fuste * (custo_interpolado(fck,[transpose([custos.concreto(:).fck]),transpose([custos.concreto(:).valor])]) + custos.tubuloes.lancamento_concreto);


orcamento.forma_bloco = quantitativo.forma_bloco * custos.blocos.forma;
orcamento.CA50_bloco = quantitativo.peso_CA50_bloco * custos.blocos.CA50;
orcamento.concreto_bloco = quantitativo.volume_bloco * (custo_interpolado(fck,[transpose([custos.concreto(:).fck]),transpose([custos.concreto(:).valor])]) + custos.blocos.lancamento_concreto);


z = struct2cell(orcamento(:)); 
orcamento.TOTAL = sum(reshape([z{:}],size(z)));
end

function [orcamento, quantitativo] = orcar_pilares(viaduto, info, custos, mult_armadura)
% Orça os pilares

peso_aco_longitudinal = 0;
peso_aco_transversal = 0;
forma = 0;
volume = 0;

for i = 1 : viaduto.n_apoios
    n_pilares = viaduto.apoio(i).n_pilares;
    d = viaduto.apoio(i).pilares.d;
    c = viaduto.apoio(i).pilares.c;
    fck = viaduto.apoio(i).pilares.fck / 1E6;
    pilares_l = info.pilares.apoio(i).pilar(1).cota_topo - viaduto.apoio(i).travessa.h/2 - viaduto.apoio(i).cota_topo_bloco; % Considerando todos os pilares com a mesma altura

    forma = forma + pilares_l * pi*d * n_pilares;
    volume = volume + pilares_l * pi*d^2/4 * n_pilares;

    for j = 1 : n_pilares
        Asl(j) = info.pilares.apoio(i).pilar(j).Asl * 1E-4; % m² 
        Ast(j) = info.pilares.apoio(i).pilar(j).Ast * 1E-4; % m² 
        Aslt(j) = info.pilares.apoio(i).pilar(j).Aslt * 1E-4; % m² 
    end

    Asl = max(Asl(j)); % maior entre todos os pilares deste apoio
    Ast = max(Ast(j)); % maior entre todos os pilares deste apoio
    Aslt = max(Aslt(j)); % maior entre todos os pilares deste apoio

    peso_aco_longitudinal = peso_aco_longitudinal + ((Asl + Aslt*pi*(d - 2*c)) * mult_armadura * pilares_l * 7850) * n_pilares;
    peso_aco_transversal = peso_aco_transversal + ((Ast) * pi*(d - 2*c) * mult_armadura * pilares_l * 7850) * n_pilares; % Ast já vem dividido por duas pernas e somada com armadura de torção

end

quantitativo.volume = volume;
quantitativo.forma = forma;
quantitativo.peso_CA50 = peso_aco_longitudinal + peso_aco_transversal;

orcamento.forma = quantitativo.forma * custos.pilares.forma;
orcamento.CA50 = quantitativo.peso_CA50 * custos.pilares.CA50;
orcamento.concreto = quantitativo.volume * (custo_interpolado(fck,[transpose([custos.concreto(:).fck]),transpose([custos.concreto(:).valor])]) + custos.pilares.lancamento_concreto);


z = struct2cell(orcamento(:)); 
orcamento.TOTAL = sum(reshape([z{:}],size(z)));
end

function [orcamento, quantitativo] = orcar_travessas(viaduto, info, custos, mult_armadura)
% Orça as travessas

peso_aco_longitudinal = 0;
peso_aco_transversal = 0;
forma = 0;
volume = 0;
cimbramento = 0;

for i = 1 : viaduto.n_apoios
    b = viaduto.apoio(i).travessa.b;
    h = viaduto.apoio(i).travessa.h;
    c = viaduto.apoio(i).travessa.c;
    l = viaduto.W;
    fck = viaduto.apoio(i).travessa.fck / 1E6;
    

    pilares_l = info.pilares.apoio(i).pilar(1).cota_topo - viaduto.apoio(i).travessa.h/2 - viaduto.apoio(i).cota_topo_bloco;
    n_pilares = viaduto.apoio(i).n_pilares;
    d_pilares = viaduto.apoio(i).pilares.d;
    cimbramento = cimbramento + (l - n_pilares*d_pilares)*b*pilares_l;
    forma = forma + (2*h + b)*l + b*h*2;
    volume = volume + b*h*l;



    Aslp = max(cell2mat(info.travessas.apoio(i).Aslp)) * 1E-4; % m² % maior entre todos os trechos desta travessa
    Asln = max(cell2mat(info.travessas.apoio(i).Asln)) * 1E-4; % m² % maior entre todos os trechos desta travessa
    Ast  = max(cell2mat(info.travessas.apoio(i).Ast )) * 1E-4; % m² % maior entre todos os trechos desta travessa
    Aslt = max(cell2mat(info.travessas.apoio(i).Aslt)) * 1E-4; % m² % maior entre todos os trechos desta travessa


    peso_aco_longitudinal = peso_aco_longitudinal + ((Aslp + Asln + Aslt*((b - 2*c)*2 + (h - 2*c)*2) + b*h*.1/100*2) * mult_armadura * l * 7850); % Positivo, negativo, torção, pele em cada face
    peso_aco_transversal = peso_aco_transversal + ((Ast) * ((b - 2*c)*2 + (h - 2*c)*2) * mult_armadura * l * 7850); % Ast já vem dividido por duas pernas e somada com armadura de torção

end

quantitativo.cimbramento = cimbramento;
quantitativo.forma = forma;
quantitativo.volume = volume;
quantitativo.peso_CA50 = peso_aco_longitudinal + peso_aco_transversal;

orcamento.cimbramento = quantitativo.cimbramento * custos.travessas.escoramento;
orcamento.forma = quantitativo.forma * custos.travessas.forma;
orcamento.CA50 = quantitativo.peso_CA50 * custos.travessas.CA50;
orcamento.concreto = quantitativo.volume * (custo_interpolado(fck,[transpose([custos.concreto(:).fck]),transpose([custos.concreto(:).valor])]) + custos.travessas.lancamento_concreto);


z = struct2cell(orcamento(:)); 
orcamento.TOTAL = sum(reshape([z{:}],size(z)));
end

function [orcamento, quantitativo] = orcar_longarinas(viaduto, info, custos, mult_armadura)
% Orça as longarinas

volume_aparelho_apoio = 0;
forma = 0;
volume_longarinas = 0;
peso_aco_longitudinal = 0;
peso_aco_transversal = 0;
peso_cordoalha = 0;
ancoragens = 0;

for i = 1 : viaduto.n_apoios - 1
    l = info.longarinas.vao(i).longarina(1).lb; % assume que todas são iguais
    b1 = viaduto.vao(i).longarina.b1; % assume que todas são iguais
    n_longarinas = viaduto.vao(i).n_longarinas;
    fck = viaduto.vao(i).longarina.fck / 1E6;
    Apre = info.longarinas.vao(i).longarina(1).Apre; % assume que todas são iguais
    Apreenr = info.longarinas.vao(i).longarina(1).Apreenr; % assume que todas são iguais
    uepre = info.longarinas.vao(i).longarina(1).uel; % assume que todas são iguais
    uepreenr = info.longarinas.vao(i).longarina(1).uelenr; % assume que todas são iguais
    upre = info.longarinas.vao(i).longarina(1).ul; % assume que todas são iguais
    upreenr = info.longarinas.vao(i).longarina(1).ulenr; % assume que todas são iguais
    enr = viaduto.vao(i).longarina.enr;
    h1 = viaduto.vao(i).longarina.h1;
    bwenr = viaduto.vao(i).longarina.benr;
    bw = viaduto.vao(i).longarina.b2;

    hap = viaduto.vao(i).hap * 10; % dcm³
    bap = info.aparelhos_de_apoio.vao(i).b * 10; % dcm³
    aap = info.aparelhos_de_apoio.vao(i).a * 10; % dcm³

    volume_aparelho_apoio = volume_aparelho_apoio + (hap * aap * bap)*n_longarinas*2;
    forma = forma + ((upreenr - b1)*l*enr*2 + (upre - b1)*(l-l*enr*2) + Apreenr*2)*n_longarinas;
    volume_longarina = (Apreenr*l*enr*2 + Apre*(l-l*enr*2));
    volume_longarinas = volume_longarinas + volume_longarina*n_longarinas;
    peso_longarina = volume_longarina * 25;
    custo_manobra_lancamento = custo_interpolado(peso_longarina, [transpose([custos.longarinas.manobra_lancamento(:).peso]),transpose([custos.longarinas.manobra_lancamento(:).valor])]);
    quantitativo.manobra_lancamento.peso_longarina(i) = peso_longarina;
    quantitativo.manobra_lancamento.custo_por_un(i) = custo_manobra_lancamento;
    quantitativo.manobra_lancamento.un(i) = n_longarinas;

    p_disc = viaduto.vao(i).disc_cor_tor(1:floor(length(viaduto.vao(i).disc_cor_tor)/2))*l; % Posição das discretizações
    p_disc(end+1) = l/2;
    
    l_disc = zeros(1, length(p_disc) - 1);
    
    Ast = max(transpose(reshape([info.longarinas.vao(i).longarina(:).Ast],length(l_disc),n_longarinas))) * 1E-4; % m²
    Aslt = max(transpose(reshape([info.longarinas.vao(i).longarina(:).Aslt],length(l_disc),n_longarinas))) * 1E-4; % m²

    if viaduto.tipo_diametro_cordoalha == 1 % se for tipo 1 é de 12,7mm
        custo_cordoalha = custos.longarinas.cordoalha_127;
        custo_ancoragens_diametro = custos.longarinas.ancoragens_127;
    else %se for tipo 2 é de 15,2mm, utilizando else para não interromper o processo caso qualquer outro valor for utilizado.
        custo_cordoalha = custos.longarinas.cordoalha_152;
        custo_ancoragens_diametro = custos.longarinas.ancoragens_152;
    end

    peso_aco_transversal_uma_longarina = zeros(1, length(p_disc) - 1);
    peso_aco_longitudinal_torcao = zeros(1, length(p_disc) - 1);
        for j = 1 : length(p_disc) - 1
        l_disc(j) = (p_disc(j+1) - p_disc(j))*2; % Comprimento de cada discretização, ja somando a parte simetrica
        if p_disc(j) < enr*l % Utilizar seção enrijecida
            peso_aco_transversal_uma_longarina(j) = Ast(j) * uepreenr * l_disc(j) *2.1648 * 7850; %*2.1648 é o comprimento do aço em função perimetro
            peso_aco_longitudinal_torcao(j) = Aslt(j) * uepreenr * l_disc(j) * mult_armadura * 7850;
        else % Utilizar seção normal
            peso_aco_transversal_uma_longarina(j) = Ast(j) * uepre * l_disc(j) *2.1648 * 7850; %*2.1648 é o comprimento do aço em função perimetro
            peso_aco_longitudinal_torcao(j) = Aslt(j) * uepre * l_disc(j) * mult_armadura * 7850;
        end
    end

    peso_aco_transversal_uma_longarina = sum(peso_aco_transversal_uma_longarina);
    peso_aco_longitudinal_torcao = sum(peso_aco_longitudinal_torcao);
    peso_aco_pele = ((bwenr*h1*.1/100*2 * (l*enr*2) + bw*h1*.1/100*2 * (l-l*enr*2)) * 7850) * mult_armadura;
    
    
    Asl = max([info.longarinas.vao(i).longarina(:).Asl]) * 1E-4; % m²
    peso_aco_longitudinal = peso_aco_longitudinal + (Asl * l * mult_armadura * 7850 + peso_aco_longitudinal_torcao + peso_aco_pele) * n_longarinas;
    peso_aco_transversal = peso_aco_transversal + peso_aco_transversal_uma_longarina * n_longarinas;
    
    % Protensão 
    [comprimento_cabos, comprimento_cordoalhas] = calc_comprimento_cabos(info.longarinas.vao(i).longarina(1).cabos,info.longarinas.vao(i).longarina(1).aal);% assume que todas as longarinas são iguais. Comprimento de cabos em 1 longarina
    peso_cordoalha = peso_cordoalha + (comprimento_cordoalhas*viaduto.area_cordoalha*1E-4*7850) * n_longarinas;
    
    quantitativo.bainhas.custo_por_comprimento(i) = custo_interpolado(viaduto.dcabo*1000,[transpose([custos.longarinas.bainha(:).diametro]),transpose([custos.longarinas.bainha(:).valor])]);
    quantitativo.bainhas.comprimento(i) = comprimento_cabos * n_longarinas;
    
    
    n_cabos = length(info.longarinas.vao(i).longarina(1).cabos);
    for nc = 1 : n_cabos% assume que todas as longarinas são iguais. Comprimento de cabos em 1 longarina
        n_cordoalhas = info.longarinas.vao(i).longarina(1).aal.ncord(nc);% assume que todas as longarinas são iguais. Comprimento de cabos em 1 longarina
        ancoragens = ancoragens + custo_interpolado(n_cordoalhas,[transpose([custo_ancoragens_diametro(:).n_cordoalhas]),transpose([custo_ancoragens_diametro(:).valor])]) * n_longarinas;
    end

end

quantitativo.volume_aparelho_apoio = volume_aparelho_apoio;
quantitativo.forma = forma;
quantitativo.peso_CA50 = peso_aco_longitudinal + peso_aco_transversal;
quantitativo.peso_cordoalha = peso_cordoalha;
quantitativo.volume_longarinas = volume_longarinas;

orcamento.aparelho_de_apoio = quantitativo.volume_aparelho_apoio * custos.longarinas.aparelho_de_apoio;
orcamento.forma = quantitativo.forma * custos.longarinas.forma;
orcamento.CA50 = quantitativo.peso_CA50 * custos.longarinas.CA50;
orcamento.cordoalha = quantitativo.peso_cordoalha * custo_cordoalha;%custos.longarinas.aco_protensao
orcamento.bainha = sum(quantitativo.bainhas.custo_por_comprimento.*quantitativo.bainhas.comprimento);
orcamento.concreto = quantitativo.volume_longarinas * (custo_interpolado(fck,[transpose([custos.concreto(:).fck]),transpose([custos.concreto(:).valor])]) + custos.longarinas.lancamento_concreto);
orcamento.ancoragens = ancoragens;
orcamento.manobra_lancamento = sum(quantitativo.manobra_lancamento.custo_por_un.*quantitativo.manobra_lancamento.un);


z = struct2cell(orcamento(:)); 
orcamento.TOTAL = sum(reshape([z{:}],size(z)));


end

function [orcamento, quantitativo] = orcar_lajes(viaduto, info, custos, mult_armadura)
% Orça as lajes

peso_aco_x = 0;
peso_aco_y = 0;
peso_trelicas = 0;
volume = 0;

for i = 1 : viaduto.n_apoios - 1
    hlj=viaduto.vao(i).laje.h;
    W = viaduto.W;
    cos_alfa = ((info.longarinas.vao(i).longarina(1).xe-info.longarinas.vao(i).longarina(1).xb)/info.longarinas.vao(i).longarina(1).lb);
    l = viaduto.vao(i).l/cos_alfa;
    fck = viaduto.vao(i).laje.fck / 1E6;
    espacamento_trelicas = info.lajes.vao(i).espacamento_trelicas;
    peso_por_metro_trelica = info.lajes.vao(i).trelica.peso_linear; % kg/m

    Asxm = info.lajes.vao(i).Asxm * 1E-4; % m²
    Asym = info.lajes.vao(i).Asym * 1E-4; % m²
    Asxe = info.lajes.vao(i).Asxe * 1E-4; % m²
    Asye = info.lajes.vao(i).Asye * 1E-4; % m²
    
    peso_trelicas = peso_trelicas + peso_por_metro_trelica * W * mult_armadura / espacamento_trelicas * l;
    peso_aco_x = peso_aco_x + ((Asxm + Asxe) * W * mult_armadura * l * 7850);
    peso_aco_y = peso_aco_y + ((Asym + Asye) * l * mult_armadura * W * 7850);

    volume = volume + l*W*hlj;



end

quantitativo.peso_trelicas = peso_trelicas;
quantitativo.peso_CA50 = peso_aco_x + peso_aco_y;
quantitativo.volume = volume;

orcamento.trelicas = quantitativo.peso_trelicas * custos.lajes.trelica;
orcamento.CA50 = quantitativo.peso_CA50 * custos.lajes.CA50;
orcamento.concreto = quantitativo.volume * (custo_interpolado(fck,[transpose([custos.concreto(:).fck]),transpose([custos.concreto(:).valor])]) + custos.lajes.lancamento_concreto);

z = struct2cell(orcamento(:)); 
orcamento.TOTAL = sum(reshape([z{:}],size(z)));
end

function [comprimento_cabos, comprimento_cordoalhas] = calc_comprimento_cabos(cabos,aa)
n_cabos = length(cabos);
n_disc = length(cabos(1).x);
n_trechos = n_disc - 1;
comprimento_cabos = 0;
comprimento_cordoalhas = 0;
for c = 1 : n_cabos
    n_cordoalhas = aa.ncord(c);
    for t = 1 : n_trechos
        dx = cabos(c).x(t+1) - cabos(c).x(t);
        dy = cabos(c).y(t+1) - cabos(c).y(t);
        comprimento = sqrt(dx^2 + dy^2);
        comprimento_cabos = comprimento_cabos + comprimento;
        comprimento_cordoalhas = comprimento_cordoalhas + comprimento*n_cordoalhas;
    end
end

end
