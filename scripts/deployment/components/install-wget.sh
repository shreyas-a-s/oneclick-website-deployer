#!/usr/bin/env bash

if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get install -y wget
fi

