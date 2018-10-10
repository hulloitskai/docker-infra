#!/bin/bash

## chstat shows file/dir permissions in numerical form.
if [[ $(uname -s) == "Darwin" ]]
then alias chstat="stat -f '%A'"
else alias chstat="stat --format '%a'"
fi

## Tiny shortcuts:
alias c="clear"
alias l="ls"
alias e="exit"

## wkb changes the working directory to $WORKBENCH.
alias wkb="cd $WORKBENCH"


## Files:
## ll shows owner and permissions for a file/dir.
if [[ $(type -t ll) == "" ]]; then alias ll="ls -l"; fi

## la lists all files (including hidden ones).
if [[ $(type -t la) == "" ]]; then alias la="ls -a"; fi


## Github:
## git-prune-local prunes local branches that have been merged into remote.
alias git-prune-local="git branch --merged | \
  tail -n +2 >/tmp/merged-branches && \
  vi /tmp/merged-branches && xargs git branch -d < \
  /tmp/merged-branches && rm /tmp/merged-branches"

## git-discard-local discards local changes in favor of remote ones.
alias git-discard-local="git fetch --all && git reset --hard @{u}"

## git-cma commits all changes, including changes from newly created files.
alias git-cma="git add -A && git commit"

## Docker:
alias dk="docker"

## dk-prunei prunes docker images.
alias dk-prunei="dk image prune"

## dk-prunev prunes docker volumes.
alias dk-prunev="dk volume prune"

## dk-prune prunes docker containers.
alias dk-prune="dk container prune"

# dk-v lists docker volumes.
alias dk-v="dk volume"

## dk-i lists docker images.
alias dk-i="dk images"
