#!/usr/bin/env bash

while true; do
  # Read memory to allocate
  . ./scripts/pre-deployment/components/get-memory-limit.sh

  # Read database credentials
  . ./scripts/pre-deployment/components/get-db-creds.sh

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

