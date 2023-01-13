#!/bin/bash 
#author: AlphanetEX, Vertion:0.1.4
#public variables 
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
mkrfd public assets image 
mkrfd routes api views
mkrfd utils mocks middlewares schemas auth
mkrfd scripts mongo test
mkdir services config lib build utils/auth/strategies 

#archive sector creations 
archive services/ tipe_users.js
archive routes/ views/tipe_users.js 
archive routes/api/ tipe_users.js auth.js
archive utils/ isRequestAjaxOrApi.js cacheResponse.js time.js 
archive utils/mocks/ index.js 
archive utils/middlewares/ errorsHandlers.js validationHandler.js 
archive utils/schemas/ type_users.js
archive utils/auth/strategies/ basic.js jwt.js 
archive scripts/mongo seed-admin.js
archive build/ development.Dockerfile production.Dockerfile
touch index.js .gitignore info.md config/index.js lib/mongo.js utils/isRequestAjaxOrApi.js .env .env.example 
touch package.json Dockerfile docker-compose.yml .dockerignore 

#npm dependencies 
npm init -y; 
npm i -S express body-parser dotenv \
mongodb @sentry/node@5.5.0 \
@hapi/joi @hapi/boom passport passport-http passport-jwt jsonwebtoken bcrypt \
helmet
#npm dev dependencies 
npm dev dependencies 
npm i -D nodemon 
npm i -D chalk 
npm i -D supertest mocha sinon proxyrequire

#veriry if on distribution its linux (sed) or macosx (gsed)
#sed operations 
if [[ $(uname -s) == "Darwin" ]]; then 
gsed -i '1c\/node_modules' .gitignore 
gsed -i '10c\\n' $pkgjson; 
gsed -i '10c\  "start": "node index.js",' $pkgjson;
gsed -i '11c\\n' $pkgjson; 
gsed -i '11c\  "dev": "nodemon index.js"' $pkgjson;
gsed -i '12c\\n' $pkgjson; 
gsed -i '12c\ "test": "mocha --exit"' $pkgjson 
#gsed -i '9c\},' $pkgjson;
elif [[ $(uname -s) = "Linux" ]]; then
sed -i '1c\/node_modules' .gitignore 
sed -i '10c\ \n' $pkgjson; 
sed -i '10c\  "start": "node index.js",' $pkgjson;
sed -i '11c\\n' $pkgjson; 
sed -i '11c\  "dev": "nodemon index.js"' $pkgjson;
gsed -i '12c\\n' $pkgjson; 
gsed -i '12c\ "test": "mocha --exit"' $pkgjson 
else
echo "Contact with de Delevoper for attach this new characteristic sed in your enviroment"
fi 

cat <<EOM >> .gitignore 
/node_modules
.gitignore
.env
EOM


cat <<EOM >> .env.example
// CONFIG 
PORT=8000 

// MONGO 
DB_USER=
DB_PASSWORD=
DB_HOST= 
DB_PORT=
DB_NAME= 

// Sentry 
SENTRY_DNS=
SENTRY_ID=

//AUTH 
AUTH_ADMIN_USERNAME=
AUTH_ADMIN_PASSWORD=
AUTH_ADMIN_EMAIL=
AUTH_JWT_SECRET=
EOM

#fix this part
cat <<EOM >> .dockerignore
/node_modules
docker-compose.yml 
Dockerfile
.dockerignore
root.bash
EOM 

#fix this part 
cat <<EOM >> Dockerfile
FROM node:10

COPY ["package.json","package-lock.json", "/usr/src/"]

WORKDIR /usr/src

RUN npm install

COPY [".", "/usr/src/"]

EXPOSE 3000

CMD ["npx", "nodemon", "index.js"]
EOM


#fix this part 
cat <<EOM >> docker-compose.yml
version: "3"

services:
  app:
    build: .
    environment:
      MONGO_URL: "mongodb://db:27017/auth01"
    depends_on:
      - db
    ports:
      - "3000-3010:3000"
    volumes:
      - .:/usr/src 
      - /usr/src/node_modules
  db:
    image: mongo
EOM


#rm -r node_modules 

#other script
 
#node scripts/mongo/seed-admin.js
#uninstalling recomended with npm 
#npm uninstall body-parse 
#rm -rf config/ lib/ node_modules public/ routes/ scripts/ services/ utils/ index.js package.json package-lock.json
