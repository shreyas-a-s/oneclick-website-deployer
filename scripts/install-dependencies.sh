#!/usr/bin/env bash

if command -v apt-get > /dev/null; then # Install for debian-based distros
  xargs -a "dependencies.txt" sudo apt-get install -y
fi

