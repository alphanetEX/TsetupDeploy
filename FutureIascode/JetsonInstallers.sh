#!/bin/bash 
sudo apt install postgresql postgresql-contrib -y
sudo -i -u postgres
createuser --interactive
#access directly normal cli 
sudo -i -u postgres psql 
cmd_data="aphanet
y
"


sudo -S sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' <<< $cmd_data | createuser --interactive

sudo apt install exfat-fuse exfat-utils -y
sudo apt-get install lvm2 -y 
#jetson xavier dependencies 

rsync -aPvhe ssh -A --rsync-path="sudo -Sv && sudo rsync" ec2-user@<privateEC2-IP>:/home/ec2-user/testfile /home/ec2-user

#
sudo vim /etc/sudoers 
#add files to use rsync in the host 
alphanet ALL= NOPASSWD:/usr/bin/rsync

#ejecute comand in host machine
rsync -rzt --progress --exclude={'examples/*',.git/*} --rsync-path="sudo rsync" -r $(pwd)/ alphanet@192.168.0.55:/usr/src/srv_deploys



git clone https://github.com/JetsonHacksNano/buildKernelAndModules.git

#vim build kernel & modules ~/getKernelSources.sh

L4T_TARGET="32.6.1"  #7
KERNEL_RELEASE="4.9" #9

#~/buildKernelAndModules/scripts/getKernelSources.sh
wget -N https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/sources/t210/public_sources.tbz2 #18

LOCAL_VERSION=${KERNEL_VERSION#$"4.9.253"} #33
cd ~/buildKernelAndModules/scripts/
sudo ./installDependencies.sh
cd ..
./getKernelSources.sh -d ~/src/nvidia.com
cd ~/src/nvidia.com/kernel/kernel-4.9 
vim .confing

#using sed
# CONFIG_RTC_DRV_DS1307 is not set #4825
#new change 
CONFIG_RTC_DRV_DS1307=m


cd ~/buildKernelAndModules/ 
./makeKernel.sh -d ~/src/nvidia.com/
#internal Gsed ejecutions
#\n
#\n
cd ~/src/nvidia.com/kernel/kernel-4.9
sudo make M=drivers/rtc/ 

#make M=/dev/shm/kernel/*.bin

cd ~/src/nvidia.com/kernel/kernel-4.9/drivers/rtc/
sudo cp rtc-ds1307.ko /lib/modules/4.9.253-tegra/kernel/drivers/rtc/
cd .. 
cd ..
sudo depmod -a
sudo modprobe rtc-ds1307
sudo i2cdetect -y -r 1

#section of automatizacion on enable
sudo echo "#external hw rtc
rtc-ds1307" > /etc/modules

sudo vi /etc/rc.local

#insertion ################

#!/bin/sh -e
# rc.local 

echo ds1307 0x68 | sudo tee /sys/class/i2c-adapter/i2c-1/new_device
sudo hwclock -s -s -f /dev/rtc2
date

#################

sudo chmod a+x /etc/rc.local

sudo vi /etc/systemd/system/rc-local.service
#insertion 
[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExist=/etc/rc.local

[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes

[Install]
 WantedBy=multi-user.target

##########################
 
sudo systemctl enable rc-local

#asignando un horario al timer 
sudo hwclock --set --date "$(LANG=en_US_88591; date "+%a %b %d %T %Z %Y")" -f /dev/rtc2

#direccion de configuracion de la sdcard de la jetson 
cat /sys/kernel/debug/mmc0/ios
apt-get install hdparm
hdparm -tT /dev/mmcblk0

#particiones
/dev/sda
/dev/sdb
/dev/sdc
/dev/sdd




sudo -S pvcreate /dev/sda1
sudo -S vgcreate postgres /dev/sda1
sudo -S lvcreate -n node0 -L 10g postgres
sudo -S lvcreate -n node1 -L 10g postgres
#format and mount see fix xfs configuration d
sudo -S mkfs.ext4 /dev/mapper/postgres-node0
sudo -S mount /dev/mapper/postgres-node0 /usr/src/node0/
rm -rf node0/* 
rm -rf node1/*
}

lsb_release -a | sed -n 3p  | sed -r 's/.*([0-9]+\.[0-9]+).*/\1/'

#postgresSQL client
apt-get install postgresql-client-10 -y