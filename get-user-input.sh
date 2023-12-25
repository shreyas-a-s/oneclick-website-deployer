#!/usr/bin/env bash

while true; do

    # Read memory to allocate
    memorylimit=$(whiptail --title "User Input" --inputbox "\nHow much memory to allocate to the website (in MB)? " 10 46 "$memorylimit" 3>&1 1>&2 2>&3)
    export memorylimit

    # Read name for PostgreSQL database
    psqldb=$(whiptail --title "User Input" --inputbox "\nEnter the name for a new database for our website: " 10 47 "$psqldb" 3>&1 1>&2 2>&3)
    export psqldb

    # Read PostgreSQL username
    psqluser=$(whiptail --title "User Input" --inputbox "\nEnter a new username (role) for postgres: " 9 45 "$psqluser" 3>&1 1>&2 2>&3)
    export psqluser

    # Read PostgreSQL password
    PGPASSWORD=$(whiptail --title "User Input" --passwordbox "\nEnter a password for the new user: " 9 38 "$PGPASSWORD" 3>&1 1>&2 2>&3)
    HIDDEN_PGPASSWORD=$(for i in $(seq $(echo $PGPASSWORD | wc -m)); do printf "*"; done) # Hide password with asteriscks
    export PGPASSWORD

    # Read name of directory to install drupal
    drupalsitedir=$(whiptail --title "User Input" --inputbox "\nEnter the name of the directory to which drupal website needs to be installed: " 10 45 "$drupalsitedir" 3>&1 1>&2 2>&3)
    export drupalsitedir

    # Check the exit status
    if [ $? -eq 0 ]; then
        # Ask the user if they want to change the data
        if (whiptail --defaultno --yesno "Do you want to edit the data?\n\nMemory Limit: $memorylimit\nDatabase Name: $psqldb\nDatabase User: $psqluser\nDatabase Password: $HIDDEN_PGPASSWORD\nDrupal Website Directory: $drupalsitedir" 14 50) then
            # User chose to change the data
            continue
        else
            # User accepted the data and wants to proceed
            break
        fi
    else
        # User canceled or closed the dialog
        echo "User canceled."
        exit 1
    fi
done

