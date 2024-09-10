#!/bin/bash

if [ "$1" == "all" ] || [ "$1" == "a" ]; then
    cd sercer
    deploy.sh boot
    deploy.sh judge
elif [ "$1" == "boot" ]; then
    server/deploy.sh boot
elif [ "$1" == "judge" ]; then
    server/deploy.sh judge
else
    echo "Usage: $0 all|boot|judge"
fi