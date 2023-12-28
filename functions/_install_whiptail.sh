#!/usr/bin/env bash

function _install_whiptail {
  if command -v whiptail > /dev/null; then # Do nothing if whiptail is already installed
    printf "\nWhiptail is already installed\n"
  else # Install whiptail
    if command -v apt-get > /dev/null; then # Install for debian-based linux distros
      sudo apt-get install -y whiptail
    elif command -v dnf > /dev/null; then # Install for newer RHEL-based linux distros
      sudo dnf install -y newt
    elif command -v yum > /dev/null; then # Install for older RHEL-based linux distros
      sudo yum install -y newt
    fi
  fi
}

export -f _install_whiptail

