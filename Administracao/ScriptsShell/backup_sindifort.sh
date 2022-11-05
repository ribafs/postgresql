#!/bin/sh
# Script de backup incremental para o SINDIFORT
#http://www.hardware.com.br/tutoriais/backup2/

#tar --newer-mtime=`date +%Y%m%d%H%M` -cf /home/ribafs/guardar/backup_`date +%Y%m%d_%H%M`.tar /home/ribafs/backup
# "-a" (archive) faz com que todas as permissões e atributos dos arquivos sejam mantidos, da mesma forma que ao criar os arquivos com o tar, e o 
# "v" (verbose) mostra o progresso na tela.

# origem - destino
rsync -av /home/backup/ /home2/backup/

# Se algum desastre acontecer e você precisar recuperar os dados, basta inverter a ordem das pastas no comando, fazendo com que a pasta com o 
# backup seja a origem e a pasta original seja o destino, como em:

# destino - origem
# rsync -av --delete /home2/backup/ /home/backup/

# O "--delete" faz com que arquivos apagados na pasta original sejam apagados também na pasta do backup, fazendo com que ela se mantenha como uma cópia 
# fiel. Naturalmente, a opção pode ser removida do comando se o objetivo é fazer com que o backup mantenha arquivos antigos, de forma que você 
# possa recuperá-los posteriormente, caso necessário.

# Este script poderia ser executado uma vez por dia usando o cron, de forma que você tivesse sempre um backup do dia anterior à mão, pronto 
# para recuperar qualquer arquivo deletado acidentalmente.

# No cron para todos os dias as zero horas, exceto sábados e somingos
# 0 0 * * 1-5 /home2/backup.sh


