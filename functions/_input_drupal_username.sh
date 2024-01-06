#!/usr/bin/env bash

function _input_drupal_username {
  drupal_user=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
    "\nEnter the username to be used for drupal:\
    \n         (Press ENTER to continue)" \
    12 48 \
    3>&1 1>&2 2>&3)
  export drupal_user # Export smausername to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_username

