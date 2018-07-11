#!/bin/bash

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Case insensitive completion.
# bind "set completion-ignore-case on"

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar () {
  echo -n $'\e]0;'"$*"$'\a'
}

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# SSH auto-completion based on entries in known_hosts.
if [[ -f ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cut -d ' ' -f 1 < ~/.ssh/known_hosts | tr ',' "\\n" | uniq)" ssh scp sftp
fi

# Disable ansible cows }:]
export ANSIBLE_NOCOWS=1

# RVM support.
[[ -d ~/.rvm ]] && source "$HOME/.rvm/scripts/rvm" && export PATH="$HOME/.rvm/bin:$PATH"

# Load node version manager
export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" # This loads nvm

# Include node_modules/.bin in the path.
export PATH="node_modules/.bin:$PATH"

# Rust Cargo support.
[[ -d ~/.cargo/bin ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Yarn support.
[[ -d ~/.yarn ]] && export PATH="$(yarn global bin):$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Go lang development support.
export GOPATH="$HOME/Repositories/go"
export PATH="$GOPATH/bin:$PATH"
