#!/bin/bash

export VAULT_ADDR=https://vault.in.ft.com
export VAULT_AUTH_GITHUB_TOKEN="$(security find-generic-password -a ${USER} -s vault -w)"

function vault () {
  command vault "$@"
  history -d $((HISTCMD-1))
}
