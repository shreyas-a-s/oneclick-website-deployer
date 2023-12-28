#!/usr/bin/env bash

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

if command -v whiptail > /dev/null; then # Display 'About Us' using whiptail
  if [ -f ./about-us.txt ]; then # Checking is about.txt is present
    whiptail --title "about-us The Script" --textbox --ok-button "Continue" ./about.txt 20 86
  else
    echo "about.txt is not found"
  fi
else # Display 'About Us' using command-line
  if [ -f ./about-us.txt ]; then # Checking is about.txt is present
    cat ./about-us.txt
  else
    echo "about.txt is not found"
  fi
fi

