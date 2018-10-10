#!/bin/bash

## transfer uploads file $1 using transfer.sh.
transfer() {
  cmd="curl --upload-file $1 https://transfer.sh/${1##*/}"

  if [[ $(uname -s) == "Darwin" ]]; then $cmd | pbcopy
  else $cmd
  fi
}

## trash moves files/dirs to $HOME/.Trash.
trash () {
  mkdir -p ~/.Trash

  for file in $@; do
    mv $file ~/.Trash/$file
  done
}
