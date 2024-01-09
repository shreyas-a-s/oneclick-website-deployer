#!/usr/bin/env bash

function _input_db_username {
  if command -v whiptail > /dev/null; then
    psqluser=$(whiptail --title "USER INPUT" --inputbox \
      "\nEnter username for a new database user:\n\n       (Press ENTER to continue)" \
      11 44 \
      "$psqluser" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  else
    read -r -p "Enter a new username (role) for postgres: " psqluser
  fi

  # Replaces 'spaces' with 'hyphens'
  psqluser=$(echo "$psqluser" | tr ' ' '-')

  # Export the variable for use by child scripts
  export psqluser
}

export -f _input_db_username

