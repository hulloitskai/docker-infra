#!/usr/bin/env bash

## Source this script (. ./unmachine.env.sh) to reset Docker to use the local
## machine's daemon (as opposed to the remote Docker Machine daemon).

set -e # enable strict error-checking

eval $(docker-machine env --unset)
echo "Docker environment cleared (now uses local machine)."

set +e

## Revert to original $PS1
export PS1="$PS1_BAK"
unset PS1_BAK
