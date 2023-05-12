fprintf('É necessário abrir o docker antes de executar este script!\n')


addpath('Análise Estrutural');
addpath('Desenhos');
addpath('Gerador de Modelo Estrutural');
addpath('Solicitações');
addpath('Dimensionamento');
addpath('Funções Objetivo');
addpath('Otimizacao');
addpath('Otimizacao/MOPSO');
addpath('Otimizacao/NSGAII');
addpath('Otimizacao/SPEA2');
addpath('Interface');
addpath('Res');

oldpwd = pwd;

res = compiler.build.standaloneApplication('otimizacao_viaduto_MOPSO.m')

opts = compiler.package.DockerOptions(res,'ImageName','optimusviaduto');
opts.AdditionalInstructions{1} = 'RUN apt update && apt -y install locales && locale-gen pt_BR.UTF-8'; 
opts.AdditionalInstructions{2} = 'ENV LANG pt_BR.UTF-8'; 
opts.AdditionalInstructions{3} = 'ENV LANGUAGE pt_BR:pt:en'; 
opts.AdditionalInstructions{4} = 'ENV LC_ALL pt_BR.UTF-8'; 

compiler.package.docker(res, 'Options', opts)

cd('./optimusviadutodocker')
system('docker save optimusviaduto -o optimusviaduto.tar','-echo')

system('singularity build optimusviaduto.simg docker-archive://optimusviaduto.tar','-echo')

cd(oldpwd)

%fprintf('Abrir um terminal na pasta /optimusviadutodocker e executar os seguintes comandos no terminal\n')
%fprintf('$ docker save optimusviaduto -o optimusviaduto.tar\n')
%fprintf('$ singularity build optimusviaduto.simg docker-archive://optimusviaduto.tar\n')

