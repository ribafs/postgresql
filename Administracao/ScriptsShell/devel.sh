#!/bin/bash
#
# Criado/adaptado por Ribamar FS - http://ribafs.org
#
#apt-get install dialog;
#
menu="Menu Principal\n\nUse as setas do teclado ou o mouse para selecionar uma opção\nEntão tecle Enter ou clique em OK"
while :
 do
    clear
	servico=$(dialog --stdout --backtitle 'Equipe de TI do DNOCS - Ambiente de Desenvolvimento' \
        --menu "$menu" 12 65 0 \
    1 'Criar Aplicativo para a Intranet' \
	2 'Gerar CRUG com o Bake' \
	3 'Atualizar Aplicativo com o Composer' \
	4 'Saber versão do Cake de um Aplicativo' \
	5 'Corrigir erro de permissão em aplicativo' \
    0 'Sair' )
    case $servico in
	1) clear;
		DIALOG=${DIALOG=dialog}
		tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
		trap "rm -f $tempfile" 0 1 2 5 20

		$DIALOG --title "Diretório do Aplicativo" --clear \
	        --inputbox "Digite o diretório onde será criado o aplicativo\n
Lembre que seu diretório atual é o /var/www/html\n\n
Por exemplo, para criar o aplicativo cake3-dnocs em /var/www/html/modelos/\n
Solte o mouse e digite abaixo: modelos/cake3-dnocs \n\nE Aguarde a criação ..." 14 80 2> $tempfile

		retval=$?
		dir1=`cat $tempfile`
		case $retval in
		0)
    			comp "/var/www/html/$dir1";
			dialog                                            \
			--title 'Acesse pelo NetBeans ou pelo navegador em:'                             \
			--msgbox "http://10.0.0.4/$dir1
\n\nClique com o botão direito sobre o link acima\n
e então em Abrir link.\n"  \
			10 80;;
		1)
			echo "Cancelado.";;
		esac;;
	2) clear;
		# ritetório do aplicativo
		DIALOG=${DIALOG=dialog}
		tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
		trap "rm -f $tempfile" 0 1 2 5 20

		$DIALOG --title "Gerar CRUD" --clear \
	        --inputbox "Digite o diretório do aplicativo\n
Lembre que seu diretório atual é o /var/www/html\n\n
Digite o diretório \n\nE Aguarde a criação ..." 14 80 2> $tempfile
		retval=$?
		diretorio=`cat $tempfile`

		# tabela para gerar o crud
		DIALOG=${DIALOG=dialog}
		tempfile2=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
		trap "rm -f $tempfile2" 0 1 2 5 20

		$DIALOG --title "Gerar CRUD" --clear \
	        --inputbox "Digite o nome da tabela\n" 14 80 2> $tempfile2

		retval=$?
		tabela=`cat $tempfile2`

		case $retval in
		0)
			cd $diretorio
    		bin/cake bake all $tabela;
			dialog                                            \
			--title 'Gerar CRUD'                             \
			--msgbox "Código Gerado. Confira abrido no navegador\n"  \
			10 80;;
		1)
			echo "Cancelado.";;
		255)
		esac;;

	3) clear;
		DIALOG=${DIALOG=dialog}
		tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
		trap "rm -f $tempfile" 0 1 2 5 20

		$DIALOG --title "Atualização de Aplicativo com o Composer" --clear \
	        --inputbox "Digite o diretório do aplicativo\n
Lembre que seu diretório atual é o /var/www/html\n\n
Digite e Aguarde a atualização ..." 14 80;;
	4) clear;
		echo "== Diretório do Aplicativo ==";
		echo "";
		echo "Digite o diretório do aplicativo e aperte qualquer tecla para continuar";
		echo "Somente a partir de '/var/www/html'.";
		echo "Exemplo: para '/var/www/html/teste', digite apenas 'teste' e tecle Enter.";
		echo "";
		echo "";
		read DIR
		/var/www/html/$DIR/bin/cake;
		echo "Veja a versão acima em 'Welcome to CakePHP v'. Aperte qualquer tecla para votlar."
		read n;;
	5) clear;
		# Antes adicionar todos os desenvolvedores ao sudo sem senha
		echo '== Corrigir erro de permissão em aplicativo ==';
		echo '';
		echo 'Digite o diretório do aplicativo. Lembre que é relativo.';
		echo "Para '/var/www/html/modelos/aplicativo1', digite apenas 'modelos/aplicativo1' e tecle Enter.";
		echo '';
		echo '';				
		read APP;
		sudo perms $APP;
		echo "Permissões corrigidas. Acesse o navegador e atualize com F5. Aperte qualquer tecla para votlar."
		read n;;	
    0)  clear;
	exit;;
   esac
done
