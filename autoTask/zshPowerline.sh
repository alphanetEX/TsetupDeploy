#!/bin/bash 
#-------------aws ec2 installation------------------------
#Compatible with  ARM x64-devices
# pwx=""
# read -p "ingrese su passwd" pwx
# passw= echo -e "$pwx\n" 

#posicionamiento de password hider
$passw | sudo -S apt-get update -y && apt-get upgrade -y #-x%
$passw | sudo -S apt-get install curl -y 
cd /usr/src/
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$passw | sudo -S python3 get-pip.py -y 
$passw | sudo -S apt-get install vim-nox -y && sudo apt-get install python3-pip -y
$passw | sudo -S pip3 install powerline-status
$passw | sudo -S apt-get install powerline -y
$passw | pip install --user git+git://github.com/powerline/powerline
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf 
wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf 
$passw | sudo -S mv PowerlineSymbols.otf /usr/share/fonts/
$passw sudo -S mv 10-powerline-symbols.conf /etc/fonts/conf.d/
cd /usr/share/fonts | fc-cache -fv
cd ~/

touch ~/.vimrc 
#broken direction (change direction of new python src location)
cat <<EOF >> ~/.vimrc
set showmode
set number
set autoindent
set tabstop=4
set expandtab
syntax on
  
set laststatus=2           " Always display the status bar
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
EOF


#("fix area python local")
cat <<EOF >> ~/.bashrc 

if [ -f .local/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh ]; 
then source .local/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh
fi
EOF


#---------------ohmyzsh-configuration---------------------------------

$passw | sudo -S apt-get install zsh -y 
$passw | sudo -S apt-get install fish -y 
 
cat <<EOF >> ~/.bashrc 
# Launch Zs
if [ -t 1 ]; then
exec zsh
fi
EOF


$passw | sudo -S sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

newline='ZSH_THEME="agnoster"'

sed -i "11s/.*/$newline/" ~/.zshrc 
echo "restart your terminal!"

#-------------powerlevel 9k mode  check :------------------------------------

$passw | sudo -S git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

#revisar las dependencias de los fonts para los usuarios secundarios
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && sudo -S curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
sudo cp Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete.otf /usr/share/fonts/
cd /usr/share/fonts
fc-cache -fv
cd ~/

#building awesome terminal fonts 
git clone https://github.com/gabrielelana/awesome-terminal-fonts.git
cd awesome-terminal-fonts
./build
$passw | sudo -S cp -r  build/* /usr/share/fonts/
cd /usr/share/fonts/
fc-cache -fv
cd 


#newline='ZSH_THEME="powerlevel9k/powerlevel9k"'  
powerlevel9k='POWERLEVEL9K_MODE="nerdfont-complete"' 
sed -i '11c\ZSH_THEME="powerlevel9k/powerlevel9k"' ~/.zshrc
sed -i -e "12s/.*/$powerlevel9k/" ~/.zshrc

sed -i '/User configuration/ i source ~/.oh-my-zsh/custom/themes/powerlevel9k/powerlevel9k.zsh-theme \
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1 \
POWERLEVEL9K_SHORTEN_DELIMITER="" \
#POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right" \
POWERLEVEL9K_PROMPT_ON_NEWLINE=true \
#espacios entre inconos a la izquierda \
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="" \
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="" \
POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=" " \
#espacios entre iconos a la derecha \
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="" \
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" " \
POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS="" #espacios a la derecha icono\
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon disk_usage ram root_indicator dir dir_writable_joined) \
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs time_joined node_version) \
#color de configuracion de git \
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="clear" \
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="clear" \
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="yellow" \
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="yellow" \
#os icon background \
POWERLEVEL9K_OS_ICON_BACKGROUND="clear" \
POWERLEVEL9K_OS_ICON_FOREGROUND="015" \
#dir \
POWERLEVEL9K_SHORTEN_DELIMITER=".." \
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2 \
#Disk usage \
POWERLEVEL9K_DISK_USAGE_NORMAL_BACKGROUND="clear" \
POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND="121" \
POWERLEVEL9K_DISK_USAGE_WARNING_BACKGROUND="clear" \
POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND="202" \
POWERLEVEL9K_DISK_USAGE_CRITICAL_BACKGROUND="clear" \
POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND="196" \
#RAM colors \
POWERLEVEL9K_RAM_BACKGROUND="clear" \
POWERLEVEL9K_RAM_FOREGROUND="yellow" \
#node version color \
POWERLEVEL9K_NODE_VERSION_BACKGROUND="clear" \
POWERLEVEL9K_NODE_VERSION_FOREGROUND="green" \
#home and dir colors \
POWERLEVEL9K_DIR_HOME_BACKGROUND="clear" \
POWERLEVEL9K_DIR_HOME_FOREGROUND="blue" \
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear" \
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="blue" \
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="clear" \
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="red" \
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear" \
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white" \
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="red" \
POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="white"\
#status color \
POWERLEVEL9K_STATUS_OK_BACKGROUND="clear" \
POWERLEVEL9K_STATUS_OK_FOREGROUND="blue" \
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="clear" \
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red" \
#time color \
POWERLEVEL9K_TIME_BACKGROUND="clear" \
POWERLEVEL9K_TIME_FOREGROUND="230" \
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="clear" \
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="magenta" \
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="clear" \
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="green" \
# RIGHT_PROMPT Github \
# ===========================================================\
# vcs branch of git conffiguration \
#POWERLEVEL9K_SHOW_CHANGESET=true \
#POWERLEVEL9K_CHANGESET_HASH_LENGTH=6 \
#showing efects of change status git \
POWERLEVEL9K_VCS_CLEAN_BACKGROUND="none" \
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="076" \
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="none" \
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="005" \
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="none" \
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="003" \
#showing efects of github \
POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname)' ~/.zshrc
cat <<EOF >> ~/.zshrc 
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%F{white}"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%F{white} "
EOF
#--------rutas-------
#/usr/lib/python2.7/dist-packages/powerline
#.local/lib/python2.7/site-packages/powerline/
#verificacion de espacios/ pasar el codigo de sed al repo de auth01_alpha.sh


# exeptions 

# usermod -aG sudo alphanet