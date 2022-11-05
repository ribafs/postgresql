#!/bin/bash
# *********************************************************************
# Script diario do Banco de Dados PostgreSQL
# Procedimentos de vacuum e dump de todos os
# Bancos de Dados de um Servidor
# Sintaxe do comando:
# /PATH/bkpdbserver.sh
# *********************************************************************
# Constante do diretorio onde sera relizado o backup
Diretorio="/shared/pgsqlbkp/"
# *********************************************************************
# Constantes referente ao email
empresa="PontoBP";
email="paulo@dbexperts.com.br";
assunto="$empresa - Servidor Banco de Dados";
CorpoEmail="email.txt"
# *********************************************************************
# Constantes para definir o path dos executaveis
VACUUMDB="/usr/bin/vacuumdb"
PGDUMP="/usr/bin/pg_dump"
PGDUMPALL="/usr/bin/pg_dumpall"
USUARIODBA="postgres"
# *********************************************************************
# Constante para definir a string de data 
# do dia em que esta criando o backup
DiaSemana=`date +%u`
Hora=`date +%Hh-%Mmin`
case $DiaSemana in
       	1) DiaSemana="-segunda-"
       	;;
        2) DiaSemana="-terca-"
	;;
        3) DiaSemana="-quarta-"
        ;;
        4) DiaSemana="-quinta-"
        ;;
        5) DiaSemana="-sexta-"
        ;;
        6) DiaSemana="-sabado-"
        ;;
        7) DiaSemana="-domingo-"
        ;;
        *) DiaSemana="-indefinido-"
        ;;
esac
tempo=$DiaSemana$Hora
# *********************************************************************
# Constantes para definir o nome 
# completo dos arquivos de backup
nome="bkpservidordb"
DirArqSqlBkp=$Diretorio$nome$tempo-sql.bkp
DirArqSqlLog=$Diretorio$nome$tempo-sql.log
DirArqVacLog=$Diretorio$nome$tempo-vac.log
DirArqCmdLog=$Diretorio$nome$tempo-cmd.log
# *********************************************************************
# criando o corpo de email
# e registrando procedimentos iniciais
echo "Sistema de Vacuum e Backup do servidor PostgreSQL da empresa $empresa" > $Diretorio$CorpoEmail
echo "" >> email.txt
inicio=`date +%d/%m/%Y-%Hh%Mmin`
echo "***** Procedimento iniciado em "$inicio >> $Diretorio$CorpoEmail
# *********************************************************************
# executando comandos
# VACUUMDB e PGDUMP
$VACUUMDB -U $USUARIODBA -a -z -v 1>$DirArqCmdLog 2>$DirArqVacLog
$PGDUMPALL -U $USUARIODBA > $DirArqSqlBkp 2>$DirArqSqlLog
# *********************************************************************
# listando os arquivos gerados pelo script
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
echo "Arquivos gerados pelo script" >> $Diretorio$CorpoEmail
ls -lh $Diretorio$nome$tempo* >> $Diretorio$CorpoEmail
# *********************************************************************
# logando o espaco atual em disco
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
echo "Espaco atual de Unidades de Disco Rigido" >> $Diretorio$CorpoEmail
df -h >> $Diretorio$CorpoEmail
# *********************************************************************
# logando o tamanho atual do diretorio de banco de dados
pgdata="/usr/local/pgsql/data"
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
echo "Tamanho do diretorio : $pgdata" >> $Diretorio$CorpoEmail
du -sh $pgdata >> $Diretorio$CorpoEmail
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
# *********************************************************************
# listando as ultimas linhas do arquivo de log do banco
linhas=60
arquivolog="/var/log/pgsql/pgsql734.log"
echo "Ultimas $linhas linhas do arquivo $arquivolog : $pgdata" >> $Diretorio$CorpoEmail
tail -$linhas $arquivolog >> $Diretorio$CorpoEmail
# *********************************************************************
# logando o conteudo do arquivo de comandos do vacuum
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
echo "Conteudo do arquivo: $DirArqCmdLog" >> $Diretorio$CorpoEmail
cat $DirArqCmdLog >> $Diretorio$CorpoEmail
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
# *********************************************************************
# logando o log do vacuum
echo "Conteudo do arquivo: $DirArqVacLog" >> $Diretorio$CorpoEmail
cat $DirArqVacLog >> $Diretorio$CorpoEmail
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
# *********************************************************************
# adicionando o conteudo do arquivo de log do backup
echo "Conteudo do arquivo: $DirArqSqlLog" >> $Diretorio$CorpoEmail
cat $DirArqSqlLog >> $Diretorio$CorpoEmail
# *********************************************************************
# registrando fim do procedimento
echo "======================================================================================================================" >> $Diretorio$CorpoEmail
fim=`date +%d/%m/%Y-%Hh%Mmin`
echo "***** Procedimento finalizado em "$fim >> $Diretorio$CorpoEmail
mail -s "$assunto" $email < $Diretorio$CorpoEmail
#
# efetuando o upload dos arquivo
#
iniciais="*$tempo*";
cd /shared/pgsqlbkp
smbclient \\\\192.168.10.4\\pgsqlbkp dbxpgsql -U pgsqlbkp -c "prompt off;mput $iniciais"
