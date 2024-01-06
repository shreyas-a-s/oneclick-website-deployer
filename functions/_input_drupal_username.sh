#!/usr/bin/env bash

# Read and test site maintenance account username is valid
function _input_drupal_username {
  drupal_user=$(whiptail --title "SITE MAINTENANCE ACCOUNT CREDENTIALS" --inputbox \
    "\nEnter the site maintenance account username that you've given to the website:\
    \n\n         (Press ENTER to continue)" \
    12 48 \
    3>&1 1>&2 2>&3)
  export drupal_user # Export smausername to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_username

