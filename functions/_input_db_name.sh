#!/usr/bin/env bash

function _input_db_name {
  while true; do
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

    # Check if input is empty
    if [ -n "$psqldb" ]; then
      break
    else
      whiptail --msgbox "   Please enter a value" 7 30
    fi
  done

  # Check if database name is valid
  _is_db_name_valid "$psqldb"

  # Export variable for use by child scripts
  export psqldb
}

export -f _input_db_name

