#!/bin/sh
#/usr/local/bin/pgback.sh

# Adaptado de - http://www.sertoriopen.com.br/?p=55

# Documentação: https://www.postgresql.org/docs/9.6/static/app-pgdump.html
# Uso: pgback.sh nomebanco nomeesquema

if [ "$1" = "-h" ] || [ "$1" = "--help"  ] || [ -z "$1" ]
    then
    echo "Sintaxe correta:\n\npgback.sh banco [esquema] [tabela]"
    exit 1
fi

DATA=`/bin/date +%d-%m-%Y`

# diretório de backup
DIR="/backup/pg_backup/"

if [ ! -d "$DIR" ]
    then
    mkdir -p "$DIR"
fi

ARQUIVO="$DIR$1-$2-$DATA.sql"
#echo $ARQUIVO;

# variáveis
HOST="localhost"
USER="postgres"
export PGPASSWORD="postgres"
 
# backup
# --no-owner = sem owner, --inserts = com inserts, -Fp = customizado com plain text, 
# Customizado permite restore de apenas uma tabela, ou um esquema
# $1 - nome do banco, $2 - nome do esquema, -t = tabela

if [ ! -z $3 ]
then
    /usr/bin/psql -U $USER -c "alter user postgres set search_path to "$2
    /usr/bin/pg_dump -h $HOST -U $USER -n $2 -t $3 --no-owner --inserts -Fp $1 -f $ARQUIVO
    gzip -9 $ARQUIVO
    exit 1
elif [ ! -z $2 ]
then
    /usr/bin/psql -U $USER -c "alter user postgres set search_path to "$2
    /usr/bin/pg_dump -h $HOST -U $USER -n $2 --no-owner --inserts -Fp $1 -f $ARQUIVO
    gzip -9 $ARQUIVO
    exit 1
else
    /usr/bin/pg_dump -h $HOST -U $USER --no-owner --inserts -Fp $1 -f $ARQUIVO
    gzip -9 $ARQUIVO
fi
