#!/bin/bash
#
# Script Shel 
# by Paulo de Oliveira 
#
# Constantes do Scrpt
CaminhoArquivo=/root/`date +bkp%d%m%Y%Hhor%Mmin.bkp`
BancoDeDados=emp03
vacuumdb -z -U postgres $BancoDeDados 
pg_dump -U postgres $BancoDeDados > $CaminhoArquivo

