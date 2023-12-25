#!/bin/bash

#  ██████╗ ███╗   ██╗███████╗     ██████╗██╗     ██╗ ██████╗██╗  ██╗    ████████╗██████╗ ██╗██████╗  █████╗ ██╗         ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
# ██╔═══██╗████╗  ██║██╔════╝    ██╔════╝██║     ██║██╔════╝██║ ██╔╝    ╚══██╔══╝██╔══██╗██║██╔══██╗██╔══██╗██║         ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
# ██║   ██║██╔██╗ ██║█████╗█████╗██║     ██║     ██║██║     █████╔╝        ██║   ██████╔╝██║██████╔╝███████║██║         ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
# ██║   ██║██║╚██╗██║██╔══╝╚════╝██║     ██║     ██║██║     ██╔═██╗        ██║   ██╔══██╗██║██╔═══╝ ██╔══██║██║         ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
# ╚██████╔╝██║ ╚████║███████╗    ╚██████╗███████╗██║╚██████╗██║  ██╗       ██║   ██║  ██║██║██║     ██║  ██║███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚═════╝ ╚═╝  ╚═══╝╚══════╝     ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝       ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

# Developed for BharatGenomeDatabase
# By
# Shreyas A S [https://github.com/shreyas-a-s/website-tripal]
# Sastha Kumar N [https://github.com/Sastha-Kumar-N]
# Sabarinath Subramaniam [https://www.linkedin.com/in/sabarinath-subramaniam-a228014]

# Apply custom colors to Whiptail windows
. ./whiptail-colors.sh

# Install whiptail
./install-whiptail.sh

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Display info
whiptail --title "About The Script" --textbox --ok-button "Continue" about.txt 20 86

# Check if the Operating System is supported
./check-if-os-is-supported.sh

# Get user input
./get-user-input.sh

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
./choice-to-reboot.sh

