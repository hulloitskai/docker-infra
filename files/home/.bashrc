## If not running interactively, don't do anything:
[ "$-" == "*" ] && return

## Configure WORKBENCH and EDITOR.
export EDITOR=vi

## Import custom aliases and functions.
if [ -f $HOME/.bash_imports ]; then . $HOME/.bash_imports; fi

## Enable VIM mode, custom colors, styling, and PS1.
set -o vi
export CLICOLOR=1
PS1='\[\e[1;32m\]\u@\h\[\e[23m\]: \[\e[34m\]\W \[\e[34m\]\$\[\e[0m\] '
