#!/usr/bin/env bash

function _input_db_username {
  while true; do
    psqluser=$(whiptail --title "USER INPUT" --inputbox \
      "\nEnter username for a new database user:\n\n       (Press ENTER to continue)" \
      11 44 \
      "$psqluser" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi

    # Check if input is empty
    if _is_variable_nonempty "$psqluser"; then
      break
    fi

    # Check if directory name is valid
    if _is_username_valid "$psqluser"; then
      break
    else
      whiptail --msgbox "Username is invalid. It should only contain alphabets, numbers and underscores & must start with an alphabet." 9 47
    fi
  done

  # Export the variable for use by child scripts
  export psqluser
}

export -f _input_db_username

