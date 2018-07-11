#!/bin/bash

export VAULT_ADDR=https://vault.in.ft.com
export VAULT_AUTH_METHOD=github

if is_osx; then
  export VAULT_AUTH_GITHUB_TOKEN="$(security find-generic-password -a $USER -s 'FT Vault' -w)"
fi

function vault () {
  # Use exported login method if available.
  if [[ $1 == login ]] && [[ -n $VAULT_AUTH_METHOD ]]; then
    command vault login --method $VAULT_AUTH_METHOD;
    return 0;
  fi

  # Run the normal vault command.
  command vault "$@"

  # If it was a write, delete it from history.
  if [[ $1 == write ]]; then history -d $((HISTCMD-1)) &> /dev/null; fi
}

function __vault_mounts() {
  (
    set -euo pipefail
    if ! vault mounts 2> /dev/null | awk 'NR > 1 {print $1}'; then
      echo "secret"
    fi
  )
}

function __vault_complete() {
  local VAULT_COMMANDS="$(vault 2>&1 | egrep '^ +' | awk '{print $1}')"

  local cur
  local prev

  if [ $COMP_CWORD -gt 0 ]; then
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
  fi

  local line=${COMP_LINE}

  if [[ $prev =~ ^(policies|policy-write|policy-delete) ]]; then
    local policies=$(vault policies 2> /dev/null)
    COMPREPLY=($(compgen -W "$policies" -- $cur))
  elif [ "$(echo $line | wc -w)" -le 2 ]; then
    if [[ "$line" =~ ^vault\ (read|write|delete|list)\ $ ]]; then
      COMPREPLY=($(compgen -W "$(__vault_mounts)" -- ''))
    else
      COMPREPLY=($(compgen -W "$VAULT_COMMANDS" -- $cur))
    fi
  elif [[ "$line" =~ ^vault\ (read|write|delete|list)\ (.*)$ ]]; then
    path=${BASH_REMATCH[2]}
    if [[ "$path" =~ ^([^ ]+)/([^ /]*)$ ]]; then
      list=$(vault list -format=yaml ${BASH_REMATCH[1]} 2> /dev/null | awk '{ print $2 }')
      COMPREPLY=($(compgen -W "$list" -P "${BASH_REMATCH[1]}/" -- ${BASH_REMATCH[2]}))
    else
      COMPREPLY=($(compgen -W "$(__vault_mounts)" -- $path))
    fi
  fi
}

complete -o default -o nospace -F __vault_complete vault
