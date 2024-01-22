#!/usr/bin/env bash

function _is_internet_available {
  printf "Checking internet connectivity. Please wait.."
  if ! curl -Is https://www.google.com | head -n 1 | grep -q '200' > /dev/null; then
    _set_whiptail_colors_bg_red # Change whiptail bg color to RED
    whiptail --title "WARNING" --msgbox \
      "Unable to connect to internet. Check and make sure you are connected to internet before executing the script.\
      \n\n         (Press ENTER to exit)" \
      11 44
    _set_whiptail_colors_default # Restore default colorscheme
    printf "\n"
    exit 1
  fi
}

export -f _is_internet_available

