# Emiliano
# C 2005 04 20
# R 2005 08 12 [Adaptado par ao viva o linux]
# Script para DUMP de bases PostGreSQL.
# Sintaxe: pgbackup.sh [Nome da base]
#
# CONSTANTES ##################
vU="postgres"                 # Usuario no PostGreSQL
vP="naoenecessario"           # Senha
vPPG="/usr/local/pgsql"       # PREFIX do PostGreSQL
vBI="$vPPG/bin"               # PREFIX do PostGreSQL
vDump="$vBI/pg_dump"          # Binario de dump
vR="/BackupSuporte"           # Diretorio raiz do Backup
vD="/BasesDeDados"            # Destino do Backup
vPre="basePGSQL"              # Prefixo no nome do arquivo de saida
vE=".dmp"                     # extencao do arquivo de saida
vH="localhost"                # Maquina onde está a base
vF="p"                        # Formato do dump
# VARIAVEIS ###################
vB=$1                         # Base De dados
vAno=`date +%Y`
vMes=`date +%m`
vDia=`date +%d`
vHor=`date +%H`
vMin=`date +%M`
vCod=`date +%S`               # pode ser utilizado o +%N em versões mais novas do date
vDat="$vAno$vMes$vDia-$vHor$vMin-$vCod"
vA="$vPre-$vB-$vDat$vE"
# TESTES ######################
if [ -d $vR$vD ]; then
    echo "diretorio ok";
else
    echo "criando diretorio de backup..."
    mkdir -p $vR$vD
fi
if [ -z $vB ]; then
        echo "erro de sintaxe";
        echo "use: pgbackup.sh [Nome da base]";
        exit 0;
else
        echo "BASE: $vB";
fi
# BACKUP #####################
echo "Arquivo Gerado: $vR$vD/$vA"
$vDump -U $vU -h $vH --format=$vF --file=$vR$vD/$vA $vB