#!/bin/bash 
#config this file for monitor and mail dependencies 
source /opt/tp/scripts/start.sh 1

#creacion de los folderes de mutt
if [[ ! -d ~/.mutt ]]; then 
    mkdir -p ~/.mutt/cache/headers
    mkdir ~/.mutt/cache/bodies
    touch ~/.mutt/certificates
    touch ~/.mutt/muttrc
fi

#validacion para input passsword en blanco
notEmptyPwx(){
    text=$1
    result=$2
    if [[ -z $result ]]; then 
    PasswordHider "$text"
    pwx_0=$password
    notEmptyPwx "$text" $pwx_0
    fi 
}

#validacion para read -p 
notEmpty() {
    text=$1
    variable=$2
    if [[ -z $variable ]]; then 
    read -p "$text" variable
    notEmpty "$text" $variable    
    else
        echo "$variable"
    fi  
}

function mailConf {
    read -p "Ingrese su Correo electronico(gmail): " email
    email=$(notEmpty "Ingrese su Correo electronico(gmail): " $email)
    PasswordHider "ingrese la contrasenia del correo: "
    pwx_0=$password
    #validacion de espcio en blanco de la  passwd
    notEmptyPwx "ingrese la contrasenia del correo: " $pwx_0
    read -p "Ingrese su nombre de Mail: " namemail
    namemail=$(notEmpty "Ingrese su nombre de Mail: " $namemail)
   
    read -p "Ingrese el mail destinatario de los logs: " destemail
    destemail=$(notEmpty "Ingrese el mail destinatario de los logs: " $destemail)
    echo "DESTEMAIL=${destemail}" >> .env

cat <<EOF >> ~/.mutt/muttrc
set ssl_starttls=yes
set ssl_force_tls=yes
 
set imap_user = '$email'
set imap_pass = '$pwx_0'
 
set from='$email'
set realname='$namemail'
 
set folder = imaps://imap.gmail.com/
set spoolfile = imaps://imap.gmail.com/INBOX
set postponed="imaps://imap.gmail.com/[Gmail]/Drafts"
 
set header_cache = "~/.mutt/cache/headers"
set message_cachedir = "~/.mutt/cache/bodies"
set certificate_file = "~/.mutt/certificates"
 
set smtp_url = 'smtps://$email:$pwx_0@smtp.gmail.com:465/'
 
set move = no
set imap_keepalive = 900 
EOF


}

mailConf

cat <<EOF >> cron_task; crontab -u root cron_task
00 11 * * * /opt/tp/scripts/backupFull.sh BackupA
00 11 * * 0 /opt/tp/scripts/backupFull.sh BackupB
0 0 * * *   /opt/tp/scripts/testEsLaborable.sh
* * * * *   /opt/tp/scripts/monitor.sh apache2 > /dev/null 2>&1
* * * * *   /opt/tp/scripts/monitor.sh mysqld  > /dev/null 2>&1
EOF

rm cron_task

#ask for this script ejecution 

echo "source $PWD/backupFull.sh" >> ~/.bashrc
#pasar a esta ubicacion opcion b
#sudo -s backupFull.sh /usr/local/bin/backupFull
#seccion de iptables