#!/usr/bin/env bash

PAT="$1.*="
egrep $PAT platform.auto.tfvars 2> /dev/null | awk '{print $3}' | cut -d '"' -f 2
