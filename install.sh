#!/bin/bash

echo -e "---------------------------------------------------------------------------------------------------"
echo "██╗    ██╗███████╗██████╗ ███████╗██╗████████╗███████╗ ████████╗██████╗ ██╗██████╗  █████╗ ██╗"
echo "██║    ██║██╔════╝██╔══██╗██╔════╝██║╚══██╔══╝██╔════╝ ╚══██╔══╝██╔══██╗██║██╔══██╗██╔══██╗██║"
echo "██║ █╗ ██║█████╗  ██████╔╝███████╗██║   ██║   █████╗█████╗██║   ██████╔╝██║██████╔╝███████║██║"
echo "██║███╗██║██╔══╝  ██╔══██╗╚════██║██║   ██║   ██╔══╝╚════╝██║   ██╔══██╗██║██╔═══╝ ██╔══██║██║"
echo "╚███╔███╔╝███████╗██████╔╝███████║██║   ██║   ███████╗    ██║   ██║  ██║██║██║     ██║  ██║███████╗"
echo " ╚══╝╚══╝ ╚══════╝╚═════╝ ╚══════╝╚═╝   ╚═╝   ╚══════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝"
echo -e "---------------------------------------------------------------------------------------------------"

# Variables
debianversion=$(awk -F '.' '{print $1}' < /etc/debian_version)

# Give warning if debian version is not equal to 11
if [ "$debianversion" -ne 11 ]; then
  if ! (whiptail --title "Warning" --yesno --yes-button "Continue" --no-button "Cancel" "Drupal 7 (and thereby Tripal 3) works best in Debian 11. This system is Debian $debianversion. Installation might not work properly in this system. But you can continue with the installation if you want." 10 56) then
    exit 1
  fi
fi

# Initialize variables
memorylimit=""
psqldb=""
psqluser=""
PGPASSWORD=""
drupalsitedir=""

# Get user input
while true; do
    # Use whiptail to create a TUI for entering username and password
    memorylimit=$(whiptail --title "User Input" --inputbox "How much memory to allocate to the website (in MB)? " 10 50 3>&1 1>&2 2>&3) && export memorylimit
    psqldb=$(whiptail --title "User Input" --inputbox "Enter the name for a new database for our website: " 10 50 3>&1 1>&2 2>&3) && export psqldb
    psqluser=$(whiptail --title "User Input" --inputbox "Enter a new username (role) for postgres: " 10 50 3>&1 1>&2 2>&3) && export psqluser
    PGPASSWORD=$(whiptail --title "User Input" --passwordbox "Enter a password for the new user: " 10 50 3>&1 1>&2 2>&3) && export PGPASSWORD
    drupalsitedir=$(whiptail --title "User Input" --inputbox "Enter the name of the directory to which drupal website needs to be installed: " 10 50 3>&1 1>&2 2>&3) && export drupalsitedir

    # Check the exit status
    if [ $? -eq 0 ]; then
        # Ask the user if they want to change the data
        if (whiptail --defaultno --yesno "Do you want to change the data?\n\nMemory Limit: $memorylimit\nDatabase Name: $psqldb\nDatabase User: $psqluser\nDatabase Password: $PGPASSWORD\nDrupal Website Directory: $drupalsitedir" 15 50) then
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

# Postgres setup
sudo apt-get update && sudo apt-get -y install postgresql
sudo -u postgres createuser "$psqluser"
sudo -u postgres createdb "$psqldb"
sudo -u postgres psql -c "alter user $psqluser with encrypted password '$PGPASSWORD';"
sudo -u postgres psql -c "grant all privileges on database $psqldb to $psqluser ;"

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Executing scripts
./scripts/1-base-setup.sh
./scripts/2-drush-install.sh
./scripts/3-postgres-setup.sh
./scripts/4-drupal-install.sh
./scripts/5-cron-automation.sh
./scripts/6-tripal-install.sh
./scripts/7-daemon-install.sh
./scripts/8-blast-install.sh
./scripts/9-jbrowse-install.sh

# Unset PGPASSWORD
unset PGPASSWORD

# End
if whiptail --title "Installation Complete" --yesno --no-button "Later" "Reboot the system for site installation to fully take effect. Reboot now?" 8 50; then
  sudo reboot
fi
