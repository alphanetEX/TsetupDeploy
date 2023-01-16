#!/bin/bash

[ ! -f .env ] || export $(grep -v '^#' .env | xargs)

Green='\033[0;32m'
Yellow='\033[0;33m'
Red='\033[0;31m'
Blue='\033[0;34m'
Cyan='\033[0;36m'
Lgray='\033[0;37m'
Magenta='\033[0;35m'
NC='\033[0m'


function PrinterLog {
    #codigo de procedimientos 
    if [[ $1 == 0 ]]; then
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue} $2 |${Cyan} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> $PWD/general.log
    #codigos de backups 
    elif [[ $1 == 1 ]]; then 
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue} $2 |${Green} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> $PWD/general.log

        #envio de log del backup al mail 
        # printf "${message}\n" >> /opt/tp/scripts/emailSender.log
        # echo "" | mutt -s "Backup Process" -i emailSender.log -a emailSender.log -c ${DESTEMAIL}
        # echo "" > /opt/tp/scripts/emailSender.log
    #codigos de monior
    elif [[ $1 == 2 ]]; then 
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue} $2 |${Yellow} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> $PWD/general.log
        #seccion de envio de mail al root 

    #codigos de error 
    elif [[ $1 == 3 ]]; then
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Blue} $2 |${Red} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> $PWD/general.log
    #codigos de existencia de fieriados 
    elif [[ $1 == 4 ]]; then
        dateX=$(date +"%H:%M:%S")
        message=$(printf "${dateX} - ${Lgray} $2 |${Magenta} $3 ${NC}\n")
        printf "${message}\n"; printf "${message}\n" >> $PWD/general.log
    fi
}


