#!/usr/bin/env bash

if command -v whiptail > /dev/null; then # Display 'About Us' using whiptail
  if [ -f ./about-us.txt ]; then # Checking is about.txt is present
    whiptail --title "about-us The Script" --textbox --ok-button "Continue" ./about.txt 20 86
  fi
else # Display 'About Us' using command-line
  if [ -f ./about-us.txt ]; then # Checking is about.txt is present
    cat ./about-us.txt
  fi
fi

