#!/usr/bin/env bash

function _input_drupal_dir {
  if command -v whiptail > /dev/null; then
    drupalsitedir=$(whiptail --title "USER INPUT" --inputbox \
      "\nEnter the name of the directory to which\n  drupal website needs to be installed:\
      \n        (Press ENTER to continue)" \
      12 45 \
      "$drupalsitedir" \
      3>&1 1>&2 2>&3)
  else
    printf "Enter the name of the directory to which drupal website needs to be installed: "
    read -r drupalsitedir
  fi
  export drupalsitedir
}

export -f _input_drupal_dir

