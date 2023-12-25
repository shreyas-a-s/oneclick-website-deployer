#!/usr/bin/env bash

while true; do
  # Read memory to allocate
  memory_limit_title="User Input"
  memory_limit_msg=""
  total_memory="$(command free --mega | awk 'NR==2{print $2}')"
  while true; do
    memorylimit=$(whiptail --title "$memory_limit_title" --inputbox "\n$memory_limit_msg""How much memory to allocate to the website (in MB)? " 11 46 "$memorylimit" 3>&1 1>&2 2>&3) 
    if ! [ "$memorylimit" -eq "$memorylimit" ] &> /dev/null; then
      memory_limit_title="ERROR"
      memory_limit_msg="Only integer values are accepted.\n"
      continue
    elif [ "$memorylimit" -ge "$total_memory" ]; then
      memory_limit_title="ERROR"
      memory_limit_msg="Value is Larger than Total RAM ($total_memory""MB).\n"
      continue
    else
      break
    fi
  done
  export memorylimit

  # Read database name
  psqldb=$(whiptail --title "User Input" --inputbox "\nEnter the name for a new database for our website: " 10 47 "$psqldb" 3>&1 1>&2 2>&3)
  export psqldb

  # Read database username
  psqluser=$(whiptail --title "User Input" --inputbox "\nEnter a new username (role) for postgres: " 9 45 "$psqluser" 3>&1 1>&2 2>&3)
  export psqluser

  # Read database password
  PGPASSWORD=$(whiptail --title "User Input" --passwordbox "\nEnter a password for the new user: " 9 38 "$PGPASSWORD" 3>&1 1>&2 2>&3)
  HIDDEN_PGPASSWORD=$(for _ in $(seq $(printf "$PGPASSWORD" | wc -m)); do printf "*"; done) # Hide PGPASSWORD by replacing chars with *
  export PGPASSWORD

  # Read drupal directory name
  drupalsitedir=$(whiptail --title "User Input" --inputbox "\nEnter the name of the directory to which drupal website needs to be installed: " 10 45 "$drupalsitedir" 3>&1 1>&2 2>&3)
  export drupalsitedir

  # Give option to edit user input
  if (whiptail --defaultno --yesno "Do you want to edit the data?\n\nMemory Limit: $memorylimit""MB\nDatabase Name: $psqldb\nDatabase User: $psqluser\nDatabase Password: $HIDDEN_PGPASSWORD\nDrupal Website Directory: $drupalsitedir" 14 50) then
    continue
  else
    break
  fi
done

