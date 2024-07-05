if [ "$1" == "nginx" ]; then
    sudo cp patpat.conf /etc/nginx/conf.d/patpat.conf
    sudo nginx -s reload
elif [ "$1" == "env" ]; then
    if [ "$2" == "a" ]; then
        sudo kubectl apply -f env.yaml
    elif [ "$2" == "d" ]; then
        sudo kubectl delete -f env.yaml
    else
        echo "Usage: $0 env [a|d]"
    fi
elif [ "$1" == "service" ]; then
    if [ "$2" == "a" ]; then
        sudo kubectl apply -f service.yaml
    elif [ "$2" == "d" ]; then
        sudo kubectl delete -f service.yaml
    else
        echo "Usage: $0 service [a|d]"
    fi
elif [ "$1" == "judge" ]; then
    if [ "$2" == "a" ]; then
        sudo kubectl apply -f judge/judge.yaml
    elif [ "$2" == "d" ]; then
        sudo kubectl delete -f judge/judge.yaml
    else
        echo "Usage: $0 judge [a|d]"
    fi
elif [ "$1" == "boot" ]; then
    if [ "$2" == "a" ]; then
        sudo kubectl apply -f boot/boot.yaml
    elif [ "$2" == "d" ]; then
        sudo kubectl delete -f boot/boot.yaml
    else
        echo "Usage: $0 boot [a|d]"
    fi
elif [ "$1" == "stop" ]; then
    sudo kubectl delete -f boot/boot.yaml
    sudo kubectl delete -f judge/judge.yaml
elif [ "$1" == "watch" ]; then
    if [ "$2" == "d" ]; then
        sudo kubectl get deployment --watch
    elif [ "$2" == "p" ]; then
        sudo kubectl get pod --watch
    elif [ "$2" == "s" ]; then
        sudo kubectl get service --watch
    else
        echo "Usage: $0 watch [d|p|s]"
    fi
elif [ "$1" == "log" ]; then
    if [ "$2" == "--clear" ]; then
        rm -rf volume/log/*.log
    elif [ "$2" == "boot" ]; then
        watch tail -20 volume/log/boot.log
    elif [ "$2" == "judge" ]; then
        watch tail -20 volume/log/judge.log
    else
        echo "Usage: $0 log [--clear|boot|judge]"
    fi
elif [ "$1" == "deploy" ]; then
    ./manage.sh env a
    if [ "$2" == "--clear" ]; then
        ./manage.sh log --clear
    elif [ "$2" == "all" ]; then
        cd boot && ./deploy.sh && cd ..
        cd judge && ./deploy.sh && cd ..
    elif [ "$2" == "boot" ]; then
        cd boot && ./deploy.sh && cd ..
    elif [ "$2" == "judge" ]; then
        cd judge && ./deploy.sh && cd ..
    else
        echo "Usage: $0 deploy [--clear|all|boot|judge]"
    fi
else
    echo "Usage: $0 [nginx|env|service|judge|boot|stop|watch]"
fi
