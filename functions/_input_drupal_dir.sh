#!/usr/bin/env bash

function _input_drupal_dir {
  if command -v whiptail > /dev/null; then
    drupalsitedir=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter the name of the directory to which\n  drupal website needs to be installed:\
      \n        (Press ENTER to continue)" \
      12 45 \
      "$drupalsitedir" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  else
    printf "Enter the name of the directory to which drupal website needs to be installed: "
    read -r drupalsitedir
  fi
  drupalsitedir=$(echo "$drupalsitedir" | tr ' ' '-') # Replaces 'spaces' with 'hyphens'
  export drupalsitedir
}

export -f _input_drupal_dir

