#!/usr/bin/env bash

## tfparse extracts data from "infra.auto.tfvars".
##
## The first argument specifies which key to extract (i.e. name, domain).
tfparse() {
  egrep "$1.*=" infra.auto.tfvars 2> /dev/null \
    | awk '{print $3}' \
    | cut -d '"' -f 2
}

tfparse $@
