#!/usr/bin/env bash

#  ██████╗ ███╗   ██╗███████╗     ██████╗██╗     ██╗ ██████╗██╗  ██╗
# ██╔═══██╗████╗  ██║██╔════╝    ██╔════╝██║     ██║██╔════╝██║ ██╔╝
# ██║   ██║██╔██╗ ██║█████╗      ██║     ██║     ██║██║     █████╔╝ 
# ██║   ██║██║╚██╗██║██╔══╝      ██║     ██║     ██║██║     ██╔═██╗ 
# ╚██████╔╝██║ ╚████║███████╗    ╚██████╗███████╗██║╚██████╗██║  ██╗
#  ╚═════╝ ╚═╝  ╚═══╝╚══════╝     ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝

# ██████╗  █████╗ ████████╗ █████╗ ██████╗  █████╗ ███████╗███████╗
# ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝
# ██║  ██║███████║   ██║   ███████║██████╔╝███████║███████╗█████╗  
# ██║  ██║██╔══██║   ██║   ██╔══██║██╔══██╗██╔══██║╚════██║██╔══╝  
# ██████╔╝██║  ██║   ██║   ██║  ██║██████╔╝██║  ██║███████║███████╗
# ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝

# ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗███████╗██████╗ 
# ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
# ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝ █████╗  ██████╔╝
# ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝  ██╔══╝  ██╔══██╗
# ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║   ███████╗██║  ██║
# ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝

# Developed for BharatGenomeDatabase.org (BGDB.org) by
# Shreyas A S [https://github.com/shreyas-a-s/website-tripal]
# Sastha Kumar N [https://github.com/Sastha-Kumar-N]
# Sabarinath Subramaniam [https://www.linkedin.com/in/sabarinath-subramaniam-a228014]

# Define web root folder
export DRUPAL_HOME=/var/www/html

# Source whiptail colors
if [ -f ./whiptail-colors.sh ]; then
  . ./whiptail-colors.sh
fi

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Source functions
for fn in ./functions/*; do
  . "$fn"
done

# Check environment
_is_os_supported        # Check if the OS is on the supported list
_is_internet_available  # Check if system is connected to internet
_install_whiptail       # Install whiptail program that poweres the script

# Display the "About Us" page on the screen
./show-about-us-page.sh

# Prompt the user to enter inputs
while true; do
  _input_db_credentials  # PostgreSQL Database credentials
  _input_drupal_dir      # Directory to which drupal should be installed
  _input_memory_limit    # Maximum amount of memory a PHP script can consume
  # Give user option to edit choices
  whiptail --defaultno --yesno "Do you want to edit the data?\n\nDatabase Name: $psqldb\nDatabase User: $psqluser\nDatabase Password: $HIDDEN_PGPASSWORD\nDrupal Website Directory: $drupalsitedir\nMemory Limit: $memorylimit""MB" 14 50
  exitstatus=$?
  if [ $exitstatus  = 0 ]; then
    continue
  else
    break
  fi
done

# Custom scripts
./scripts/1-base-setup.sh
./scripts/2-postgres-setup.sh
./scripts/3-drupal-install.sh
./scripts/4-install-webform.sh
./scripts/5-cron-automation.sh
./scripts/6-tripal-install.sh
./scripts/7-daemon-install.sh
./scripts/8-blast-install.sh
./scripts/9-setup-sample-blast-db.sh
./scripts/10-jbrowse-install.sh

# Unset PGPASSWORD
unset PGPASSWORD

# Provide users the option for an automatic system reboot
./scripts/auto-system-reboot.sh

