#!/bin/bash

command=${1:?"Usage: $0 <command>"}
shift
./scripts/$command.sh $@
