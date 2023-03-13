#!/bin/sh
if [ $1 == "-c" ]; then
    tar -zcvf blog.tar.gz _config.yml package.json scaffolds/ source/ themes/ scripts/

elif [ $1 == "-i" ]; then
    sudo npm install -g hexo
    npm install

elif [ $1 == "-h" ]; then
    echo -e "\
    -c compress necessary files\n\
    -i install\n\
    -h help"

else
    echo "Invalid arguments"

fi