#!/usr/bin/env bash

function _input_drupal_username {
  while true; do
    drupal_user=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter the username to be used for drupal:\
      \n         (Press ENTER to continue)" \
      11 45 \
      "$drupal_user" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi

    # Check if input is empty
    if _is_variable_nonempty "$drupal_user"; then
      break
    fi

    # Check if directory name is valid
    if _is_username_valid "$drupal_user"; then
      break
    else
      whiptail --msgbox "Username is invalid. It should only contain alphabets, numbers and underscores & must start with an alphabet." 9 47
    fi
  done

  export drupal_user # Export drupal username to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_username

