#!/bin/bash
#
# Source the dotfile setup.

# Where the magic happens.
export DOTFILES=~/.dotfiles

# Source all files in "source/".
function src {
  for file in $DOTFILES/source/*; do
    source "$file"
  done
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src
