#!/bin/bash

#
# PatBoot/PatJudge deploy script
#

# Preamble
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

# Main

echo "===== `date`" | tee -a deploy.log

# get all files in target/
files=`ls target/`

# iterate all files and get the file with the largest version
max_version=0
max_file=""
for file in $files; do
    version=`echo $file | grep -oE "[0-9]+\.[0-9]+\.[0-9]+"`
    if [ "$version" \> "$max_version" ]; then
        max_version=$version
        max_file=$file
    fi
done

if [ -z $max_file ]; then
    echo "[ERROR] No file to deploy" | tee -a deploy.log
    exit 1
fi

echo "[INFO] Deploying $max_file" | tee -a deploy.log

# Update version
touch version
last_version=`cat version`
reload=0
if [ "$max_version" \> "$last_version" ]; then
    echo "[INFO] Upgrading to $max_version" | tee -a deploy.log
else
    echo "[WARNING] Version $max_version is not greater than $last_version" | tee -a deploy.log
fi

# Build docker
if [ ! -f Dockerfile ]; then
    echo "[ERROR] Dockerfile not found" | tee -a deploy.log
    exit 1
fi
echo "[INFO] Building docker" | tee -a deploy.log
echo "docker build -t pat-$target:$max_version --build-arg VERSION=$max_version ."
docker build -t pat-$target:$max_version --build-arg VERSION=$max_version .
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to build docker" | tee -a deploy.log
    exit 1
fi

# Constructing new $target.yaml by replacing {VERSION} with $max_version
echo "[INFO] Constructing new $target.yaml" | tee -a deploy.log
touch $target.yaml
mv $target.yaml $target.yaml.old
cat $target.template.yaml | sed "s/{VERSION}/$max_version/g" > $target.yaml

# Reload if $target.yaml is different from $target.yaml.old
if cmp -s $target.yaml $target.yaml.old; then
    echo "[INFO] No change in $target.yaml" | tee -a deploy.log
    echo "[WARNING] Deleting previous deployment" | tee -a deploy.log
    echo "sudo kubectl delete -f $target.yaml" | tee -a deploy.log
    sudo kubectl delete -f $target.yaml
fi
rm $target.yaml.old

# Apply $target.yaml as new deployment
echo "[INFO] Applying $target.yaml" | tee -a deploy.log
echo sudo kubectl apply -f $target.yaml | tee -a deploy.log
sudo kubectl apply -f $target.yaml
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to apply $target.yaml" | tee -a deploy.log
    exit 1
fi

# Update version
echo "[INFO] Completed deployment of $max_version" | tee -a deploy.log
echo "[INFO] Updated version to $max_version" | tee -a deploy.log
echo $max_version > version

echo "" | tee -a deploy.log
