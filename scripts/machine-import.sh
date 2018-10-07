#!/usr/bin/env bash

## Usage: machine-import <name>
machine-import() {
  if [ $# -lt 1 ]; then
    echo "Usage: machine-import <name>" >&2
    exit 1
  fi

  echo "Importing machine configuration to repository..."

  ## Figure out machine storage directory.
  local MCHDIR="$HOME/.docker/machine"
  if [ -n "$MACHINE_STORAGE_DIR" ]; then
    MCHDIR="${MACHINE_STORAGE_DIR%/}" # strip trailing slashes
  fi

  ## Make a machine storage directory in the repository.
  mkdir -p machine/certs

  ## Copy data over to machine/.
  set -e
  cp -r "$MCHDIR/machines/$1/" machine/
  cp -r "$MCHDIR/certs/" machine/certs/
  set +e

  echo "Abstracting configuration directories..."

  ## Edit config.json with placeholder directory values.
  set -e
  local MCHPAT="$(sed -e 's/\//\\\//g' <<< "$MCHDIR" | sed -e 's/\./\\./g')"
  local CONFIG="machine/config.json"
  sed -e "s/$MCHPAT/\$MCHDIR/g" "$CONFIG" > "$CONFIG.tmp"
  sed -e "s/\\\$MCHDIR\/certs/\$MCHDIR\/machines\/$1\/certs/g" "$CONFIG.tmp" \
    > "$CONFIG"
  rm "$CONFIG.tmp"
  set +e

  echo "Machine import successful."
}

machine-import $@
