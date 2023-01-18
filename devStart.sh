#!/bin/bash
#AUTHOR: AlphanetEX, execute this file with SUDO Mode
unset C
unset NVM 
unset JS
#preload functions of start.sh 
source start.sh 1

Red='\033[0;31m'
Cyan='\033[0;36m'
NC='\033[0m'


C='
c(){
folder="compilers"
if [[ ! -d $folder ]]; then
mkdir $folder
fi
  
entry=$(echo "$1" | sed "s/\(\w\)\(\.c\)/\1/g")
gcc -o $entry $1
mv $entry $folder
./$folder/$entry
}'

NVM='
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
'

JS='
js(){ 
    node $1 
};'

#pair dependencies to sudo 
dev_packages(){
    #validation of existence of NVM
    if ! [[ -d "$HOME/.nvm" ]]; then 
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    bash ~/.nvm/install.sh
    
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 

    cat <<< $NVM >> $1

    nvm install --lts

    else

    printf "${Cyan} The NVM was Already exist ${NC} \n"
    fi
 
    #validate not rewritting 
    
    #envio de customizacion de codigo C al archivo de configuracion 
    cat <<< $C >> $1
    #envio de customizacion de codifo JS al archivo de configuracion 
    cat <<< $JS >> $1

    printf "${Cyan}Restart your terminal ${NC}"

}

main(){
    Verify_Kernel_Conf
    if [[ $USER == "root" ]]; then
    printf "${Red} Warning the Root User not its Usable on this Script for Security Resons ${NC} \n"
    elif [[ -f /.dockerenv  ]]; then 
    printf "${Red} This script was not designed for containers in this version ${NC} \n"
    elif [[ -f "$HOME/.zshrc" || -d "$HOME/.oh-my-zsh" ]]; then
    dev_packages "$HOME/.zshrc"
    else
    dev_packages "$HOME/.bashrc"
    fi
    }

main




#VERIFICAR QUE NO SE EJECUTA EN ROOT