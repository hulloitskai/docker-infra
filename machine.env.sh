#!/usr/bin/env bash

## Source this script (. ./machine.env.sh) to configure Docker for access to
## this machine.

NAME="$(./scripts/tfparse.sh name)"
eval $(docker-machine env $NAME)
