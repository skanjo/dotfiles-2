#!/bin/bash

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Configure the terminal for the default docker machine.
function __docker_configure () {
    eval "$(docker-machine env default)"
}

# Auto configure the default docker machine if it's running.
if [[ "$(docker-machine ls -q --filter "state=Running")" == "default" ]]; then
    __docker_configure
fi

# Start the docker machine and configure the terminal.
function docker-up () {
    docker-machine start default &> /dev/null
    __docker_configure
}

# Use `docker-cleanup --dry-run` to see what would be deleted.
function docker-cleanup () {
  EXITED=$(docker ps -q -f status=exited)
  DANGLING=$(docker images -q -f "dangling=true")

  if [ "$1" == "--dry-run" ]; then
    echo "==> Would stop containers:"
    echo $EXITED
    echo "==> And images:"
    echo $DANGLING
  else
    if [ -n "$EXITED" ]; then
      docker rm -f $EXITED
    else
      echo "No containers to remove."
    fi
    if [ -n "$DANGLING" ]; then
      docker rmi -f $DANGLING
    else
      echo "No images to remove."
    fi
  fi
}
