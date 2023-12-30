#!/usr/bin/env bash

function _is_internet_available {
  printf "Checking internet connectivity. Please wait.."
  if ! ping -c 3 1.1.1.1 &> /dev/null; then
    if command -v whiptail > /dev/null; then
      _set_whiptail_colors_red_bg # Change whiptail bg color to RED
      whiptail --title "WARNING" --msgbox \
        "Unable to connect to internet. Check and make sure you are connected to internet before executing the script.\
        \n\n         (Press ENTER to exit)" \
        11 44
      _set_whiptail_colors_default # Restore default colorscheme
    else
      printf "\nUnable to connect to internet. Check and make sure you are connected to internet before executing the script.\n"
    fi
    exit 1
  fi
}

export -f _is_internet_available

