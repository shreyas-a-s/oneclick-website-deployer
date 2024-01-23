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
    _is_email_valid "$drupal_mail"

    # Check the return value
    return_value=$?

    # Act upon return value
    if [ $return_value = 1 ]; then
      whiptail --msgbox " Email address invalid" 7 28
      continue
    else
      break
    fi
  done
  export drupal_mail # Export drupal email to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_mail

