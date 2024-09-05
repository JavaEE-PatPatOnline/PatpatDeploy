#!/bin/bash

# Initialize patpat.conf

base_dir=$(dirname $(pwd))
cat patpat.template.conf | sed "s|{BASE}|$base_dir|g" > patpat.conf
echo "patpat.conf initialized"
