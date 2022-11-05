#---------------------------------------------------------------------------#
#	Membro ................. backupPostgreSQL.sh			    #
#       Autor ...................Paulo Roberto Leite Nunes                  #
#				 Luiz Gonzaga da Mata                       #
#	Local .................. SMED - PRODABEL - BELO HORIZONTE	    #
#	Data ................... 16 de Junho de 2004                        # 
#       Dt.Ut.Md.................17 de Junho de 2004                        #
#	Funcao ................. Backup do Banco de Dados PostgreSQL	    #
#	Etapas                  1) Verifica se o Postmaster esta disponível #
#				2) Executa um vacuumdb full analize	    #
#				3) Executa o pg_dumpall			    #
#				4) Comprime o arquivo Backup em formato tar #
#				5) Faz Login automático no servidor FTP     #
#				6) Envia o arquivo no formato tar	    #
#				7) Grava log da execução		    #
#				8) Envia email em caso de falhas e sucesso. #
#				   Para enviar o email, o Postfix deve ser  #
#				   Configurado --> arquivo main.cf          #
#---------------------------------------------------------------------------#

# ATRIBUICAO DAS VARIAVEIS DE AMBIENTE DO UTILITÁRIO

HOSTNAME=servidor				# HOSTNAME do Servidor PostgreSQL
Dia=`date '+%Y%m%d%H%M'`        		# Data e hora de execução
MsgLog=/dados/backup/$HOSTNAME.$Dia.log  	# Arquivo de log da execução
TarFile=/dados/backup/$HOSTNAME.$Dia.tar 	# Arquivo final do Backup
Correio="xxxxxx@yyyyyy.zzz"	    		# E-mail para notificação de falhas
PATHBACKUP=/dados/backup			# Diretorio local de destino do Backup
PATHBACKUPFTP=/dados/backup/$HOSTNAME           # Diretorio de destino do Backup no servidor FTP
FTPHOSTNAME=servidor				# Servidor de FTP para transferencia
FTPUSUARIO=postgreSQL				# Nome do usuário FTP
FTPSENHA=xxxxxx					# Senha do usuario FTP

#*********************************************************************
#******     Apaga Arquivo do dia anterior no servidor Local  *********
#*********************************************************************


cd $PATHBACKUP
if [ -s *.tar ]; then
	rm -f *.tar
	rm -f *.sql
fi

date >$MsgLog

# Verifica se o PostgreSQL esta disponivel

if [ `ps -ef|grep postmaster|grep -v grep|wc -l` -eq 0 ]
then
   mail -s $HOSTNAME" - Banco de dados fora do ar" $Correio <<EOF

   $HOSTNAME - data e hora = $Dia
EOF
echo "**********BANCO DE DADOS FORA DO AR" >>$MsgLog
exit
fi

echo "**********ARQUIVO DE LOG DO BACKUP DA SERVIDORA $HOSTNAME" >>$MsgLog
date >$MsgLog
echo "*******************************************" >>$MsgLog
echo "********** INICIO DE PG_DUMPALL   *********" >>$MsgLog
echo "*******************************************" >>$MsgLog

su - postgres -c vacuumdb full analize
su - postgres -c pg_dumpall > /dados/backup/backup-$HOSTNAME-$Dia.sql

if [ $? != 0 ]
 then

  mail -s $HOSTNAME" - Erro no pg_dump" $Correio <<EOF 
   Ocorreu um erro no backup com o comando pg_dump
   $HOSTNAME - Data e hora = $Dia
EOF
exit
fi

echo "*************************************************" >>$MsgLog
echo "************ FIM DO BACKUP - $HOSTNAME ************" >>$MsgLog
echo "*************************************************" >>$MsgLog
date >>$MsgLog

echo "************************************************" >>$MsgLog
echo "********** Compactacao do Arquivo .sql *********" >>$MsgLog
echo "************************************************" >>$MsgLog

tar cvfz $TarFile $PATHBACKUP/backup-$HOSTNAME-$Dia.sql >>$MsgLog 2>>$MsgLog

if [ $? != 0 ]
then
	if [ `cat $MsgLog|grep "file changed as we read it"|wc -l`   -ne 1 ]
	   then
	   mail -s $HOSTNAME" - Erro no comando tar" $Correio <<FIM
	   Ocorreu um erro no backup para disco - Comando tar
	   $HOSTNAME - $Dia
FIM
	exit
	fi
fi

date >>$MsgLog

echo "************************************************" >>$MsgLog
echo "********* FIM DA COMPACTACAO - $HOSTNAME ********" >>$MsgLog
echo "************************************************" >>$MsgLog
date >>$MsgLog

echo "*****************************************************" >>$MsgLog
echo "**** Transfere arquivo compactado p/ $FTP-HOSTNAME *******" >>$MsgLog
echo "*****************************************************" >>$MsgLog
date >>$MsgLog
#/bin/sh
cd $PATHBACKUP
ftp -in <<EOF
open $FTPHOSTNAME
user $FTPUSUARIO $FTPSENHA
cd $PATHBACKUPFTP
put *.tar
bye
cd $PATHBACKUP
EOF
echo "*****************************************************" >>$MsgLog
echo "*************   FIM DA TRANSFERENCIA   **************" >>$MsgLog
echo "*****************************************************" >>$MsgLog
date >>$MsgLog
mail -s $HOSTNAME" - Backup executado com sucesso!!!!" $Correio <<FIM
           Backup executado com sucesso!!! 
           $HOSTNAME - $Dia
FIM

