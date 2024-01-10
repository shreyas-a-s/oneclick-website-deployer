#!/usr/bin/env bash

function _input_drupal_dir {
  while true; do
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

    # Check if input is empty
    if [ -n "$drupalsitedir" ]; then
      break
    else
      whiptail --msgbox "   Please enter a value" 7 30
    fi
  done

  drupalsitedir=$(echo "$drupalsitedir" | tr ' ' '-') # Replaces 'spaces' with 'hyphens'
  export drupalsitedir
}

export -f _input_drupal_dir

