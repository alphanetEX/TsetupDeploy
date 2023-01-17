#!/bin/bash 
#AUTHOR: AlphanetEX, disk formatter automatization v0.1.2
unset dec hex alphabet 
unset fdisk_raid_cmd fdisk_lvm_cmd madnm_cmd

#MDADM SECTOR
fdisk_raid_cmd="n
p
    #\n
    #\n
    #\n
t
fd
w
q"


fdisk_lvm_cmd="n
p
    #\n
    #\n
    #\n
t
8e
w
q"


madnm_cmd="#\n
y
"

ValExistence(){
    if [[ -e  "/dev/xvd$1" ]]; then
        echo true
    else 
        echo "the /dev/xvd$1 was not found \n"
    fi
}

DiskFormatter(){

dec=98 #equivale a valor ascii de b
counter=0
counter_disk=0

cant=$1
receptor=$2

if ! [[  $1 && $2  != "" ]]; then 
    read -p "Cantidad de discos a Formatear ?: " cant
    read -p "Opcion de formateo (RAID)=1, (LVM=2), (Default EXT 4): " receptor
fi 

while [ $counter -lt $cant ]
    do
    hex=$(printf "%x\n" $dec);
    alphabet=$(printf "\x$hex");
    validator=$(ValExistence $alphabet);
     
    if [[ $validator == true ]]; then  
        #RAID1
        if [[ $receptor == 1  ]]; then
        sudo -S sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' <<< $fdisk_raid_cmd | sudo -S fdisk /dev/xvd$alphabet >> $PWD/diskformatter.log 2<&1
        ((counter ++));
        ((dec ++));
        #LVM
        elif [[ $receptor == 2 ]]; then 
        sudo -S sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' <<< $fdisk_lvm_cmd | sudo -S fdisk /dev/xvd$alphabet >> $PWD/diskformatter.log 2<&1
        ((counter ++));
        ((dec ++));
        else
        #DEFAULT EXT4
        sudo -S mkfs.ext4 /dev/xvd$alphabet >> fdisk.log 2<&1
        ((counter ++));
        ((dec ++))
        fi
    else
        printf "$validator"
        ((counter ++));
        ((dec ++));
    fi
    done    
}

main(){
    DiskFormatter $1 $2
    
}

main $1 $2