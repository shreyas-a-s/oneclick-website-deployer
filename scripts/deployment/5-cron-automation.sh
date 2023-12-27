#!/bin/bash

# Display task name
echo -e '\n+---------------------------+'
echo '|   Cron Automation Setup   |'
echo '+---------------------------+'

# Variables
DRUPAL_HOME=/var/www/html

# Get user input
if [[ -z ${drupalsitedir} ]]; then
  read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi

# Store drupal cron key into new variable
drupal_cron_key=$(drush variable-get cron_key --root="$DRUPAL_HOME"/"$drupalsitedir" | awk '{print $2}')

# Installation
echo "0,30 * * * * /usr/bin/wget -O - -q http://localhost/""$drupalsitedir""/cron.php?cron_key=""$drupal_cron_key" | sudo tee /etc/cron.d/drupal-cron-tasks > /dev/null
whiptail --title "Cron Run" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/admin/config/system/cron\n2. Set the drop down value titled 'Run cron every' to 'Never' and save the configuration.\n3. Hit 'OK' after completing these steps." 10 65
if wget -O - -q http://localhost/"$drupalsitedir"/cron.php?cron_key="$drupal_cron_key"; then
  echo "Cron Setup Successful."
fi
