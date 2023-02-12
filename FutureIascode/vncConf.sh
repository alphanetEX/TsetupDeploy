#VNC dependencies 
sudo apt install tightvncserver && sudo apt install xtightvncviewer
#set password 
vncserver 
cat <<EOF >> ~/.vnc/xstartup
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRES
startlxde &
EOF

vncserver -geometry 1920x1080
#matar proceso vnc
vncserver -kill :1