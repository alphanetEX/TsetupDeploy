#!/bin/bash
#configuracion de mavlink


#Dependencies to install mavlink 
sudo apt-get install python3-dev python3-opencv python3-wxgtk4.0 python3-pip python3-matplotlib python3-lxml

sudo apt-get install python3-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libsdl2-dev libsmpeg-dev python3-numpy subversion libportmidi-dev ffmpeg libswscale-dev libavformat-dev libavcodec-dev libfreetype6-dev -y

python3 -m pip install pygame==2.0.0

pip3 install PyYAML mavproxy --user

sudo apt-get install libxml2-dev libxslt1-dev cython3

pip3 install PyYAML mavproxy --user

#check status of permitions to access

echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.zshrc
sudo usermod -a -G dialout $USER

pip3 install mavproxy --user --upgrade

#install developer version of mavproxy 
pip3 install mavproxy --user git+https://github.com/ArduPilot/mavproxy.git@master

#conections using usb-ttl serial 
mavproxy.py --master=/dev/tty.usbserial-141220

#permitions add udev rule of acces /dev/ttyTHS1

sudo chmod 666 /dev/ttyTHS1
#connections of mavproxy using baudrate connection
mavproxy.py --master=/dev/ttyTHS1 --baudrate=115200


