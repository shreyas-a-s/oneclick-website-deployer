#!/usr/bin/env bash

function _input_db_name {
  if command -v whiptail > /dev/null; then # Whiptail is installed
    psqldb=$(whiptail --title "USER INPUT" --inputbox \
      "\nEnter the name for a new database for our website:\
      \n\n         (Press ENTER to continue)" \
      12 47 \
      "$psqldb" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  else # Whiptail is not installed
    read -r -p "Enter the name for a new database for our website: " psqldb
  fi

  # Replaces 'spaces' with 'hyphens'
  psqldb=$(echo "$psqldb" | tr ' ' '-')

  # Export variable for use by child scripts
  export psqldb
}

export -f _input_db_name

