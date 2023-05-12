function [parametros_gerador_modelo, parametros_gerador_modelo_relativo, viaduto_padrao, custos, emissoes, coeficientes_VUP, greide, impedido, terreno, parametros_MOPSO] = ler_input_arquivos(mcrdir)
%config_gerador_modelo
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'Gerador de modelo.xml']); fprintf('\n');
type([mcrdir 'Gerador de modelo.xml'])
parametros_gerador_modelo = readstruct([mcrdir 'Gerador de modelo.xml']);

%config_gerador_modelo_relativo
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'População inicial.xml']); fprintf('\n');
type([mcrdir 'População inicial.xml'])
parametros_gerador_modelo_relativo = readstruct([mcrdir 'População inicial.xml']);


%config_padrao_viaduto
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'Configurações gerais.xml']); fprintf('\n');
viaduto_padrao = readstruct([mcrdir 'Configurações gerais.xml']);
disp(struct2table(viaduto_padrao));
disp(struct2table(viaduto_padrao.fundacao));
disp(struct2table(viaduto_padrao.pilares));
disp(struct2table(viaduto_padrao.travessas));
disp(struct2table(viaduto_padrao.longarinas));
disp(struct2table(viaduto_padrao.lajes));
disp(struct2table(viaduto_padrao.fustes));
disp(struct2table(viaduto_padrao.pap));


%config_custos
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'Custos dos serviços.xml']); fprintf('\n');
custos = readstruct([mcrdir 'Custos dos serviços.xml']);
disp(struct2table(custos));
disp(struct2table(custos.concreto));
disp(struct2table(custos.tubuloes));
disp(struct2table(custos.blocos));
disp(struct2table(custos.pilares));
disp(struct2table(custos.travessas));
disp(struct2table(custos.longarinas));
disp(struct2table(custos.longarinas.manobra_lancamento));
disp(struct2table(custos.longarinas.bainha));
disp(struct2table(custos.longarinas.ancoragens_127));
disp(struct2table(custos.longarinas.ancoragens_152));
disp(struct2table(custos.lajes));

%config_emissoes
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'Impacto ambiental.xml']); fprintf('\n');
emissoes = readstruct([mcrdir 'Impacto ambiental.xml']);
disp(struct2table(emissoes));
disp(struct2table(emissoes.concreto));
disp(struct2table(emissoes.tubuloes));
disp(struct2table(emissoes.blocos));
disp(struct2table(emissoes.pilares));
disp(struct2table(emissoes.travessas));
disp(struct2table(emissoes.longarinas));
disp(struct2table(emissoes.longarinas.bainha));
disp(struct2table(emissoes.longarinas.ancoragens_127));
disp(struct2table(emissoes.longarinas.ancoragens_152));
disp(struct2table(emissoes.lajes));


%config_coeficientes_VUP
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'Vida útil.xml']); fprintf('\n');
coeficientes_VUP = readstruct([mcrdir 'Vida útil.xml']);
disp(struct2table(coeficientes_VUP));
disp(struct2table(coeficientes_VUP.dados_cimento));
disp(struct2table(coeficientes_VUP.ad_concreto));


%% Terreno
%terreno_exemplo_simetrico
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'Problema.xml']); fprintf('\n');
problema = readstruct([mcrdir 'Problema.xml']);
greide = problema.greide;
impedido = problema.impedido;
terreno = problema.terreno;
disp(struct2table(greide));
disp(struct2table(impedido));
disp(struct2table(terreno));

%% Opções MOPSO
fprintf('%s%d',[datestr(now,'HH:MM:SS') ': Lendo  parâmetros do arquivo: ' mcrdir 'Parametros do MOPSO.xml']); fprintf('\n');

parametros_MOPSO = readstruct([mcrdir 'Parametros do MOPSO.xml']);
disp(struct2table(parametros_MOPSO));
end