#!/bin/bash

#  ██████╗ ███╗   ██╗███████╗     ██████╗██╗     ██╗ ██████╗██╗  ██╗    ████████╗██████╗ ██╗██████╗  █████╗ ██╗         ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
# ██╔═══██╗████╗  ██║██╔════╝    ██╔════╝██║     ██║██╔════╝██║ ██╔╝    ╚══██╔══╝██╔══██╗██║██╔══██╗██╔══██╗██║         ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
# ██║   ██║██╔██╗ ██║█████╗█████╗██║     ██║     ██║██║     █████╔╝        ██║   ██████╔╝██║██████╔╝███████║██║         ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
# ██║   ██║██║╚██╗██║██╔══╝╚════╝██║     ██║     ██║██║     ██╔═██╗        ██║   ██╔══██╗██║██╔═══╝ ██╔══██║██║         ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
# ╚██████╔╝██║ ╚████║███████╗    ╚██████╗███████╗██║╚██████╗██║  ██╗       ██║   ██║  ██║██║██║     ██║  ██║███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚═════╝ ╚═╝  ╚═══╝╚══════╝     ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝       ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

# One-click installer script for tripal that incorporated fixes for multiple issues the normal install has
# Developed for BharatGenomeDataBase by @shreyas-a-s [https://github.com/shreyas-a-s/website-tripal]
# Guided by @Sastha-Kumar-N [https://github.com/Sastha-Kumar-N]
# Mentored by 

# Minimalistic whiptail colorscheme taken from https://github.com/op/whiplash/blob/master/lamenting
export NEWT_COLORS='
root=white,gray
window=white,lightgray
border=black,lightgray
shadow=white,black
button=black,green
actbutton=black,red
compactbutton=black,
title=black,
roottext=black,magenta
textbox=black,lightgray
acttextbox=gray,white
entry=lightgray,gray
disentry=gray,lightgray
checkbox=black,lightgray
actcheckbox=black,green
emptyscale=,black
fullscale=,red
listbox=black,lightgray
actlistbox=lightgray,gray
actsellistbox=black,green
'

# Variables
debianversion=$(awk -F '.' '{print $1}' < /etc/debian_version)

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Display info
whiptail --title "About The Script" --textbox --ok-button "Continue" about.txt 18 86

# Give warning if debian version is not equal to 11
if [ "$debianversion" -ne 11 ] && ! whiptail --title "Warning" --yesno --yes-button "Continue" --no-button "Cancel" "Drupal 7 (and thereby Tripal 3) works best in Debian 11. This system is Debian $debianversion. Installation might not work properly in this system. But you can continue with the installation if you want." 10 56; then
  exit 1
fi

# Get user input
while true; do
    # Use whiptail to create a TUI for entering username and password
    memorylimit=$(whiptail --title "User Input" --inputbox "\nHow much memory to allocate to the website (in MB)? " 10 46 "$memorylimit" 3>&1 1>&2 2>&3) && export memorylimit
    psqldb=$(whiptail --title "User Input" --inputbox "\nEnter the name for a new database for our website: " 10 47 "$psqldb" 3>&1 1>&2 2>&3) && export psqldb
    psqluser=$(whiptail --title "User Input" --inputbox "\nEnter a new username (role) for postgres: " 9 45 "$psqluser" 3>&1 1>&2 2>&3) && export psqluser
    PGPASSWORD=$(whiptail --title "User Input" --passwordbox "\nEnter a password for the new user: " 9 38 "$PGPASSWORD" 3>&1 1>&2 2>&3) && export PGPASSWORD
    drupalsitedir=$(whiptail --title "User Input" --inputbox "\nEnter the name of the directory to which drupal website needs to be installed: " 10 45 "$drupalsitedir" 3>&1 1>&2 2>&3) && export drupalsitedir

    # Check the exit status
    if [ $? -eq 0 ]; then
        # Ask the user if they want to change the data
        if (whiptail --defaultno --yesno "Do you want to edit the data?\n\nMemory Limit: $memorylimit\nDatabase Name: $psqldb\nDatabase User: $psqluser\nDatabase Password: $PGPASSWORD\nDrupal Website Directory: $drupalsitedir" 14 50) then
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
if whiptail --title "Installation Complete" --yesno --no-button "Later" "Reboot the system for site installation to fully take effect. Reboot now?" 8 44; then
  sudo reboot
fi
