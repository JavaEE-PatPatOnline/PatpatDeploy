# check if the value is "a" or "apply"
function is_apply() {
    if [ "$1" == "-a" ] || [ "$1" == "--apply" ]; then
        return 0
    else
        return 1
    fi
}

function is_delete() {
    if [ "$1" == "-d" ] || [ "$1" == "--delete" ]; then
        return 0
    else
        return 1
    fi
}

function apply_usage() {
    echo "Usage: $0 $1 [-a|--apply|-d|--delete]"
}

if [ "$1" == "nginx" ]; then
    if [ ! -z "$2" ]; then
        echo "Usage: $0 nginx"
        exit 1
    fi
    sudo cp patpat.conf /etc/nginx/conf.d/patpat.conf
    sudo nginx -s reload
elif [ "$1" == "env" ]; then
    if is_apply $2; then
        sudo kubectl apply -f env.yaml
    elif is_delete $2; then
        sudo kubectl delete -f env.yaml
    else
        apply_usage $1 $2
    fi
elif [ "$1" == "service" ]; then
    if is_apply $2; then
        sudo kubectl apply -f service.yaml
    elif is_delete $2; then
        sudo kubectl delete -f service.yaml
    else
        apply_usage $1 $2
    fi
elif [ "$1" == "judge" ]; then
    if is_apply $2; then
        sudo kubectl apply -f judge/judge.yaml
    elif is_delete $2; then
        sudo kubectl delete -f judge/judge.yaml
    else
        apply_usage $1 $2
    fi
elif [ "$1" == "boot" ]; then
    if is_apply $2; then
        sudo kubectl apply -f boot/boot.yaml
    elif is_delete $2; then
        sudo kubectl delete -f boot/boot.yaml
    else
        apply_usage $1 $2
    fi
elif [ "$1" == "stop" ]; then
    sudo kubectl delete -f boot/boot.yaml
    sudo kubectl delete -f judge/judge.yaml
elif [ "$1" == "watch" ]; then
    if [ "$2" == "-d" ] || [ "$2" == "--deployment" ]; then
        sudo kubectl get deployment --watch
    elif [ "$2" == "-p" ] || [ "$2" == "--pod" ]; then
        sudo kubectl get pod --watch
    elif [ "$2" == "-s" ] || [ "$2" == "--service" ]; then
        sudo kubectl get service --watch
    else
        echo "Usage: $0 watch [-d|--deployment|-p|--pod|-s|--service]"
    fi
elif [ "$1" == "log" ]; then
    if [ "$2" == "--clear" ]; then
        sudo rm -rf volume/log/*.log volume/log/boot volume/log/judge
    elif [ "$2" == "boot" ]; then
        watch tail -20 volume/log/boot.log
    elif [ "$2" == "judge" ]; then
        watch tail -20 volume/log/judge.log
    else
        echo "Usage: $0 log [--clear|boot|judge]"
    fi
elif [ "$1" == "deploy" ]; then
    ./manage.sh env --apply
    if [ "$2" == "-a" ] || [ "$2" == "--all" ]; then
        ./deploy.sh boot
        ./deploy.sh judge
    elif [ "$2" == "boot" ]; then
        ./deploy.sh boot
    elif [ "$2" == "judge" ]; then
        ./deploy.sh judge
    else
        echo "Usage: $0 deploy [-a|--all|boot|judge]"
    fi
elif [ "$1" == "reload" ]; then
    ./manage.sh env --apply
    if [ "$2" == "-a" ] || [ "$2" == "--all" ]; then
        ./manage.sh boot --delete
        ./manage.sh judge --delete
        ./manage.sh boot --apply
        ./manage.sh judge --apply
    elif [ "$2" == "boot" ]; then
        ./manage.sh boot --delete
        ./manage.sh boot --apply
    elif [ "$2" == "judge" ]; then
        ./manage.sh judge --delete
        ./manage.sh judge --apply
    else
        echo "Usage: $0 deploy [-a|--all|boot|judge]"
    fi
elif [ "$1" == "push" ]; then
    if [ "$2" == "-a" ] || [ "$2" == "--all" ]; then
        ./push.sh boot
        ./push.sh judge
    elif [ "$2" == "boot" ]; then
        ./push.sh boot
    elif [ "$2" == "judge" ]; then
        ./push.sh judge
    else
        echo "Usage: $0 push [-a|--all|boot|judge]"
    fi
elif [ "$1" == "pull" ]; then
    if [ "$2" == "-a" ] || [ "$2" == "--all" ]; then
        ./push.sh boot --pull
        ./push.sh judge --pull
    elif [ "$2" == "boot" ]; then
        ./push.sh boot --pull
    elif [ "$2" == "judge" ]; then
        ./push.sh judge --pull
    else
        echo "Usage: $0 pull [-a|--all|boot|judge]"
    fi
else
    echo "Usage: $0 verb [options]"
    echo "  nginx    --  reload nginx configuration"
    echo "  env      --  apply environment variables"
    echo "  service  --  apply service"
    echo "  judge    --  manage judge application"
    echo "  boot     --  manage boot application"
    echo "  stop     --  stop all applications"
    echo "  watch    --  watch deployment, pod, or service"
    echo "  log      --  manage log files"
    echo "  deploy   --  deploy applications"
    echo "  reload   --  reload applications"
    echo "  push     --  push applications"
    echo "  pull     --  pull applications"
fi
