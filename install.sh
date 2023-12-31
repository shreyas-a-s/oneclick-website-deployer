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

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Source functions
for fn in ./functions/*; do
  . "$fn"
done

# Check environment
_is_os_supported        # Check if the OS is on the supported list
_is_internet_available  # Check if system is connected to internet

# Prepare environment
_install_whiptail             # Install whiptail program that poweres the script
_set_whiptail_colors_default  # Apply default whiptail colors

# Display the "About Us" page on the screen
./show-about-us-page.sh

# Prompt the user to enter inputs
while true; do
  _input_db_credentials  # PostgreSQL Database credentials
  _input_drupal_dir      # Directory to which drupal should be installed
  _input_memory_limit    # Maximum amount of memory a PHP script can consume
  # Give user option to edit choices
  whiptail --title "USER SELECTION" --yesno \
    --defaultno \
    "Database Name: $psqldb\
    \nDatabase User: $psqluser\
    \nDatabase Password: $HIDDEN_PGPASSWORD\
    \nDrupal Website Directory: $DRUPAL_HOME/$drupalsitedir\
    \nMemory Limit: $memorylimit""MB\
    \n\n          Do you want to edit the data?\
    \n     (ARROW KEYS to move, ENTER to confirm)" \
    15 53
  exitstatus=$?
  if [ $exitstatus  = 0 ]; then
    continue
  else
    break
  fi
done

# Prompt user to choose which website components to install
website_components=$(whiptail --title "COMPONENTS SELECTION" --checklist \
  "\n         Choose which website components to install\
  \n  (ARROW KEYS to move, SPACE to select, ENTER to confirm):" 13 64 4 \
  "Webform" "[Drupal module used to create Forms]" OFF \
  "Tripal Daemon" "[To automatically execute Tripal Jobs]" OFF \
  "Tripal Blast" "[Interface for using NCBI Blast+]" OFF \
  "Tripal JBrowse" "[Integrate GMOD JBrowse with Tripal]" OFF \
  3>&1 1>&2 2>&3)

# Custom scripts
./scripts/install-web-server.sh
./scripts/install-psql.sh
./scripts/install-drupal.sh
./scripts/setup-cron.sh
./scripts/install-tripal.sh

  if echo $website_components | grep -q 'Webform'; then
    ./scripts/install-webform.sh
  fi
  if echo $website_components | grep -q 'Tripal Daemon'; then
    ./scripts/install-tripal-daemon.sh
  fi
  if echo $website_components | grep -q 'Tripal Blast'; then
    ./scripts/install-tripal-blast.sh
    ./scripts/setup-sample-blast-db.sh
  fi
  if echo $website_components | grep -q 'Tripal JBrowse'; then
    ./scripts/install-tripal-jbrowse.sh
  fi
fi

# Unset PGPASSWORD
unset PGPASSWORD

# Provide users the option for an automatic system reboot
./scripts/auto-system-reboot.sh

