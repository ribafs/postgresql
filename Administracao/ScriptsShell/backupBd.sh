#!/bin/sh
# backupBd.sh - Efetua backup do banco de dados MySQL ou PostgreSQL.
#
# Homepage   : http://neto.gsibr.com/scripts
# Autor      : José Morelli Neto <neto@univali.br>
#
# ----------------------------------------------------------------------------
#  Este programa permite executar o backup gerando um arquivo gzip com o DUMP
#  total de todas os bancos de dados, ou um gzip individual para cada banco
#  de dados. Também é possível manter um histórico das últimas n execuções
#
#  Atualmente são suportados os softwares MySQL e PostgreSQL
#
#  Para configurar, basta ajustar as variáveis abaixo conforme suas neces-
#  sidades.
# ----------------------------------------------------------------------------
#
# Histórico:
#
#   v1.1 2006-03-03, José Morelli Neto:
#       - Adicionado suporte a geração de backups do PostgreSQL
#       - Alterado as varíaves removendo o path absoluto e usando o which
#	  (Obrigado Luis Fernando Kieça!)
#	- Adicionado suporte ao envio de e-mail com o log do backup
#
#   v1.0 2005-11-29, José Morelli Neto:
#      - Versão inicial
#
#
# Licenciamento: Este programa é GPL.
# ----------------------------------------------------------------------------

# Informações para acesso ao MySQL
User=postgres
Password=_SENHA_

# Diretório que será armazenado o backup
dirBackup=/var/backups/pgsql

# Fazer backup de qual banco de dados (Pgsql, Mysql ou Pgsql|Mysql)
doDataBaseProgram='Pgsql'

# Arquivo de Log
logFile=/var/log/backup.log

# Permitir histórico de versões (caso N o arquivo será sobrescrito cada vez que
# for realizado o backup) (Y=sim; N=não)
history=N

# Número máximo de versões a ser armazenado
numVersions=3

# Backup de todos os BDs em um único arquivo, ou gerar um arquivo para cada BD?
# (Y=sim; N=não)
allBDinOneFile=N

# BDs que não serão copiados do MySQL. Para adicionar mais de um BD, separe-os 
# por pipe (e.g. 'bd1|bd2|bd3')
noBackupOfMysql='test'

# BDs que não serão copiados do PostgreSQL. Para adicionar mais de um BD, 
# separe-os por pipe (e.g. 'bd1|bd2|bd3')
noBackupOfPgsql='test|template0'

# Texto que iniciar o nome do arquivo (antes do nome do BD)
filePrefix=backup

# Exibi mensagens de Debug na saída padrão (1=sim; 0=não)
Debug=0

# E-mail do administrador responsável pelo backup
MailTo=SEU_EMAIL@SEU.DOMINIO

# Assunto da mensagen
MailSubject="Backup $doDataBaseProgram do servidor $HOSTNAME"

# Binários utilizados (não é necessário alterar caso a instalação seja padrão)

# PostgreSQL
_pgsqldumpall=$(which pg_dumpall)
_pgsqldump=$(which pg_dump)
_psql=$(which psql)

# MySQL
_mysqldump=$(which mysqldump)
_mysql=$(which mysql)
_gzip=$(which gzip)
_ls=$(which ls)
_head=$(which head)
_wc=$(which wc)
_tr=$(which tr)
_sendmail=$(which sendmail)
# ----------------------------------------------------------------------------
linhas=0
# Função de Logs
function doLog() {
	let linhas++
        echo "[$(date '+%d-%m-%y %H:%M:%S')] $*" >> $logFile
        Debug "LOG> $*"
}

# Função para geração de Debugs
function Debug() {
        [ "$Debug" = 1 ] && echo "$*" ;
}

# Função para envio de e-mail com informações do Backup
function sendMail() {
	$_sendmail $MailTo <<EOM
From: root@$HOSTNAME
To: $MailTo
Subject: $MailSubject

$(tail -$linhas $logFile)
EOM
}

# Funcao responsavel por efetua backup de DUMP total do PostgreSQL
function doPgsqlDumpinOneFile() {
	doLog "Iniciando backup do PostgreSQL [Dump total]"
	$_pgsqldumpall --username=$User --oids | $_gzip >\
	$dirBackup/$filePrefix-pgsql${Date:-$Date}.gz

	doLog "Backup concluído."
	Debug "Retornando valor: $ret"
	return $ret
}

# Função responsável por efetuar backup de DUMP por Database do PostgreSQL
function doPgsqlDumpPerDB() {

        doLog "Iniciando backup do PostgreSQL [Dump por BD]"

	for db in $($_psql --username=$User -l -t -A | cut -d\| -f1 | egrep -v $noBackupOfPgsql); do

		doLog "Efetuando backup do DB: $db"
		$_pgsqldump --username=$User --oids $db | $_gzip > $dirBackup/$filePrefix-pgsql-$db${Date:-$Date}.gz

	done
	doLog "Backup concluído."
	Debug "Retornando valor: $ret"
	return $ret
}


# Funcao responsavel por efetua backup de DUMP total do MySQL 
function doMysqlDumpinOneFile() {

        doLog "Iniciando backup do MySQL [Dump total]"

        $_mysqldump --all --all-databases --quick --user=$User\
        --password=$Password | $_gzip >\
        $dirBackup/$filePrefix-mysql${Date:-$Date}.gz

	doLog "Backup concluído."
        Debug "Retornando valor: $ret"
        return $ret
}

# Limpa os arquivos anteriores ao número máxio de versões (para backups de
# apenas um arquivo .gz) do PostgreSQL
function doCleaningOfPgsql() {
        while [ "$($_ls -1 $dirBackup/$filePrefix-pgsql*|$_wc -l|$_tr -d ' ')" -gt\
	"$numVersions" ]; do

_file=$($_ls -1 $dirBackup/$filePrefix-pgsql* -r --sort=time\
| $_head -1)

doLog "Removendo arquivo antigo: $_file"
rm -f  $_file
done
}

# Limpa os arquivos anteriores ao número máximo de versões (para backups de
# um arquivo .gz para cada BD) do PostgreSQL
function doCleaningPerDBOfPgsql() {
	# pega o número de databases que serao copiados
	_totDB=$($_psql --username=$User -l -t -A | cut -d\| -f1\
	| egrep -v $noBackupOfPgsql | $_wc -l | $_tr -d ' ')

	# remove arquivos anteriores ao numero de retencao
	while [ "$($_ls -1 $dirBackup/$filePrefix-pgsql-[a-zA-Z]* | $_wc -l\
	| $_tr -d ' ')" -gt "$((numVersions*_totDB))" ]; do

		_file=$($_ls $dirBackup/$filePrefix-pgsql-[a-zA-Z]* -r --sort=time\
		| $_head -$_totDB)

		doLog "Removendo arquivo antigo: $_file"
		rm -f $_file
	done
}


# Função responsável por efetuar backup de DUMP por Database do MySQL
function doMysqlDumpPerDB() {

        doLog "Iniciando backup do MySQL [Dump por BD]"

        for db in $($_mysql -u$User -p$Password -B -s -e 'show databases;'\
        | egrep -v $noBackupOfMysql); do

                doLog "Efetuando backup do DB: $db"
                $_mysqldump --all --quick --user=$User --password=$Password\
                $db | $_gzip > $dirBackup/$filePrefix-mysql-$db${Date:-$Date}.gz

        done
        doLog "Backup concluído."
        Debug "Retornando valor: $ret"
        return $ret
}

# Limpa os arquivos anteriores ao número máxio de versões (para backups de
# apenas um arquivo .gz) do MySQL
function doCleaningOfMysql() {
        while [ "$($_ls -1 $dirBackup/$filePrefix-mysql*|$_wc -l|$_tr -d ' ')" -gt\
         "$numVersions" ]; do

                _file=$($_ls -1 $dirBackup/$filePrefix-mysql* -r --sort=time\
                | $_head -1)

                doLog "Removendo arquivo antigo: $_file"
                rm -f  $_file
        done
}

# Limpa os arquivos anteriores ao número máximo de versões (para backups de
# um arquivo .gz para cada BD) do MySQL
function doCleaningPerDBOfMysql() {
        # pega o número de databases que serao copiados
        _totDB=$($_mysql -u$User -p$Password -B -s -e 'show databases;'\
        | egrep -v $noBackupOfMysql | $_wc -l | $_tr -d ' ')

        # remove arquivos anteriores ao numero de retencao
        while [ "$($_ls -1 $dirBackup/$filePrefix-mysql-[a-zA-Z]* | $_wc -l\
        | $_tr -d ' ')" -gt "$((numVersions*_totDB))" ]; do

                _file=$($_ls $dirBackup/$filePrefix-mysql-[a-zA-Z]* -r --sort=time\
                | $_head -$_totDB)

                doLog "Removendo arquivo antigo: $_file"
                rm -f $_file
        done
}

# Funcao principal -----------------------------------------------------------

Debug "Permitir histórico de backup: $history"
doLog "-[ Início do backup ]---------------------------------"
# Backup em arquivo único ou efetuar a rotação
if [ "$history" = "N" ]; then
        Debug "Dump de todos os BDs em um .gz: $allBDinOneFile"
        if [ "$allBDinOneFile" = "Y" ]; then
	     	for dbp in $(echo $doDataBaseProgram | sed 's/|/\n/g'); do
			doLog "Efetuando backup do sistema: $dbp"
			Debug "Nome da função a ser chamada: do"$dbp"DumpinOneFile()"
			"do"$dbp"DumpinOneFile"
		done
        else
	     	for dbp in $(echo $doDataBaseProgram | sed 's/|/\n/g'); do
			Debug "Nome da função a ser chamada: do"$dbp"DumpPerDB()"
			"do"$dbp"DumpPerDB"
		done
        fi

else
        # Data que será utilizada no arquivo
	Date=-$(date +%y%m%d-%H%M)

        Debug "data que será utilizada no arquivo: $Date"
        Debug "Dump de todos os BDs em um .gz: $allBDinOneFile"

	if [ "$allBDinOneFile" = "Y" ]; then
	     	for dbp in $(echo $doDataBaseProgram | sed 's/|/\n/g'); do
			Debug "Nome da função a ser chamada: doCleaningOf"$dbp
			"doCleaningOf"$dbp
			doLog "Efetuando backup do sistema: $dbp"
			Debug "Nome da função a ser chamada: do"$dbp"DumpinOneFile()"
			"do"$dbp"DumpinOneFile"
		done
        else
	     	for dbp in $(echo $doDataBaseProgram | sed 's/|/\n/g'); do
			Debug "Nome da função a ser chamada: doCleaningPerDBOf"$dbp
			"doCleaningPerDBOf"$dbp
			Debug "Nome da função a ser chamada: do"$dbp"DumpPerDB()"
			"do"$dbp"DumpPerDB"
		done
        fi
fi

# Envia e-mail sobre estado do backup
doLog "Enviando e-mail para $MailTo"
sendMail
