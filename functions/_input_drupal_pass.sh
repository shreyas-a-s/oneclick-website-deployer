#!/usr/bin/env bash

function __input_drupal_pass {
  if command -v whiptail > /dev/null; then
    drupal_pass=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter a password for the new drupal user:\
      \n        (Press ENTER to continue)" \
      11 45 \
      "$drupal_pass" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  else
    printf "\nEnter a password for the new drupal user: "
    read -r drupal_pass
  fi
  export drupal_pass # Export smausername to be used by child scripts
}

# Export the function to be used by child scripts
export -f __input_drupal_pass

