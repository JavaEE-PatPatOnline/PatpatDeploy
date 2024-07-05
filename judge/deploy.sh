#!/bin/bash

#
# PatJudge deploy script
#

echo "===== `date`" | tee -a deploy.log

# get all files in target/
files=`ls target/`

# iterate all files and get the file with the largest version
max_version=0
max_file=""
for file in $files; do
    version=`echo $file | grep -oE "[0-9]+\.[0-9]+\.[0-9]+"`
    if [ -z $version ]; then
        continue
    fi
    if [ $version \> $max_version ]; then
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

# Clear assets/ and copy the new file
echo "[INFO] Initializing assets" | tee -a deploy.log
rm -rf assets/
mkdir assets/
cp "target/$max_file" -t assets/

# Build docker
echo "[INFO] Building docker" | tee -a deploy.log
echo "docker build -t pat-judge:$max_version --build-arg VERSION=$max_version ."
docker build -t pat-judge:$max_version --build-arg VERSION=$max_version .

# Constructing new judge.yaml by replacing {VERSION} with $max_version
echo "Constructing new judge.yaml" | tee -a deploy.log
touch judge.yaml
mv judge.yaml judge.yaml.old
cat judge.template.yaml | sed "s/{VERSION}/$max_version/g" > judge.yaml

# Reload if judge.yaml is different from judge.yaml.old
if cmp -s judge.yaml judge.yaml.old; then
    echo "[INFO] No change in judge.yaml" | tee -a deploy.log
    echo "[WARNING] Deleting previous deployment" | tee -a deploy.log
    echo "sudo kubectl delete -f judge.yaml" | tee -a deploy.log
    sudo kubectl delete -f judge.yaml
fi
rm judge.yaml.old

# Apply judge.yaml as new deployment
echo "[INFO] Applying judge.yaml" | tee -a deploy.log
echo sudo kubectl apply -f judge.yaml | tee -a deploy.log
sudo kubectl apply -f judge.yaml

# Update version
echo "[INFO] Completed deployment of $max_version" | tee -a deploy.log
echo "[INFO] Updated version to $max_version" | tee -a deploy.log
echo $max_version > version

echo "" | tee -a deploy.log
