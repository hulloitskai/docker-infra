#!/usr/bin/env bash

## Source this script (. ./machine.env.sh) to configure Docker for access to
## this machine.

set -e # enable strict error-checking

NAME="$(./scripts/tfparse.sh name)"
eval $(docker-machine env $NAME)
echo "Docker environment configured for machine \"$NAME\"."

set +e

## Customize $PS1.
export PS1_BAK="$PS1"
export PS1="($NAME) $PS1"
