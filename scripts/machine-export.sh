#!/usr/bin/env bash

## Usage: machine-export <name>
machine-export() {
  if [ $# -lt 1 ]; then
    echo "Usage: machine-export <name>" >&2
    exit 1
  fi

  echo "Exporting machine configuration to host..."

  ## Figure out machine storage directory.
  local MCHDIR="$HOME/.docker/machine"
  if [ -n "$MACHINE_STORAGE_DIR" ]; then
    MCHDIR="${MACHINE_STORAGE_DIR%/}" # strip trailing slashes
  fi

  ## Make a machine storage directory on the host machine.
  mkdir -p "$MCHDIR"

  ## Copy machine data.
  set -e
  cp -r machine/ $MCHDIR/machines/$1/
  set +e

  echo "Re-constructing configuration directories..."

  ## Edit config.json with placeholder directory values.
  set -e
  local MCHPAT="$(sed -e 's/\//\\\//g' <<< "$MCHDIR")"
  local CONFIG="$MCHDIR/machines/$1/config.json"
  sed -e "s/\\\$MCHDIR/$MCHPAT/g" < "$CONFIG" > "$CONFIG.tmp"
  mv "$CONFIG.tmp" "$CONFIG"
  set +e

  echo "Machine export successful."
}

machine-export $@
