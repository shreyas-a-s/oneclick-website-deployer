#!/usr/bin/env bash

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

if command -v apt-get > /dev/null; then # Install for debian-based distros
  xargs -a "../components/dependencies.txt" sudo apt-get install -y
fi

