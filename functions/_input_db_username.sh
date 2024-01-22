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
    if [ -n "$psqluser" ]; then
      break
    else
      whiptail --msgbox "   Please enter a value" 7 30
    fi
  done
  # Replaces 'spaces' with 'hyphens'
  psqluser=$(echo "$psqluser" | tr ' ' '-')

  # Export the variable for use by child scripts
  export psqluser
}

export -f _input_db_username

