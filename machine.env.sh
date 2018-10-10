#!/usr/bin/env bash

## Source this script (. ./machine.env.sh) to configure Docker for access to
## this machine. Run `unmachine` afterwards to revert Docker to use the local
## machine.

set -e # enable strict error-checking

NAME="$(./scripts/tfparse.sh name)"
eval $(docker-machine env $NAME)
echo "Docker environment configured for machine \"$NAME\"."

set +e

## Customize $PS1.
export PS1_BAK="$PS1"
export PS1="($NAME) $PS1"


## Run unmachine to revert to remove environment variables set by this script.
unmachine() {
  set -e # enable strict error-checking

  eval $(docker-machine env --unset)
  echo "Docker environment cleared (now uses local machine)."

  set +e

  ## Revert to original $PS1
  export PS1="$PS1_BAK"
  unset PS1_BAK
  unset -f unmachine
}
