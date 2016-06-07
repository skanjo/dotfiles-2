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
if [[ -e ~/.ssh/known_hosts ]]; then
    complete -o default -W "$(echo "$(cat ~/.ssh/known_hosts | cut -d ' ' -f 1 | tr ',' "\n" | uniq)";)" ssh scp sftp
fi

# Disable ansible cows }:]
export ANSIBLE_NOCOWS=1

 # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Add RVM to PATH for scripting
if [[ -x ~/.rvm/bin ]]; then
  export PATH="$PATH:$HOME/.rvm/bin"
fi
