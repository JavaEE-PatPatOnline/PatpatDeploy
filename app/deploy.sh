#!/bin/bash

echo "===== `date`" | tee -a deploy.log

echo "[INFO] Checking dist/ directory" | tee -a deploy.log
if [ ! -d "dist" ]; then
    echo "[ERROR] dist/ directory not found" | tee -a deploy.log
    exit 1
fi

echo "[WARNING] Cleaning up old deployment" | tee -a deploy.log
rm -rf patpat

echo "[INFO] Deploying new version" | tee -a deploy.log
mv dist patpat

echo "[INFO] Deployment successful" | tee -a deploy.log
echo "" | tee -a deploy.log
