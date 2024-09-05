#!/bin/bash

if [ "$1" == "clear" ]; then
    sudo rm -rf volume/log/*.log volume/log/boot volume/log/judge
elif [ "$1" == "boot" ]; then
    watch tail -20 volume/log/boot.log
elif [ "$1" == "judge" ]; then
    watch tail -20 volume/log/judge.log
else
    echo "Usage: $0 log clear|boot|judge"
fi
