#!/usr/bin/env bash

# Checking if whiptail is already installed
if command -v whiptail > /dev/null; then
  printf "Whiptail is already installed\n"
  exit 1
fi

if command -v apt-get > /dev/null; then # Install for debian-based linux distros
  sudo apt-get install -y whiptail
fi

if command -v yum > /dev/null; then # Install for older RHEL-based linux distros
  sudo yum install -y newt
fi

if command -v dnf > /dev/null; then # Install for newer RHEL-based distros
  sudo dnf install -y newt
fi

