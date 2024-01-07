#!/usr/bin/env bash

function _input_drupal_mail {
  if command -v whiptail > /dev/null; then
    drupal_mail=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter a mail to be added to drupal website:\
      \n         (Press ENTER to continue)" \
      11 47 \
      "$drupal_mail" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  else
    printf "\nEnter a mail to be added to drupal website: "
    read -r drupal_mail
  fi
  export drupal_mail # Export smausername to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_mail

