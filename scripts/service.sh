#!/bin/bash

if [ "$1" == "apply" ]; then
    sudo kubectl apply -f config/service.yaml
elif [ "$1" == "delete" ]; then
    sudo kubectl delete -f config/service.yaml
elif [ "$1" == "reload" ]; then
    $0 delete
    $0 apply
else
    echo "Usage: $0 apply|delete|reload"
fi
