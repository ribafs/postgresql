kdialog --title "DNOCS - Formatacao de Pendrive - Ribamar FS" --msgbox "Espete o pendrive numa porta USB e tecle Enter."
nome=`kdialog --title "DNOCS - Formatacao de Pendrive" --inputbox "Digite um nome para o pendrive"`
kdialog --title "DNOCS - Formatacao de Pendrive" --yesno "Clique em Yes para Formatar e em No para Desistir"
formatar=$?
case $formatar in
0) umount /dev/sda1;mkdosfs -F 32 -n $nome /dev/sda1;;
1) kdialog --msgbox "Cancelando...";;
2) exit 0;;
*) kdialog --msgbox "Algo imprevisto aconteceu";;
esac
