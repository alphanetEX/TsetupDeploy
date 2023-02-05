#!/bin/bash


#ubuntu 22.04 bug-fix
sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
apt-get update --allow-releaseinfo-change
sudo apt-get install libcrack2 -y