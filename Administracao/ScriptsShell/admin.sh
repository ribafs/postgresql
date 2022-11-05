#!/bin/bash
#
# Criado/adaptado por Ribamar FS - http://ribafs.org
#
#apt-get install dialog;
#
menu="DNOCS"
while :
 do
    clear
	servico=$(dialog --stdout --backtitle 'Equipe de TI do DNOCS - Administração dos Servidores' \
        --menu "$menu" 12 65 0 \
        1 'Backup de um banco mysql' \
		2 'Backup de um banco PostgreSQL' \
		3 'Backup dos arquivos do site do DNOCS (arquivos)' \
		4 'Backup dos arquivos de um aplicativo' \
	    0 'Sair' )
    case $servico in
	1) clear;
		# Backup de banco de dados mysql
		DIALOG=${DIALOG=dialog}
		tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
		trap "rm -f $tempfile" 0 1 2 5 20

		$DIALOG --title "Nome do banco de dados em MySQL" --clear \
	        --inputbox "Digite o nome do banco de dados\n
Lembre que sempre o backup do banco será criado em /var/www/backup\n\n
Digite abaixo o nome do banco\n\nE Aguarde o backup ..." 14 80 2> $tempfile

		retval=$?
		BD=`cat $tempfile`;
		DATA=`/bin/date +%Y-%m-%d`;
		BACK="/var/www/html/backup/my";
		case $retval in
		0)
    		mysqldump -uroot -pmysql $BD > "$BACK/$BD$DATA.sql";
    		echo "O backup foi criado em:/var/www/html/backup/$BD$DATA.sql";
    		echo "Acesse pleo navegador em http://localhost/backup/$BD$DATA.sql\nTecle enter para continuar"
    		read n;;
		1)
			echo "Cancelado.";;
		esac;;
	2) clear;
		# Backup de banco de dados PostgreSQL
		dialog \
				--title 'Backup de banco PostgreSQL' \
				--msgbox 'Entre banco, esquema e tabela a seguir. \nObserve que somente o banco é obrigatório' \
				6 80
	    echo "Digite o nome do banco de dados abaixo e tecle Enter\n\n";
		read BD;	

	    echo "Digite o nome do [esquema] abaixo e tecle Enter\n\n";
		read ESQ;

	    echo "Digite o nome da [tabela] abaixo e tecle Enter.\n\n";
		read TB;

   		pgback.sh $BD $ESQ $TB;
		echo "Backup concluído. Confira com http://localhost/backup/pg\nTecle enter";
   		read n;;
	3) clear;
		# Backup de arquivos do site
		dialog \
				--title 'Backup de arquivos do site do DNOCS' \
				--msgbox 'Digite o diretório abaixo' \
				6 80
		DIALOG=${DIALOG=dialog}
		tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
		trap "rm -f $tempfile" 0 1 2 5 20

		DATA=`/bin/date +%Y-%m-%d`;

		$DIALOG --title "Diretório do site" --clear \
	        --inputbox "O diretório default é /var/www/html\n" 14 80 2> $tempfile
		retval=$?
		diretorio=`cat $tempfile`

		BACK="/var/www/html/backup";
		case $retval in
		0)
			tar czpvf "$BACK/site-$DATA.tar.gz" $diretorio;
			clear;
			echo "Backup concluído.\n\nConfira em http://localhost/backup\n\nAperte qualquer tecla";
			read n;;
		1)
			echo "Cancelado.";
		esac;;
	4) clear;
		# Backup de arquivos de aplicativo
		dialog \
				--title 'Backup de arquivos de um aplicativo' \
				--msgbox 'Digite o diretório abaixo' \
				6 80
		DIALOG=${DIALOG=dialog}
		tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
		trap "rm -f $tempfile" 0 1 2 5 20

		DATA=`/bin/date +%Y-%m-%d`;
		BACK="/var/www/html/backup/";

		$DIALOG --title "Diretório do aplicativo" --clear \
	        --inputbox "Digite o diretório completo relativo ao /var/www/html\n
	        Exemplo: se em /var/www/html/app1 basta digitar app1\n" 14 80 2> $tempfile
		retval=$?
		diretorio=`cat $tempfile`
		case $retval in
		0)
			tar czpvf "$BACK/$diretorio-$DATA.tar.gz" "/var/www/html/$diretorio";
			clear;
			echo "Backup concluído.\n\nConfira em http://localhost/backup\n\nAperte qualquer tecla";
			read n;;
		1)
			echo "Cancelado.";
		esac;;	
    0) clear;
    exit;;
   esac
done
