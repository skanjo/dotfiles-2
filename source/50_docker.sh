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

# See https://github.com/spotify/docker-gc.
function docker-gc () {
    FORCE_CONTAINER_REMOVAL=1 \
    FORCE_IMAGE_REMOVAL=1 \
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock spotify/docker-gc
}
