#!/usr/bin/env bash

if command -v whiptail > /dev/null; then
  # Read database name
  psqldb=$(whiptail --title "User Input" --inputbox "\nEnter the name for a new database for our website: " 10 47 "$psqldb" 3>&1 1>&2 2>&3)
  export psqldb
  # Read database username
  psqluser=$(whiptail --title "User Input" --inputbox "\nEnter a new username (role) for postgres: " 9 45 "$psqluser" 3>&1 1>&2 2>&3)
  export psqluser
  # Read database password
  PGPASSWORD=$(whiptail --title "User Input" --passwordbox "\nEnter a password for the new user: " 9 38 "$PGPASSWORD" 3>&1 1>&2 2>&3)
else
  # Read database name
  read -r -p "Enter the name for a new database for our website: " psqldb
  # Read database username
  read -r -p "Enter a new username (role) for postgres: " psqluser
  # Read database password
  read -r -p "Enter a password for the new user: " PGPASSWORD
fi

# Hide PGPASSWORD by replacing characters with *
HIDDEN_PGPASSWORD=$(for _ in $(seq "$(printf "%s" "$PGPASSWORD" | wc -m)"); do printf "*"; done)
export HIDDEN_PGPASSWORD

# Need to export postgresql password so that subsequent psql commands can be run password-less
export PGPASSWORD

