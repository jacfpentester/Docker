#!/bin/bash

set -e

bash /root/ub-base.sh

repo_conf(){

if [ -f $KEYRING ]
    then
	rm -r $KEYRING
    fi

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null

gpg --no-default-keyring --keyring "$KEYRING" --list-keys

DISTRO="$(lsb_release -s -c)"

echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list

apt update
apt install nodejs yarn -y
npm install -g npm-check-updates
npm install -g npm@9.2.0
}

git_conf(){
    if [ -d "/var/www/html/$PROYECTO" ];
    then
    rm -r "/var/www/html/$PROYECTO"
    fi
    mkdir -p "/var/www/html/$PROYECTO"
    cd "/var/www/html/$PROYECTO"

    git config --global user.name "$NAMEGLOBALGIT"
    git config --global user.email "$EMAILGLOBALGIT"
    git init
    git remote add origin "$URL_GIT"
    git pull origin master
}

nest_conf(){
    cd "/var/www/html/$PROYECTO"
    npm i -g @nestjs/cli
    npm i --force
    npm audit fix --force

echo "DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_USERNAME=$DB_USER
DB_NAME=$DB_NAME
DB_PASSWORD=$DB_PASSWORD
PORT=$PORT
HOST_API=$HOST_API
JWT_SECRET=$JWT_SECRET" > .env

echo ".env" >> .gitignore

if [ "$NODE_ENV" = "production" ]; then
   echo "Produccion"
   cd "/var/www/html/$PROYECTO"
   npm run build
   cp -r "/var/www/html/$PROYECTO/dist" "/var/www/html/"
   cp -r "/var/www/html/$PROYECTO/.env" "/var/www/html/"
   cp -r "/var/www/html/$PROYECTO/package.json" "/var/www/html/"
   cp -r "/var/www/html/$PROYECTO/.gitignore" "/var/www/html/"
   cd "/var/www/html/"
   rm -r  "/var/www/html/$PROYECTO"
   npm install --force
   npm audit fix --force
   echo ".env" >> .gitignore
   npm run start:prod
  else
  echo "Desarrollo"
   cd "/var/www/html/$PROYECTO"
   npm run start:dev
   fi
}
main(){
    service nginx start
    repo_conf
    git_conf
    nest_conf
}
main
