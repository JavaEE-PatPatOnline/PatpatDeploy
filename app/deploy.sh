#!/bin/bash


echo "===== `date`" | tee -a deploy.log

if [ -z "$1" ]; then
    echo "[ERROR] Missing source directory" | tee -a deploy.log
    echo "" | tee -a deploy.log
    exit 1
fi
if [ -z "$2" ]; then
    echo "[ERROR] Missing destination directory" | tee -a deploy.log
    echo "" | tee -a deploy.log
    exit 1
fi

source_dir=$1
dest_dir=$2

echo "[INFO] Checking existence of '$source_dir'" | tee -a deploy.log
if [ ! -d "$source_dir" ]; then
    echo "[ERROR] Directory '$source_dir' not found" | tee -a deploy.log
    exit 1
fi

echo "[WARNING] Cleaning up old deployment '$dest_dir'" | tee -a deploy.log
rm -rf "$dest_dir"

echo "[INFO] Deploying new version" | tee -a deploy.log
mv "$source_dir" "$dest_dir"

echo "[INFO] Deployment successful" | tee -a deploy.log
echo "" | tee -a deploy.log
