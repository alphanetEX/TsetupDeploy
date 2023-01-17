#!/bin/bash 
#author: AlphanetEX, Vertion:0.1.4
#public variables 
#modfify part of aumation scripts 
pkgjson=package.json;

#functions 
mkfilecr(){
    mkdir -p -- "$1" &&
    cd -P -- "$1" 
    #crate a validate section if exed of $4 return err 
    touch $2 $3 $4 && cd .. 
}

#stable creator multiforlder 
mkrfd(){
 array=("$@") #@ ya es un arraid solo se reasigna 
 mkdir -p -- "$1" && 
 cd -P -- "$1" 
 cant="${#array[*]}"
    counter=1
    while [ $counter -lt $cant ] 
    do
    mkdir -p -- "${array[$counter]}"
    ((counter ++));
    done
    cd .. 
}

#stable creator multiarchive 
archive(){
  receptor=("$@")
  cant="${#receptor[*]}"
  pushd $1 > /dev/null
  counter=1
  while [ $counter -lt $cant ] 
    do
     touch "${receptor[$counter]}"
    ((counter ++));
    done
    popd > /dev/null
}

#folder sector creations
mkrfd src controllers database middleware model routes views
pushd src/ > /dev/null
mkrfd routes api views
mkrfd controllers api views 
mkrfd database config migrations models
popd > /dev/null
mkrfd public css images


#archive sector creations 
archive src/routes/api/ productRouter.js usersRouter.js
archive src/controllers/api/ productController.js userController.js

touch app.js  readme.md 
touch Dockerfile docker-compose.yml .dockerignore
#git init branch 

#npm dependencies 
npm init -y; 
npm i -S express body-parser dotenv 

npm dev dependencies 
npm i -D nodemon 

cat << EOF >> .gitignore 
/node_modules
.gitignore
.env
EOF