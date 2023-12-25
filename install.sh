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

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Pre-deployment scripts
. ./whiptail-colors.sh         # Apply custom colors to Whiptail windows
./install-whiptail.sh          # Install whiptail
./show-about-page.sh           # Display info
./check-if-os-is-supported.sh  # Check if the Operating System is supported
./get-user-input.sh            # Get user input

# Deployment scripts
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

# Post-deployment scripts
./choice-to-reboot.sh  # Give user a choice of whether to automatically reboot the system or not

