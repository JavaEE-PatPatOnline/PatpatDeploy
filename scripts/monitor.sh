#!/bin/bash

flags=""
if [ "$1" == "watch" ]; then
    flags="--watch"
    shift
fi

if [ "$1" == "pod" ] || [ "$1" == "p" ]; then
    sudo kubectl get pod $flags
elif [ "$1" == "deployment" ] || [ "$1" == "d" ]; then
    sudo kubectl get deployment $flags
elif [ "$1" == "service" ] || [ "$1" == "s" ]; then
    sudo kubectl get service $flags
elif [ "$1" == "all" ] || [ "$1" == "a" ]; then
    sudo kubectl get all
else
    echo "Usage: $0 [watch] <resource>"
    echo "resource:"
    echo "  pod (p)"
    echo "  deployment (d)"
    echo "  service (s)"
    echo "  all (a), including pod, deployment, and service"
fi
