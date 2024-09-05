#!/bin/bash

if [ "$1" == "apply" ]; then
    if [ "$2" == "boot" ]; then
        sudo kubectl apply -f server/boot/boot.yaml
    elif [ "$2" == "judge" ]; then
        sudo kubectl apply -f server/judge/judge.yaml
    elif [ "$2" == "all" ]; then
        sudo kubectl apply -f server/boot/boot.yaml
        sudo kubectl apply -f server/judge/judge.yaml
    else
        echo "Usage: $0 apply boot|judge|all"
    fi
elif [ "$1" == "delete" ]; then
    if [ "$2" == "boot" ]; then
        sudo kubectl delete -f server/boot/boot.yaml
    elif [ "$2" == "judge" ]; then
        sudo kubectl delete -f server/judge/judge.yaml
    elif [ "$2" == "all" ]; then
        sudo kubectl delete -f server/boot/boot.yaml
        sudo kubectl delete -f server/judge/judge.yaml
    else
        echo "Usage: $0 delete boot|judge|all"
    fi
elif [ "$1" == "reload" ]; then
    $0 delete $2
    $0 apply $2
else
    echo "Usage: $0 apply|delete|reload boot|judge|all"
fi
