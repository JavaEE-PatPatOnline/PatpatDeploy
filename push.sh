#!/bin/bash

target=${1:?"Usage: $0 [boot|judge]"}
if [ $target != "judge" ] && [ $target != "boot" ]; then
    echo "[ERROR] Invalid target: $target"
    echo "Usage: $0 [boot|judge]"
    exit 1
fi
cd $target
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to cd to $target" | tee -a deploy.log
    exit 1
fi

# read version number in version file
version=`cat version`
if [ -z $version ]; then
    echo "[ERROR] No version number found"
    exit 1
fi

registry=${DOCKER_REGISTRY:?"DOCKER_REGISTRY not set"}
username=${DOCKER_USERNAME:?"DOCKER_USERNAME not set"}
namespace=${DOCKER_NAMESPACE:?"DOCKER_NAMESPACE not set"}
password=${DOCKER_PASSWORD:?"DOCKER_PASSWORD not set"}

# login
echo $password | docker login --username=$username $registry --password-stdin

if [ "$2" == "--pull" ]; then
    # pull the image
    echo "Pulling $registry/$namespace/pat-$target:$version"
    docker pull $registry/$namespace/pat-$target:$version
else
    # tag the image
    echo "Tagging pat-$target:$version as $registry/$namespace/pat-$target:$version"
    docker tag pat-$target:$version $registry/$namespace/pat-$target:$version

    # push the image
    echo "Pushing $registry/$namespace/pat-$target:$version"
    docker push $registry/$namespace/pat-$target:$version
fi
