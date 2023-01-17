#!/bin/bash
#AUTHOR: AlphanetEX, APACHE2 + MYSQL CONFIGURATION
apache_conf="/etc/apache2/sites-available/"
#read .env file it works 
[ ! -f .env ] || export $(grep -v '^#' .env | xargs)

[[ ! -d /u01 ]] && mkdir /u01

[[ ! -d /u02 ]] && mkdir /u02

#creacion y configuracion de permisos y rutas de apache2
mkdir /u01/proyect-x/
sudo chmod -R 755 /u01/
chown -R root:www-data /u01

cp /opt/tp/scripts/index.php /u01/proyect-x/
cd /etc/apache2/sites-available/ 
cp 000-default.conf deployx.conf

#apache configurations 
sed -i '19c\ \n' $apache_conf/deployx.conf
sed -i -e "12s/.*/        DocumentRoot \/u01\/proyect-x/" deployx.conf
sed -i -e "14s/.*/    <Directory \/u01\/proyect-x>/" deployx.conf
sed -i -e "15s/.*/        Options\ FollowSymLinks/" deployx.conf
sed -i -e "16s/.*/        AllowOverride\ None/" deployx.conf
sed -i -e "17s/.*/        Require\ all\ granted/" deployx.conf
sed -i -e "18s/.*/    <\/Directory>/" deployx.conf

#enbled php7 on apache2
a2enmod php7.* 
#enabled mysqli conexion library on apache2
sudo phpenmod mysqli
a2dissite 000-default.conf 
a2ensite deployx.conf

#systemctl reload apache2
/etc/init.d/apache2 restart

# Automatization for mysql_secure_installation script
sudo mysql --user=root --password=${PASS_MYSQL_ROOT} << EOFMYSQLSECURE
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOFMYSQLSECURE

# Note down this password. Else you will lose it and you may have to reset the admin password in mySQL
echo -e "SUCCESS! MySQL password is: ${PASS_MYSQL_ROOT}" 

#creacion y configuracion de permisos y rutas de mysql 
chown -R mysql:mysql /u02 
systemctl stop mysql
cp -R -p /var/lib/mysql/* /u02
cd /etc/mysql/mysql.conf.d/ 
sed -i -e "32s/.*/datadir         = \/u02/" mysqld.cnf
systemctl start mysql

cd /opt/tp/scripts/
#$passw | sudo -S mysql -u root -p ${PASS_MYSQL_ROOT} < db.sql 
mysql -u root -p${PASS_MYSQL_ROOT} < db.sql
mysql -u root -p${PASS_MYSQL_ROOT} < feriados.sql