#!/bin/bash
#AUTHOR: AlphanetEX, backup mode
#bash orientado a .bashrc
unset disk_uuid[3]
source /opt/tp/scripts/generalPrint.sh

#obtener las variables del archivo .env
set -o allexport
source /opt/tp/scripts/.env
set +o allexport

#valida los uuids registrados en conf_raid.sh  >> .env comparandose con los discos actualmente montados
function ValidateUuids {
    disk_uuid[0]=$(blkid | grep "mapper/vg_tp" | sed -r 's/.*([0-9a-z]{8})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{12}).*/\1-\2-\3-\4-\5/' | sed -n 1p)

    disk_uuid[1]=$(blkid | grep "mapper/vg_tp" | sed -r 's/.*([0-9a-z]{8})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{12}).*/\1-\2-\3-\4-\5/' | sed -n 2p)

    disk_uuid[2]=$(blkid | grep "mapper/vg_tp" | sed -r 's/.*([0-9a-z]{8})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{12}).*/\1-\2-\3-\4-\5/' | sed -n 3p)

    if [[ ${disk_uuid[0]} == ${u01} && ${disk_uuid[1]} == ${u02} && ${disk_uuid[2]} == ${u03} ]]; then 
        echo true
    else  
        PrinterLog 3 "Validando UUIDS " "Los UUID de montaje no coinciden"
        echo false
    fi 
}

function BackupFiles {
    #funcion de ayuda item 4.5
    if [[ $1  == "-h" ]]; then  
    echo "BackupFiles <origen> <destino>"
    else 
        #this regex only works with 3 layers of FHS (NOT STABLE)
        dir_sed=$(echo $1 | sed -r 's/\/(\w+\d?)\/?(\w+\d?)?\/+?/\1\2/') 
        #se valida la exitencia de ambos directorios
        if [[ -d $1 && -d $2 ]]; then 
            #se obtiene la fecha 
            dateX=$(date +"%Y%m%d")
            #se genera el nombre del paquete a comprimir
            name_tar="${dir_sed}_bkp_${dateX}.tar.gz"
            pushd $1 > /dev/null 2<&1
            #se crea el paquete y se comprime
            tar cfz $name_tar *
            #se mueve el archivo a la ruta de destino
            mv $name_tar $2
            popd > /dev/null 2<&1
            #se valida si el comprimido llego al destino 
            if [[ -e $2$name_tar ]]; then
                PrinterLog 1 "Backup de el directorio $1" "Backup realizado con exito respalado en $2"
            fi 
        else
            PrinterLog 3 "Backup de el directorio $1" "error no se encuentra la existencia del directorio $1 o $2"
        fi
    fi
}

#ejecutar funciones en crontab
#backup del item 4.A 
function BackupA {
    valuuids=$(ValidateUuids)
    if [[ $valuuids == true ]]; then
    BackupFiles /etc/ /u03/
    BackupFiles /var/log/ /u03/
    fi
}

#backup del item 4.B
function BackupB {
    valuuids=$(ValidateUuids)
    if [[ $valuuids == true ]]; then
    BackupFiles /u01/ /u03/
    BackupFiles /u02/ /u03/
    fi
}

#se administra  x cantidad de argumentos de entrada 
$@
