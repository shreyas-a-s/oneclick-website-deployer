#!/usr/bin/env bash

function _is_internet_available {
  printf "Checking internet connectivity. Please wait.."
  if ! ping -c 3 1.1.1.1 &> /dev/null; then
    if command -v whiptail > /dev/null; then
      whiptail --title "WARNING" --msgbox "\nUnable to connect to internet. Check and make sure you are connected to internet before executing the script.\n" 9 44
    else
      printf "\nUnable to connect to internet. Check and make sure you are connected to internet before executing the script.\n"
    fi
    exit 1
  fi
}

export -f _is_internet_available

