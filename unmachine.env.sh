#!/usr/bin/env bash

## Source this script (. ./unmachine.env.sh) to reset Docker to use the local
## machine's daemon (as opposed to the remote Docker Machine daemon).

eval $(docker-machine env --unset)
