#!/bin/bash
#SBATCH -J trab-01                # Nome do trabalho.
#SBATCH -o %j.out                 # Nome do arquivo de saida padrão (%j é subistituido pelo jobId).
#SBATCH -N 1                      # Número de maquinas utilizadas simultaneamentes. Só funciona com 1.
#SBATCH -n 40                     # Número de núcleos utilizados por este trabalho. Verificar o número de núcleos disponíveis nas maquinas.
#SBATCH -t 160:00:00              # Tempo de processamento (hh:mm:ss) - 160.0 horas
#SBATCH --mem-per-cpu=2G          # Quantidade de memória solicitada. "--mem-per-cpu=2G" significa 2 GB por núcleo. Este valor foi testando e aparentemente não precisa ser alterado.


pasta_trabalho=trabalho_1                           # Nome da pasta que contem o problema e os arquivos de configuração. 
service=cloud                                       # Nome do perfil remoto no rclone.
sing=optimusviaduto.simg                            # Define o arquivo de imagem a ser copiado.
remote_out_in="cluster/${pasta_trabalho}"           # Pasta no serviço remoto para output e input
remote_sing=cluster                                 # Pasta no serviço remoto para o container



# Recomendado que apenas usuários avançados alterem este arquivo a partir desta linha.  
local_sing=.                                        # Pasta local para o container singularity
local_job="/tmp/job_${SLURM_JOB_ID}"                # Pasta temporária local
arquivo_saida=saida_MOPSO.mat                       # Nome do arquivo de output. Não alterar.


MCR_CACHE_ROOT="${local_job}"                       # Define a pasta para cache do RUNTIME do MATLAB.
export MCR_CACHE_ROOT                               # Exporta a variável de ambiente. O MATLAB utiliza esta pasta para escrita e leitura durante a execução do programa.

function clean_job() {
  echo "Backup antes de apagar porque a execução foi interrompida inesperadamente..."
  rclone move "${SLURM_JOB_ID}.out" "${service}:${remote_out_in}/saida_${SLURM_JOB_ID}/"  --transfers "${SLURM_CPUS_ON_NODE}"
  rclone move "${local_job}/${arquivo_saida}" "${service}:${remote_out_in}/saida_${SLURM_JOB_ID}/" --transfers "${SLURM_CPUS_ON_NODE}"
  echo "Limpando ambiente..."
  rm -rf "${local_job}"
 
}
trap clean_job EXIT HUP INT TERM ERR

set -eE

umask 077

echo "Criando pastas temporárias..."
mkdir -p "${local_job}"

echo "Copiando container..."
rclone copyto "${service}:${remote_sing}/${sing}" "${local_sing}/optimusviaduto.simg"  --transfers "${SLURM_CPUS_ON_NODE}"

echo "Copiando arquivos de input..."
rclone copy "${service}:${remote_out_in}/" "${local_job}/"  --transfers "${SLURM_CPUS_ON_NODE}"



echo "Executando..."
singularity run \
     --bind=/scratch:/scratch \
     --bind=/var/spool/slurm:/var/spool/slurm \
     optimusviaduto.simg

echo "Enviando output..."

rclone move "${SLURM_JOB_ID}.out" "${service}:${remote_out_in}/saida_${SLURM_JOB_ID}/"  --transfers "${SLURM_CPUS_ON_NODE}"
rclone move "${local_job}/${arquivo_saida}" "${service}:${remote_out_in}/saida_${SLURM_JOB_ID}/" --transfers "${SLURM_CPUS_ON_NODE}"
rm -rf "${local_job}"

