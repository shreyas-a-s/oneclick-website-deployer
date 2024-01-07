#!/usr/bin/env bash

function _input_drupal_site_name {
  if command -v whiptail > /dev/null; then
    drupal_site_name=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter a Name for your Drupal website:\
      \n      (Press ENTER to continue)" \
      11 41 \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  else
    printf "\nEnter a Name for your Drupal website: "
    read -r drupal_site_name
  fi
  export drupal_site_name # Export smausername to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_site_name

