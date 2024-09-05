#!/bin/bash

if [ "$1" == "reload" ]; then
    sudo cp config/patpat.conf /etc/nginx/conf.d/patpat.conf
    sudo nginx -s reload
    echo "patpat.conf is reloaded"
elif [ "$1" == "delete" ]; then
    sudo rm -rf /etc/nginx/conf.d/patpat.conf
    sudo nginx -s reload
    echo "patpat.conf is deleted"
else
    echo "Usage: $0 reload|delete"
fi
