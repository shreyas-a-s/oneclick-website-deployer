#!/usr/bin/env bash

function _input_drupal_mail {
  while true; do
    drupal_mail=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter a mail to be added to drupal website:\
      \n         (Press ENTER to continue)" \
      12 47 \
      "$drupal_mail" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi

    # Check if email is valid
    if _is_email_valid "$drupal_mail"; then
      break
    else
      whiptail --msgbox " Email address invalid" 7 28
      continue
    fi
  done
  export drupal_mail # Export drupal email to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_mail

