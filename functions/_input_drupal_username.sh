#!/usr/bin/env bash

function _input_drupal_username {
  if command -v whiptail > /dev/null; then
    drupal_user=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter the username to be used for drupal:\
      \n         (Press ENTER to continue)" \
      12 48 \
      3>&1 1>&2 2>&3)
  else
    printf "\nEnter the username to be used for drupal: "
    read -r drupal_user
  fi
  drupal_user=$(echo "$drupal_user" | tr ' ' '-') # Repace 'spaces' with 'hyphens'
  export drupal_user # Export smausername to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_username

