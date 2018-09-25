#!/usr/bin/env bash

## Source this script (. ./machine.env.sh) to configure Docker for access to
## this machine.

NAME="$(basename $(pwd))"

eval $(docker-machine env $NAME)
