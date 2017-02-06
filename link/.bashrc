#!/bin/bash
#
# Source the dotfile setup.

# Where the magic happens.
export DOTFILES=~/.dotfiles

# Add any binaries into the path.
PATH=$DOTFILES/bin:$PATH
export PATH

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"
